#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#colores
source $MAIN_PATH/helpers/colors.sh

MAIN_PATH="/etc/vpsmanager/functions/protocols";

source $MAIN_PATH/apache.sh
source $MAIN_PATH/nginx.sh


menu_protocols() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Administrar Protocolos${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${SECUNDARIO}1. Apache${NC}"
        echo -e "${SECUNDARIO}2. Nginx${NC}"
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) menuApache;;
        2) menuNginx;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
