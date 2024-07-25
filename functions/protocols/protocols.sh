#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

PROTOCOLS_PATH="/etc/vpsmanager/functions/protocols"

source $PROTOCOLS_PATH/apache.sh
source $PROTOCOLS_PATH/nginx.sh
source $PROTOCOLS_PATH/dotnet.sh
source $PROTOCOLS_PATH/mysql.sh
source $PROTOCOLS_PATH/nodejs.sh

# Función para verificar el estado de Apache
estado_apache() {
    if systemctl is-active --quiet apache2; then
        mostrarActivo
    else
        mostrarInActivo
    fi
}

# Función para verificar el estado de Nginx
estado_nginx() {
    if systemctl is-active --quiet nginx; then
        mostrarActivo
    else
        mostrarInActivo
    fi
}

menu_protocols() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Administrar Protocolos${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"



        echo -e "${SECUNDARIO}1. Apache${NC} $(estado_apache)"
        echo -e "${SECUNDARIO}2. Nginx${NC} $(estado_nginx)"
        echo -e "${SECUNDARIO}3. Dotnet${NC} "
        echo -e "${SECUNDARIO}4. Mysql${NC}"
        echo -e "${SECUNDARIO}5. Node js${NC}"



        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) menuApache ;;
        2) menuNginx ;;
        3) menuDotnet ;;
        4) menuMysql ;;
        5) menuNodeJS ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
