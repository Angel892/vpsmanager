#!/bin/bash

menuSiteManager() {

    local MANAGER_SITE_PATH="${functionsPath}/sitemanager"
    source $MANAGER_SITE_PATH/clonarRepositorio.sh

    showCabezera "Site Manager"

    local num=1

    # CLONAR
    opcionMenu -blanco $num "Clonar repositorio"
    option[$num]="getRepositorio"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "getRepositorio") clonarRepositorio ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuSiteManager
}
