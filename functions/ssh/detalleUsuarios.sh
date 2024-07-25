#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager"

detalleUsuariosSSH() {
    clear
    echo -e "${AMARILLO}=========================${NC}"
    echo -e "${AMARILLO} INFORMACION DE USUARIOS REGISTRADOS${NC}"
    echo -e "${AMARILLO}=========================${NC}"

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

    echo -e "${AMARILLO}=========================${NC}"
    read -p "Presione Enter para continuar..."
}