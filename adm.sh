#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"
# Enable debugging
#set -x

# funciones globales
source $HELPERS_PATH/global.sh

functionsPath="$mainPath/functions"


# Incluir los archivos de funciones
source $functionsPath/ssh/manage.sh
source $functionsPath/protocols/manage.sh
source $functionsPath/v2ray/manage.sh
source $functionsPath/herramientas/manage.sh
source $functionsPath/sitemanager/manage.sh

source $functionsPath/main/actualizarScript.sh
source $functionsPath/main/eliminarScript.sh
source $functionsPath/main/monitorearRecursos.sh
source $functionsPath/main/autoiniciarScript.sh
source $functionsPath/main/puertosActivos.sh
source $functionsPath/main/autoClean.sh
source $functionsPath/main/monitor.sh
source $functionsPath/main/monitorhtop.sh

mainMenu() {

    showCabezera "LXMANAGER"

    echo -e "    \033[1;37mIP: \033[93m$(vpsIP)     \033[1;37mS.O: \033[96m$(os_system)"
    msg -bar

    local num=1

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
    opcionMenu -blanco $num "Herramientas" false 9
    option[$num]="herramientas"
    let num++

    # MONITOR HTOP
    opcionMenu -verde $num "MONITOR HTOP"
    option[$num]="monhtop"
    let num++

    # ADMINISTRADOR DE PAGINAS
    opcionMenu -blanco $num "Administrador de paginas"
    option[$num]="sitemanager"
    let num++

    # MONITOR DE RECURSOS
    opcionMenu -verde $num "Monitorear Recursos"
    option[$num]="monitorear"
    let num++

    # MONITOR DE PROTOCOLOS
    VERY3="$(ps aux | grep "${mainPath}/auto/monitorServicios.sh" | grep -v grep)"
    [[ -z ${VERY3} ]] && monitorservi="\033[93m[ \033[1;31mOFF \033[93m]" || monitorservi="\033[93m[\033[1;32m ON \033[93m]"
    opcionMenu -blanco $num "Monitor de protocolos | Autoinicios" false 2 && echo -e "${monitorservi}"
    option[$num]="monitor"
    let num++

    # AUTO CLEAN
    VERY4="$(ps aux | grep "${mainPath}/auto/clean.sh" | grep -v grep)"
    [[ -z ${VERY4} ]] && autolim="\033[93m[ \033[1;31mOFF \033[93m]" || autolim="\033[93m[\033[1;32m ON \033[93m]"
    opcionMenu -blanco $num "Auto mantenimiento" false 2 && echo -e "${autolim}"
    option[$num]="autoClean"
    let num++

    # AUTOINICIAR
    # -- CHECK AUTORUN
    [[ -e /etc/bash.bashrc-bakup ]] && AutoRun="\033[1;93m[\033[1;32m ON \033[1;93m]" || AutoRun="\033[1;93m[\033[1;31m OFF \033[1;93m]"
    opcionMenu -blanco $num "Autoiniciar Script" false 2 && echo -e "${AutoRun}"
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
    "monhtop") monhtop ;;
    "protocolos") menuProtocols ;;
    "monitorear") monitorear_recursos ;;
    "monitor") monservi_fun ;;
    "autoClean") autolimpieza_fun ;;
    "actualizar") actualizar_script ;;
    "eliminar") eliminar_script ;;
    "autoIniciar") autoiniciarScript ;;
    "puertos") mostrarPuertosActivos ;;
    "sitemanager") menuSiteManager ;;
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
