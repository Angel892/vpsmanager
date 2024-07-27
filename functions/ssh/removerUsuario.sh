#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


removerUsuarioSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Eliminar cuenta SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Leer la lista de usuarios creados por el administrador
    if [ ! -f /etc/vpsmanager/users.txt ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para eliminar.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    users=$(cat /etc/vpsmanager/users.txt)

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para eliminar.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "${INFO}Usuarios disponibles:${NC}"
    
    # Crear un archivo temporal para la tabla de usuarios
    user_details="/tmp/user_details.txt"
    echo -e "${BLANCO}N°\tUsuario${NC}" > $user_details
    count=1
    
    while IFS=: read -r username password expiration_date limit; do
        echo -e "${VERDE}$count\t$username${NC}" >> $user_details
        count=$((count + 1))
    done <<< "$users"

    # Añadir la opción para salir
    echo -e "0\tSalir" >> $user_details

    # Mostrar la tabla de usuarios
    column -t -s $'\t' $user_details
    rm $user_details

    echo -e "${INFO}Seleccione el número del usuario que desea eliminar o 0 para salir:${NC}"
    read -p "Opción: " user_num

    if ! [[ "$user_num" =~ ^[0-9]+$ ]] || [ "$user_num" -lt 0 ] || [ "$user_num" -gt $count ]; then
        echo -e "${ROJO}Selección inválida. Por favor intente de nuevo.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    if [ "$user_num" -eq 0 ]; then
        echo -e "${INFO}Operación cancelada.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    username=$(echo "$users" | sed -n "${user_num}p" | awk -F: '{print $1}')

    while true; do
        read -p "Está seguro que desea eliminar al usuario '$username'? (s/n): " confirm
        case $confirm in
            [sS][iI]|[sS])
                sudo deluser --remove-home "$username"
                sudo sed -i "/^$username:/d" /etc/vpsmanager/users.txt
                if [ $? -eq 0 ]; then
                    echo -e "${VERDE}Usuario SSH '$username' eliminado exitosamente.${NC}"
                else
                    echo -e "${ROJO}Error: No se pudo eliminar al usuario '$username'.${NC}"
                fi
                break
                ;;
            [nN][oO]|[nN])
                echo -e "${INFO}Operación cancelada.${NC}"
                break
                ;;
            *)
                echo -e "${ROJO}Error: Respuesta inválida. Por favor ingrese 's' o 'n'.${NC}"
                ;;
        esac
    done

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}