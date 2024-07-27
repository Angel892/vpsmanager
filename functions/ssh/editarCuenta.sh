#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


editarCuentaSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Editar cuenta SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Leer la lista de usuarios creados por el administrador
    if [ ! -f /etc/vpsmanager/users.txt ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para editar.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    users=$(cat /etc/vpsmanager/users.txt)

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para editar.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "${INFO}Usuarios disponibles:${NC}"
    
    # Crear un archivo temporal para la tabla de usuarios
    user_details="/tmp/user_details.txt"
    echo -e "N°\tUsuario" > $user_details
    count=1
    
    while IFS=: read -r username password expiration_date limit; do
        echo -e "$count\t$username" >> $user_details
        count=$((count + 1))
    done <<< "$users"

    # Añadir la opción para salir
    echo -e "0\tSalir" >> $user_details

    # Mostrar la tabla de usuarios
    column -t -s $'\t' $user_details
    rm $user_details

    echo -e "${INFO}Seleccione el número del usuario que desea editar o 0 para salir:${NC}"
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
    password=$(echo "$users" | sed -n "${user_num}p" | awk -F: '{print $2}')
    expiration_date=$(echo "$users" | sed -n "${user_num}p" | awk -F: '{print $3}')
    limit=$(echo "$users" | sed -n "${user_num}p" | awk -F: '{print $4}')

    clear
    echo -e "${INFO}Detalles actuales del usuario '$username':${NC}"
    echo -e "${BLANCO}Usuario: $username${NC}"
    echo -e "${BLANCO}Contraseña: $password${NC}"
    echo -e "${BLANCO}Fecha de expiración: $expiration_date${NC}"
    echo -e "${BLANCO}Límite de conexiones: $limit${NC}"

    echo -e "${INFO}Seleccione la opción que desea cambiar:${NC}"
    echo -e "${BLANCO}1. Cambiar contraseña${NC}"
    echo -e "${BLANCO}2. Cambiar fecha de expiración (en días)${NC}"
    echo -e "${BLANCO}3. Cambiar límite de conexiones${NC}"
    echo -e "${BLANCO}4. Salir${NC}"

    read -p "Seleccione una opción: " option

    # Obtener la IP del servidor
    server_ip=$(hostname -I | awk '{print $1}')

    case $option in
        1)
            while true; do
                read -s -p "Ingrese la nueva contraseña: " new_password
                echo
                if [ -z "$new_password" ]; then
                    echo -e "${ROJO}Error: La contraseña no puede estar vacía.${NC}"
                elif [[ ${#new_password} -lt 8 ]]; then
                    echo -e "${ROJO}Error: La contraseña debe tener al menos 8 caracteres.${NC}"
                else
                    break
                fi
            done
            echo "$username:$new_password" | sudo chpasswd
            sudo sed -i "s/^$username:[^:]*:/$username:$new_password:/" /etc/vpsmanager/users.txt
            echo -e "${VERDE}Contraseña cambiada con éxito.${NC}"
            ;;
        2)
            while true; do
                read -p "Ingrese la nueva duración de la cuenta (en días): " new_duration
                if ! [[ "$new_duration" =~ ^[0-9]+$ ]]; then
                    echo -e "${ROJO}Error: La duración debe ser un número válido.${NC}"
                else
                    break
                fi
            done
            new_expiration_date=$(date -d "+${new_duration} days" +%Y-%m-%d)
            sudo chage -E "$new_expiration_date" $username
            sudo sed -i "s/^$username:[^:]*:[^:]*:/$username:$password:$new_expiration_date:/" /etc/vpsmanager/users.txt
            echo -e "${VERDE}Fecha de expiración cambiada con éxito.${NC}"
            ;;
        3)
            while true; do
                read -p "Ingrese el nuevo límite de conexiones: " new_limit
                if ! [[ "$new_limit" =~ ^[0-9]+$ ]]; then
                    echo -e "${ROJO}Error: El límite debe ser un número válido.${NC}"
                else
                    break
                fi
            done
            sudo sed -i "s/$username hard maxlogins [0-9]*/$username hard maxlogins $new_limit/" /etc/security/limits.conf
            sudo sed -i "s/^$username:[^:]*:[^:]*:[^:]*$/$username:$password:$expiration_date:$new_limit/" /etc/vpsmanager/users.txt
            echo -e "${VERDE}Límite de conexiones cambiado con éxito.${NC}"
            ;;
        4)
            echo -e "${INFO}Operación cancelada.${NC}"
            read -p "Presione Enter para continuar..."
            return
            ;;
        *)
            echo -e "${ROJO}Selección inválida. Por favor intente de nuevo.${NC}"
            read -p "Presione Enter para continuar..."
            return
            ;;
    esac

    # Mostrar los nuevos detalles del usuario
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}Nuevos detalles de la cuenta${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${VERDE}IP del servidor: ${NC}$server_ip"
    echo -e "${VERDE}Usuario: ${NC}$username"
    echo -e "${VERDE}Contraseña: ${NC}$new_password"
    echo -e "${VERDE}Fecha de expiración: ${NC}$new_expiration_date"
    echo -e "${VERDE}Límite de conexiones: ${NC}$new_limit"
    echo -e "${PRINCIPAL}=========================${NC}"

    read -p "Presione Enter para continuar..."
}