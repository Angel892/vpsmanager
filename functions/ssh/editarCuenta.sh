#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

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

    clear
    echo -e "${INFO}Detalles actuales del usuario '$username':${NC}"
    sudo chage -l $username

    echo -e "${INFO}Puede editar los detalles de la cuenta utilizando los siguientes comandos:${NC}"
    echo -e "${BLANCO}1. Cambiar contraseña: sudo passwd $username${NC}"
    echo -e "${BLANCO}2. Cambiar fecha de expiración: sudo chage -E YYYY-MM-DD $username${NC}"
    echo -e "${BLANCO}3. Cambiar límite de conexiones: sudo sed -i 's/$username hard maxlogins [0-9]*/$username hard maxlogins NEW_LIMIT/' /etc/security/limits.conf${NC}"

    echo -e "${INFO}¿Desea cambiar la contraseña, la fecha de expiración o el límite de conexiones?${NC}"
    echo -e "${BLANCO}1. Cambiar contraseña${NC}"
    echo -e "${BLANCO}2. Cambiar fecha de expiración${NC}"
    echo -e "${BLANCO}3. Cambiar límite de conexiones${NC}"
    echo -e "${BLANCO}4. Salir${NC}"

    read -p "Seleccione una opción: " option
    case $option in
        1)
            read -s -p "Ingrese la nueva contraseña: " new_password
            echo "$username:$new_password" | sudo chpasswd
            echo -e "${VERDE}Contraseña cambiada con éxito.${NC}"
            ;;
        2)
            read -p "Ingrese la nueva fecha de expiración (YYYY-MM-DD): " new_expiration_date
            sudo chage -E $new_expiration_date $username
            echo -e "${VERDE}Fecha de expiración cambiada con éxito.${NC}"
            ;;
        3)
            read -p "Ingrese el nuevo límite de conexiones: " new_limit
            sudo sed -i "s/$username hard maxlogins [0-9]*/$username hard maxlogins $new_limit/" /etc/security/limits.conf
            echo -e "${VERDE}Límite de conexiones cambiado con éxito.${NC}"
            ;;
        4)
            echo -e "${INFO}Operación cancelada.${NC}"
            ;;
        *)
            echo -e "${ROJO}Selección inválida. Por favor intente de nuevo.${NC}"
            ;;
    esac

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}