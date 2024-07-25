#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

editarCuentaSSH() {
    read -p "Ingrese el nombre del usuario: " username
    sudo chage -l $username
    echo -e "${VERDE}Puede editar los detalles de la cuenta utilizando comandos como 'chage' o 'passwd'.${NC}"
    read -p "Presione Enter para continuar..."
}