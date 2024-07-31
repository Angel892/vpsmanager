#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"
# Enable debugging
set -x

# funciones globales
source $HELPERS_PATH/global.sh

functionsPath="$mainPath/functions"

# Incluir los archivos de funciones
source $functionsPath/actualizarScript.sh
source $functionsPath/ssh/manage.sh
source $functionsPath/eliminarScript.sh
source $functionsPath/protocols/manage.sh
source $functionsPath/monitorearRecursos.sh
source $functionsPath/autoiniciarScript.sh
source $functionsPath/puertosActivos.sh

mainMenu() {
    local num=1

    clear
    msg -bar
    msg -tit
    msg -bar
    msgCentrado -amarillo "LXMANAGER"
    msg -bar

    # SSH
    opcionMenu -amarillo $num "SSH / OPEN VPN"
    option[$num]="ssh"
    let num++

    # PROTOCOLOS
    opcionMenu -blanco $num "Instalar Protocolos" false 2
    option[$num]="protocolos"
    let num++

    # PUERTOS ACTIVOS
    opcionMenu -verde $num "Puertos activos"
    option[$num]="puertos"
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
    "protocolos") menuProtocols ;;
    "monitorear") monitorear_recursos ;;
    "actualizar") actualizar_script ;;
    "eliminar") eliminar_script ;;
    "autoIniciar") autoiniciarScript ;;
    "puertos") mostrarPuertosActivos ;;
    "volver")
        echo -e "${INFO}Saliendo...${NC}"
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        mainMenu
        ;;
    esac
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mainMenu
