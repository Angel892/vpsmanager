#!/bin/bash

menuSiteManager() {

    local MANAGER_SITE_PATH="${functionsPath}/sitemanager"

    showCabezera "Site Manager"

    source $MANAGER_SITE_PATH/clonarRepositorio.sh
    source $MANAGER_SITE_PATH/nginxdotnet.sh
    source $MANAGER_SITE_PATH/dotnetservice.sh

    local num=1

    # CLONAR
    opcionMenu -blanco $num "Clonar repositorio manager"
    option[$num]="getRepositorio"
    let num++

    msgCentradoBarra -amarillo "NGINX"

    # .NET
    opcionMenu -blanco $num "Desplegar .net"
    option[$num]="nginxdotnet"
    let num++

    # .NET
    opcionMenu -blanco $num "Desplegar vue"
    option[$num]="nginxvue"
    let num++

    msgCentradoBarra -amarillo "EXTRAS"
    opcionMenu -blanco $num "Crear servicio .NET"
    option[$num]="dotnetservice"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "getRepositorio") clonarRepositorio ;;
    "nginxdotnet") nginxdotnet ;;
    "dotnetservice") dotnetservice ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    sleep 2

    menuSiteManager
}
