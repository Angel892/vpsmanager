#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


local MENU="MYSQL"

installMysql() {
    echo -e "${INFO}Instalando MySQL...${NC}"

    # Actualizar los repositorios de paquetes
    sudo apt-get update
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al actualizar los repositorios.${NC}"
        return
    fi

    # Instalar MySQL Server
    sudo apt-get install -y mysql-server
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al instalar MySQL.${NC}"
        return
    fi

    # Iniciar el servicio de MySQL
    sudo systemctl start mysql.service
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al iniciar el servicio MySQL.${NC}"
        return
    fi

    # Habilitar el servicio de MySQL para que inicie al arrancar el sistema
    sudo systemctl enable mysql.service
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al habilitar el servicio MySQL.${NC}"
        return
    fi

    # Configurar MySQL de manera segura
    sudo mysql_secure_installation
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al configurar MySQL de manera segura.${NC}"
        return
    fi

    echo -e "${SECUNDARIO}MySQL instalado correctamente.${NC}"
    read -p "Presione Enter para continuar..."
}

uninstallMysql() {
    echo -e "${INFO}Desinstalando $MENU...${NC}"

    # Detener el servicio de MySQL
    sudo systemctl stop mysql.service
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al detener el servicio MySQL.${NC}"
        return
    fi

    # Eliminar los paquetes de MySQL
    sudo apt-get remove --purge -y mysql-server mysql-client mysql-common
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}Error al desinstalar los paquetes de MySQL.${NC}"
        return
    fi

    # Limpiar dependencias no necesarias
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    # Eliminar los archivos de configuración y datos
    sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

    echo -e "${SECUNDARIO}$MENU desinstalado.${NC}"
    read -p "Presione Enter para continuar..."
}

estadoMysql() {
    if command -v mysql &>/dev/null; then
        echo -e "${VERDE}MySQL está instalado.${NC}"
    else
        echo -e "${ROJO}MySQL no está instalado.${NC}"
        return 1
    fi

    if systemctl is-active --quiet mysql; then
        echo -e "${VERDE}MySQL está activo.${NC}"
    else
        echo -e "${ROJO}MySQL no está activo.${NC}"
        return 1
    fi
}

menuMysql() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    $MENU manager${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${INFO}Estado actual:${NC}"
        estadoMysql
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${SECUNDARIO}1. Instalar $MENU${NC}"
        echo -e "${SECUNDARIO}2. Desinstalar $MENU${NC}"
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"

        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) installMysql ;;
        2) uninstallMysql ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
