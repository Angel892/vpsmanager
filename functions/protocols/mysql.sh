#!/bin/bash

menuMysql() {

    install() {

        showCabezera "Instalacion MYSQL"

        # INSTALANDO MYSQL
        msgInstall -blanco "Instalando mysql"
        barra_intall "apt-get install mysql-server -y"

        # INICIANDO SERVICIO MYSQL
        msgInstall -verde "Iniciando servicio mysql"
        barra_intallb "sudo systemctl start mysql.service"

        # HABILITANDO AUTOINICIO
        msgInstall -verde "Habilitando auto start"
        barra_intallb "sudo systemctl enable mysql.service"

        # SECURE INSTALATION
        msgInstall -verde "Configurar mysql de manera segura"
        sudo mysql_secure_installation

        msgSuccess

    }

    uninstall() {
        showCabezera "DESINSTALACION mysql"

        # Detener el servicio de MySQL
        msgInstall -blanco "Deteniendo mysql"
        barra_intallb "sudo systemctl stop mysql.service"

        # Eliminar los paquetes de MySQL
        msgInstall -blanco "Removiendo dependencias"
        barra_intallb "sudo apt-get remove -y --purge mysql-server mysql-client mysql-common"

        # Limpiar dependencias no necesarias
        msgInstall -blanco "Limpiando dependencias sin usar"
        barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        # Eliminar los archivos de configuración y datos
        msgInstall -blanco "Eliminando carpetas"
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
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuMysql
}
