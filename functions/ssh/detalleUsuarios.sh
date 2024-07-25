#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager"

detalleUsuariosSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Detalles de usuarios SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    while IFS=: read -r username _ _ _ _ _ home _; do
        # Obtener la fecha de expiración
        expiration_date=$(sudo chage -l "$username" | grep "Account expires" | awk -F": " '{print $2}')
        # Obtener el límite de conexiones
        connection_limit=$(sudo grep "$username" /etc/security/limits.conf | grep "maxlogins" | awk '{print $4}')

        if [ -z "$connection_limit" ]; then
            connection_limit="Sin límite"
        fi

        # Mostrar detalles del usuario
        echo -e "${VERDE}Usuario: ${NC}$username"
        echo -e "${VERDE}Fecha de expiración: ${NC}$expiration_date"
        echo -e "${VERDE}Límite de conexiones: ${NC}$connection_limit"
        echo -e "${PRINCIPAL}=========================${NC}"
    done </etc/passwd

    read -p "Presione Enter para continuar..."
}
