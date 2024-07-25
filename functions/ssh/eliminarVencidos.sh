#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

eliminarUsuariosVencidosSSH() {
    sudo find /home/* -maxdepth 0 -mtime +30 -exec sudo deluser --remove-home {} \;
    echo -e "${VERDE}Usuarios SSH vencidos eliminados.${NC}"
    read -p "Presione Enter para continuar..."
}