#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


detalleUsuariosSSH() {
    clear
    msg -bar
    echo -e "${AMARILLO} INFORMACION DE USUARIOS REGISTRADOS${NC}"
    msg -bar

    if [ ! -f /etc/vpsmanager/users.txt ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    users=$(cat /etc/vpsmanager/users.txt)

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    # Encabezados de la tabla
    echo -e "${BLANCO}USUARIO\tCONTRASEÑA\tFECHA\t\tLIMITE${NC}" > /tmp/user_details.txt

    # Recorrer cada usuario en /etc/vpsmanager/users.txt
    while IFS=: read -r username password expiration_date limit; do
        # Calcular los días restantes
        expiration_days=$(( ($(date -d "$expiration_date" +%s) - $(date +%s)) / 86400 ))
        expiration_info="$expiration_date [${VERDE}$expiration_days días${NC}]"

        # Agregar los detalles del usuario al archivo temporal
        echo -e "${BLANCO}$username\t$password\t$expiration_info\t$limit${NC}" >> /tmp/user_details.txt
    done <<< "$users"

    # Mostrar la tabla formateada
    column -t -s $'\t' /tmp/user_details.txt
    rm /tmp/user_details.txt

    msg -bar
    read -p "Presione Enter para continuar..."
}