#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"
# Enable debugging
#set -x

# funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager/functions"

# Incluir los archivos de funciones
source $MAIN_PATH/actualizarScript.sh
source $MAIN_PATH/ssh/manage.sh
source $MAIN_PATH/eliminarScript.sh
source $MAIN_PATH/protocols/manage.sh
source $MAIN_PATH/monitorearRecursos.sh
source $MAIN_PATH/autoiniciarScript.sh
source $MAIN_PATH/puertosActivos.sh

mostrar_menu() {
    while true; do
        local num=1
        local option[];

        clear
        msg -bar
        msg -tit
        msg -bar
        msgCentrado -ama "LXMANAGER"
        msg -bar

        # SSH
        opcionMenu $num "SSH / OPEN VPN"
        option[$num]="ssh"
        let num++

        # PROTOCOLOS
        opcionMenu $num "Administrar Protocolos"
        option[$num]="protocolos"
        let num++

        # PROTOCOLOS
        opcionMenu $num "Monitorear Recursos"
        option[$num]="monitorear"
        let num++

        # ACTUALIZAR
        opcionMenu $num "Actualizar Script"
        option[$num]="actualizar"
        let num++

        # AUTOINICIAR
        opcionMenu $num "Autoiniciar Script"
        option[$num]="autoIniciar"
        let num++

        # PUERTOS ACTIVOS
        opcionMenu $num "Puertos activos"
        option[$num]="puertos"
        let num++

        msg -bar

        # SALIR

        # ELIMINAR
        opcionMenu $num "|- DESINSTALAR -|" false 10
        option[$num]="eliminar"
        let num++

        opcionMenu 0 "Salir"
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
            break
            ;;
        *)
            echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
            ;;
        esac
    done
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mostrar_menu
