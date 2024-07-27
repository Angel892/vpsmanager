#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

local MENU="DOTNET"
local MENU2="DOTNET EF"

installDotnet() {
    echo -e "${INFO}Instalando $MENU SDK...${NC}"
    sudo apt-get update

    sudo apt-get install -y dotnet-sdk-8.0
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al instalar .NET SDK.${NC}"
        return
    fi

    echo -e "${INFO}Instalando $MENU RUNTIME...${NC}"
    sudo apt-get install -y aspnetcore-runtime-8.0
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al instalar RUNTIME.${NC}"
        return
    fi

    echo -e "${SECUNDARIO}$MENU instalado.${NC}"
    read -p "Presione Enter para continuar..."
}

uninstallDotnet() {
    echo -e "${INFO}Desinstalando $MENU...${NC}"

    echo -e "${INFO}Removiendo dependencias...${NC}"

    sudo apt-get remove --purge -y dotnet-sdk-8.0
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al desinstalar .NET SDK.${NC}"
        return
    fi

    # Desinstalar .NET Runtime
    sudo apt-get remove --purge -y aspnetcore-runtime-8.0
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al desinstalar .NET Runtime.${NC}"
        return
    fi

    echo -e "${INFO}Limpiando dependencias...${NC}"
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    echo -e "${SECUNDARIO}$MENU Desinstalado.${NC}"
    read -p "Presione Enter para continuar..."
}

installDotnetEF() {
    echo -e "${INFO}Instalando $MENU2...${NC}"

    dotnet tool install --global dotnet-ef

    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al instalar $MENU2.${NC}"
        return
    fi

    echo -e "${SECUNDARIO}$MENU2 instalado.${NC}"
    read -p "Presione Enter para continuar..."
}

uninstallDotnetEF() {
    echo -e "${INFO}Desinstalando $MENU2...${NC}"

    dotnet tool uninstall --global dotnet-ef
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al desinstalar MENU2.${NC}"
        return
    fi

    echo -e "${INFO}Limpiando dependencias...${NC}"
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    echo -e "${SECUNDARIO}$MENU2 Desinstalado.${NC}"
    read -p "Presione Enter para continuar..."
}

estadoDotnet() {
    if command -v dotnet &>/dev/null; then
        echo -e "${VERDE}.NET SDK está instalado.${NC}"
    else
        echo -e "${ROJO}.NET SDK no está instalado.${NC}"
    fi

    if command -v dotnet &>/dev/null; then
        dotnet --list-sdks | grep -q "8.0" && echo -e "${VERDE}.NET SDK 8.0 está instalado.${NC}" || echo -e "${ROJO}.NET SDK 8.0 no está instalado.${NC}"
        dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 8.0" && echo -e "${VERDE}.NET Runtime 8.0 está instalado.${NC}" || echo -e "${ROJO}.NET Runtime 8.0 no está instalado.${NC}"
    fi
}

estadoDotnetEF() {
    if dotnet tool list -g | grep -q "dotnet-ef"; then
        echo -e "${VERDE}dotnet-ef está instalado.${NC}"
    else
        echo -e "${ROJO}dotnet-ef no está instalado.${NC}"
    fi
}

menuDotnet() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    $MENU manager${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${INFO}Estado actual:${NC}"
        estadoDotnet
        estadoDotnetEF
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${SECUNDARIO}1. Instalar $MENU${NC}"
        echo -e "${SECUNDARIO}2. Instalar $MENU2${NC}"
        echo -e "${SECUNDARIO}3. Desinstalar $MENU${NC}"
        echo -e "${SECUNDARIO}4. Desinstalar $MENU2${NC}"
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"

        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) installDotnet ;;
        2) installDotnetEF ;;
        3) uninstallDotnet ;;
        4) uninstallDotnetEF ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
