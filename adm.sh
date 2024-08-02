#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"
# Enable debugging
#set -x

# funciones globales
source $HELPERS_PATH/global.sh

functionsPath="$mainPath/functions"

# Incluir los archivos de funciones
source $functionsPath/actualizarScript.sh
source $functionsPath/ssh/manage.sh
source $functionsPath/v2ray/manage.sh
source $functionsPath/herramientas/manage.sh


source $functionsPath/main/eliminarScript.sh
source $functionsPath/main/protocols/manage.sh
source $functionsPath/main/monitorearRecursos.sh
source $functionsPath/main/autoiniciarScript.sh
source $functionsPath/main/puertosActivos.sh

mainMenu() {
    local num=1

    showCabezera "LXMANAGER"

    # SSH
    opcionMenu -amarillo $num "SSH / OPEN VPN" false 0 && msgne -blanco " |"
    option[$num]="ssh"
    let num++

    # V2RAY 
    opcionMenu -amarillo $num "V2RAY"
    option[$num]="v2ray"
    let num++

    msg -bar

    # PROTOCOLOS
    opcionMenu -blanco $num "Instalar Protocolos" false 2
    option[$num]="protocolos"
    let num++

    # PUERTOS ACTIVOS
    opcionMenu -verde $num "Puertos activos"
    option[$num]="puertos"
    let num++

    # HERRAMIENTAS
    opcionMenu -blanco $num "Herramientas"
    option[$num]="herramientas"
    let num++

    # PROTOCOLOS
    opcionMenu -blanco $num "Monitorear Recursos"
    option[$num]="monitorear"
    let num++

    # AUTOINICIAR
    opcionMenu -blanco $num "Autoiniciar Script"
    option[$num]="autoIniciar"
    let num++

    # ACTUALIZAR
    opcionMenu -verde $num "----------| Actualizar Script |----------"
    option[$num]="actualizar"
    let num++

    msg -bar

    # ELIMINAR
    opcionMenu -rojo $num "|- DESINSTALAR -|" false 4
    option[$num]="eliminar"
    let num++

    # SALIR
    opcionMenu -salir 0 "Salir" false 0
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "ssh") menuSSH ;;
    "v2ray") menuv2ray ;;
    "herramientas") menuSettings ;;
    "protocolos") menuProtocols ;;
    "monitorear") monitorear_recursos ;;
    "actualizar") actualizar_script ;;
    "eliminar") eliminar_script ;;
    "autoIniciar") autoiniciarScript ;;
    "puertos") mostrarPuertosActivos ;;
    "volver")
        exit
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    mainMenu
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mainMenu
