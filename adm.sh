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
        opcionMenu $num $option "SSH / OPEN VPN" "ssh"

        # PROTOCOLOS
        echo -e "${SECUNDARIO}$num. Administrar Protocolos${NC}"
        option[$num]="protocolos"
        let num++

        # PROTOCOLOS
        echo -e "${SECUNDARIO}$num. Monitorear Recursos${NC}"
        option[$num]="monitorear"
        let num++

        # ACTUALIZAR
        echo -e "${SECUNDARIO}$num. Actualizar Script${NC}"
        option[$num]="actualizar"
        let num++

        # ELIMINAR
        echo -e "${SECUNDARIO}$num. Eliminar Script${NC}"
        option[$num]="eliminar"
        let num++

        # AUTOINICIAR
        echo -e "${SECUNDARIO}$num. Autoiniciar Script${NC}"
        option[$num]="autoIniciar"
        let num++

        # PUERTOS ACTIVOS
        echo -e "${SECUNDARIO}$num. Puertos activos${NC}"
        option[$num]="puertos"
        let num++

        echo -e "${SALIR}0. Salir${NC}"
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
