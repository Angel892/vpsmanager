#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MENU="NODE JS"

installNodeJS() {
    echo -e "${INFO}Instalando Node.js y npm...${NC}"

    # Actualizar los repositorios de paquetes
    sudo apt-get update
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al actualizar los repositorios.${NC}"
        return
    fi

    # Instalar Node.js
    sudo apt-get install -y nodejs
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al instalar Node.js.${NC}"
        return
    fi

    # Instalar npm
    sudo apt-get install -y npm
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al instalar npm.${NC}"
        return
    fi

    echo -e "${SECUNDARIO}Node.js y npm instalados correctamente.${NC}"
    read -p "Presione Enter para continuar..."
}

uninstallNodeJS() {
    echo -e "${INFO}Desinstalando Node.js y npm...${NC}"

    # Eliminar Node.js y npm
    sudo apt-get remove --purge -y nodejs npm
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al desinstalar Node.js y npm.${NC}"
        return
    fi

    # Limpiar dependencias no necesarias
    sudo apt-get autoremove -y
    sudo apt-get autoclean

    echo -e "${SECUNDARIO}Node.js y npm desinstalados correctamente.${NC}"
    read -p "Presione Enter para continuar..."
}


estadoNodeJS() {
    if command -v node &> /dev/null; then
        echo -e "${VERDE}Node.js está instalado.${NC}"
    else
        echo -e "${ROJO}Node.js no está instalado.${NC}"
    fi

    if command -v npm &> /dev/null; then
        echo -e "${VERDE}npm está instalado.${NC}"
    else
        echo -e "${ROJO}npm no está instalado.${NC}"
    fi
}

menuNodeJS() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    $MENU manager${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${INFO}Estado actual:${NC}"
        estadoNodeJS
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${SECUNDARIO}1. Instalar $MENU${NC}"
        echo -e "${SECUNDARIO}2. Desinstalar $MENU${NC}"
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"

        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) installNodeJS ;;
        2) uninstallNodeJS ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
