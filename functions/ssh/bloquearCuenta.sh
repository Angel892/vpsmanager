#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales
source $HELPERS_PATH/global.sh

bloquearDesbloquearUsuarioSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Bloquear/Desbloquear cuenta SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Leer la lista de usuarios creados por el administrador
    if [ ! -f /etc/vpsmanager/users.txt ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para bloquear/desbloquear.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    users=$(cat /etc/vpsmanager/users.txt)

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para bloquear/desbloquear.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "${INFO}Usuarios disponibles:${NC}"
    
    # Crear un archivo temporal para la tabla de usuarios
    user_details="/tmp/user_details.txt"
    echo -e "N°\tUsuario\tEstado" > $user_details
    count=1
    
    while IFS=: read -r username password expiration_date limit; do
        if sudo passwd -S "$username" | grep -q " L "; then
            status="${ROJO}Bloqueado${NC}"
        else
            status="${VERDE}Desbloqueado${NC}"
        fi
        echo -e "$count\t$username\t$status" >> $user_details
        count=$((count + 1))
    done <<< "$users"

    # Añadir la opción para salir
    echo -e "0\tSalir\t" >> $user_details

    # Mostrar la tabla de usuarios
    column -t -s $'\t' $user_details
    rm $user_details

    echo -e "${INFO}Seleccione el número del usuario que desea bloquear/desbloquear o 0 para salir:${NC}"
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

    if sudo passwd -S $username | grep -q " L "; then
        sudo passwd -u $username
        echo -e "${VERDE}Usuario SSH $username desbloqueado.${NC}"
    else
        sudo passwd -l $username
        echo -e "${ROJO}Usuario SSH $username bloqueado.${NC}"
    fi

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}