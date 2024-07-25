#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

backupUsuariosSSH() {
    sudo cp /etc/passwd /etc/shadow /etc/group /etc/gshadow /backup/
    echo -e "${VERDE}Backup de usuarios SSH realizado.${NC}"
    read -p "Presione Enter para continuar..."
}
