#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

installNginx() {
    echo -e "${INFO}Instalando Nginx...${NC}"

    sudo apt-get update
    sudo apt-get install -y nginx

    echo -e "${SECUNDARIO}Nginx instalado.${NC}"
    read -p "Presione Enter para continuar..."
}

uninstallNginx() {
    echo -e "${INFO}Desinstalando Nginx...${NC}"
    sudo systemctl stop nginx

    echo -e "${INFO}Removiendo dependencias...${NC}"
    sudo apt-get remove -y --purge nginx nginx-common nginx-core

    echo -e "${INFO}Removiendo carpetas...${NC}"
    sudo rm -rf /etc/nginx

    echo -e "${INFO}Limpiando dependencias...${NC}"
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

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
        1) installNginx ;;
        2) uninstallNginx ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
