#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

removerUsuarioSSH() {
    read -p "Ingrese el nombre del usuario a eliminar: " username
    sudo deluser $username
    echo -e "${VERDE}Usuario SSH $username eliminado.${NC}"
    read -p "Presione Enter para continuar..."
}