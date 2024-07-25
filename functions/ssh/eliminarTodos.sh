#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

eliminarTodosUsuariosSSH() {
    for user in $(cut -d: -f1 /etc/passwd); do
        sudo deluser --remove-home $user
    done
    echo -e "${VERDE}Todos los usuarios SSH eliminados.${NC}"
    read -p "Presione Enter para continuar..."
}