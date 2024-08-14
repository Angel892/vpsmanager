#!/bin/bash

menuSiteManager() {

    local MANAGER_SITE_PATH="${functionsPath}/sitemanager"

    showCabezera "Site Manager"

    source $MANAGER_SITE_PATH/clonarRepositorio.sh
    source $MANAGER_SITE_PATH/nginxdotnet.sh
    source $MANAGER_SITE_PATH/dotnetservice.sh
    source $MANAGER_SITE_PATH/nginxvue.sh
    source $MANAGER_SITE_PATH/sslmanager.sh
    source $MANAGER_SITE_PATH/performance.sh

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

    # PERFORMANCE
    opcionMenu -blanco $num "Configuracion performance"
    option[$num]="performance"
    let num++

    msgCentradoBarra -amarillo "EXTRAS"

    # .CREATE SERVICE
    opcionMenu -blanco $num "Crear servicio .NET"
    option[$num]="dotnetservice"
    let num++

    # SSL MANAGER
    opcionMenu -blanco $num "SSL Manager"
    option[$num]="sslmanager"
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
    "nginxvue") nginxvue ;;
    "dotnetservice") dotnetservice ;;
    "sslmanager") sslmanager ;;
    "performance") performance ;;
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
