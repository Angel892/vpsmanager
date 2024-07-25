#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

install() {
    echo -e "${INFO}Instalando Nginx...${NC}"

    sudo apt-get update
    sudo apt-get install -y nginx

    echo -e "${SECUNDARIO}Nginx instalado.${NC}"
    read -p "Presione Enter para continuar..."
}

uninstall() {
    echo -e "${INFO}Desinstalando Nginx...${NC}"

    sudo systemctl stop nginx
    sudo apt-get remove --purge nginx nginx-common nginx-core
    sudo rm -rf /etc/nginx
    sudo apt-get autoremove
    sudo apt-get autoclean

    echo -e "${SECUNDARIO}Nginx Desinstalado.${NC}"
    read -p "Presione Enter para continuar..."
}

menuNginx() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Nginx manager${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${SECUNDARIO}1. Instalar Nginx${NC}"
        echo -e "${SECUNDARIO}2. Desinstalar Nginxe[0m"
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) install ;;
        2) uninstall ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
