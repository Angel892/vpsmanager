#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

usuariosConectadosSSH() {
    who
    read -p "Presione Enter para continuar..."
}