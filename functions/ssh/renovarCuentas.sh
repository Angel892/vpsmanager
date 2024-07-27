#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales
source $HELPERS_PATH/global.sh

renovarCuentaSSH() {
    read -p "Ingrese el nombre del usuario: " username
    read -p "Ingrese la nueva duración de la cuenta (en días): " duration
    sudo chage -E $(date -d "+${duration} days" +%Y-%m-%d) $username
    echo -e "${VERDE}Cuenta SSH para $username renovada por $duration días.${NC}"
    read -p "Presione Enter para continuar..."
}
