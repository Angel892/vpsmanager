#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager"

bloquearDesbloquearUsuarioSSH() {
    read -p "Ingrese el nombre del usuario: " username
    if sudo passwd -S $username | grep -q " L "; then
        sudo passwd -u $username
        echo -e "${VERDE}Usuario SSH $username desbloqueado.${NC}"
    else
        sudo passwd -l $username
        echo -e "${VERDE}Usuario SSH $username bloqueado.${NC}"
    fi
    read -p "Presione Enter para continuar..."
}
