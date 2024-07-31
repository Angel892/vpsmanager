#!/bin/bash

menuApache() {

    install() {
        showCabezera "INSTALACION APACHE"

        msgInstall -blanco "Instalando apache2"
        barra_intall "apt-get install apache2 -y"

        msgSuccess
    }

    uninstall() {
        showCabezera "DESINSTALACION APACHE"

        sudo systemctl stop apache2

        msgInstall -blanco "Removiendo dependencias"
        barra_intallb "sudo apt-get remove --purge apache2 apache2-utils apache2-bin apache2.2-common -y"

        msgInstall -blanco "Eliminando carpetas"
        sudo rm -rf /etc/apache2 2>&1

        msgInstall -blanco "Limpiando dependencias sin usar"
        barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        msgSuccess
    }

    showCabezera "MENU APACHE"

    local num=1

    # INSTALAR
    opcionMenu -blanco $num "Instalar apache"
    option[$num]="inll"
    let num++

    # DESINSTALAR
    opcionMenu -blanco $num "Desinstalar apache"
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

    menuApache
}
