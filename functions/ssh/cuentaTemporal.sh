#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

crearCuentaTemporalSSH() {
    read -p "Ingrese el nombre del nuevo usuario: " username
    read -p "Ingrese la duración de la cuenta (en días): " duration
    sudo adduser $username
    sudo passwd $username
    sudo chage -E $(date -d "+${duration} days" +%Y-%m-%d) $username
    echo -e "${VERDE}Cuenta temporal SSH para $username creada correctamente por $duration días.${NC}"
    read -p "Presione Enter para continuar..."
}