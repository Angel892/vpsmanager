#!/bin/bash

menuNginx() {
    install() {
        showCabezera "Instalacion NGINX"

        msgInstall -blanco "Instalando nginx"
        # barra_intall "apt-get install nginx -y"
        apt-get install nginx -y

        msgSuccess
    }

    uninstall() {

        showCabezera "DESINSTALACION nginx"

        sudo systemctl stop nginx

        msgInstall -blanco "Removiendo dependencias"
        #barra_intallb "sudo apt-get remove -y --purge nginx nginx-common nginx-core"
        sudo apt-get remove -y --purge nginx nginx-common nginx-core

        msgInstall -blanco "Eliminando carpetas"
        sudo rm -rf /etc/nginx 2>&1

        msgInstall -blanco "Limpiando dependencias sin usar"
        #barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"
        sudo apt-get autoremove -y && sudo apt-get autoclean -y

        msgSuccess
    }

    showCabezera "MENU NGINX"

    local num=1

    local status=$(ps -ef | grep "nginx" | grep -v "grep" | awk -F "pts" '{print $1}')

    if [[ -z ${status} ]]; then
        # INSTALAR
        opcionMenu -blanco $num "Instalar nginx"
        option[$num]="install"
        let num++
    else
        # DESINSTALAR
        opcionMenu -blanco $num "Desinstalar nginx"
        option[$num]="uninstall"
        let num++
    fi

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

    menuNginx
}
