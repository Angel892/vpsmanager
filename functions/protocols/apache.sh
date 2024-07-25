#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

#colores
source $MAIN_PATH/helpers/colors.sh

install() {
    echo -e "${INFO}Instalando Apache...${NC}"

    sudo apt-get update
    sudo apt-get install -y apache2

    echo -e "${SECUNDARIO}Apache instalado.${NC}"
    read -p "Presione Enter para continuar..."

}

uninstall() {
    echo -e "${INFO}Desinstalando Apache...${NC}"

    sudo systemctl stop apache2

    echo -e "${INFO}Removiendo dependencia...${NC}"
    sudo apt-get remove --purge apache2 apache2-utils apache2-bin apache2.2-common -y

    echo -e "${INFO}Eliminando carpetas...${NC}"
    sudo rm -rf /etc/apache2

    echo -e "${INFO}Limpiando dependencias sin usar...${NC}"
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    echo -e "${SECUNDARIO}Apache desinstalado.${NC}"
    read -p "Presione Enter para continuar..."
}

menuApache() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Apache manager${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${SECUNDARIO}1. Instalar Apache${NC}"
        echo -e "${SECUNDARIO}2. Desinstalar Apachee[0m"
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
