#!/bin/bash

menuMysql() {

    install() {

        showCabezera "Instalacion MYSQL"

        # INSTALANDO MYSQL
        msgInstall "Instalando mysql"
        barra_intall "apt-get install mysql-server -y"

        # INICIANDO SERVICIO MYSQL
        msgInstall "Iniciando servicio mysql"
        sudo systemctl start mysql.service

        # HABILITANDO AUTOINICIO
        msgInstall "Habilitando auto start"
        sudo systemctl enable mysql.service

        # SECURE INSTALATION
        msgInstall "Configurar mysql de manera segura"
        sudo mysql_secure_installation

        msgSuccess

    }

    uninstall() {
        showCabezera "DESINSTALACION mysql"

        # Detener el servicio de MySQL
        sudo systemctl stop mysql.service

        # Eliminar los paquetes de MySQL
        msgInstall "Removiendo dependencias"
        barra_intallb "sudo apt-get remove -y --purge mysql-server mysql-client mysql-common"

        # Limpiar dependencias no necesarias
        msgInstall "Limpiando dependencias sin usar"
        barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        # Eliminar los archivos de configuración y datos
        msgInstall "Eliminando carpetas"
        sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

        msgSuccess
    }

    local num=1

    showCabezera "MENU MYSQL"

    # INSTALAR
    opcionMenu -blanco $num "Instalar mysql"
    option[$num]="install"
    let num++

    # DESINSTALAR
    opcionMenu -blanco $num "Desinstalar mysql"
    option[$num]="uninstall"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "install") install ;;
    "uninstall") uninstall ;;
    "volver") return ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        menuMysql
        ;;
    esac
}
