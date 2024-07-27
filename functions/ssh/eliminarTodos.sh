#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


eliminarTodosUsuariosSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Eliminar Todos los Usuarios SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    if [ ! -f /etc/vpsmanager/users.txt ]; then
        echo -e "${ROJO}No hay usuarios registrados.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    users=$(cat /etc/vpsmanager/users.txt)

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios registrados.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "${ROJO}Usuarios registrados para eliminar:${NC}"
    
    # Crear un archivo temporal para la tabla de usuarios
    user_details="/tmp/user_details.txt"
    echo -e "N°\tUsuario" > $user_details
    count=1
    
    while IFS=: read -r username password expiration_date limit; do
        echo -e "$count\t$username" >> $user_details
        count=$((count + 1))
    done <<< "$users"

    # Mostrar la tabla de usuarios
    column -t -s $'\t' $user_details
    rm $user_details

    read -p "¿Está seguro que desea eliminar todos los usuarios listados? (s/n): " confirm
    if [[ ! $confirm =~ ^[sS][iI]|[sS]$ ]]; then
        echo -e "${AMARILLO}Operación cancelada.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    while IFS=: read -r username password expiration_date limit; do
        sudo deluser --remove-home "$username"
        if [ $? -eq 0 ]; then
            sudo sed -i "/^$username:/d" /etc/vpsmanager/users.txt
            echo -e "${VERDE}Usuario SSH '$username' eliminado exitosamente.${NC}"
        else
            echo -e "${ROJO}Error: No se pudo eliminar al usuario '$username'.${NC}"
        fi
    done <<< "$users"

    echo -e "${VERDE}Todos los usuarios SSH eliminados.${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}