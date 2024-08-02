#!/bin/bash

HERRAMIENTAS_PATH="$functionsPath/herramientas"

#ARCHIVOS NECESARIOS
#source $HERRAMIENTAS_PATH/addUser.sh

menuSettings() {

    showCabezera "Herramientas"

    local num=1

    # HABILITAR STREAMING (NETFLIX, DISNEY+, MAX, ETC)
    opcionMenu -blanco $num "HABILITAR STREAMING (NETFLIX, DISNEY+, MAX, ETC)"
    option[$num]="streaming"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "streaming") intallv2ray ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuSettings
}
