#!/bin/bash

menuApache() {

    install() {
        showCabezera "INSTALACION APACHE"

        barra_intall "apache2"
        
        msgSuccess
    }

    uninstall() {
        showCabezera "DESINSTALACION APACHE"

        sudo systemctl stop apache2

        msgInstall "Removiendo dependencias"
        barra_intallb "sudo apt-get remove --purge apache2 apache2-utils apache2-bin apache2.2-common -y"

        msgInstall "Eliminando carpetas"
        sudo rm -rf /etc/apache2 2>&1

        msgInstall "Limpiando dependencias sin usar"
        barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        msgSuccess
    }

    local num=1

    showCabezera "MENU APACHE"

    # INSTALAR
    opcionMenu -blanco $num "Instalar apache"
    option[$num]="install"
    let num++

    # DESINSTALAR
    opcionMenu -blanco $num "Desinstalar apache"
    option[$num]="unistall"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    1) install ;;
    2) uninstall ;;
    0) return ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        menuApache
        ;;
    esac
}
