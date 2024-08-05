#!/bin/bash

V2RAY_PATH="$functionsPath/v2ray"

#ARCHIVOS NECESARIOS
source $V2RAY_PATH/addUser.sh
source $V2RAY_PATH/backup.sh
source $V2RAY_PATH/changePath.sh
source $V2RAY_PATH/info.sh
source $V2RAY_PATH/install.sh
source $V2RAY_PATH/port.sh
source $V2RAY_PATH/protocol.sh
source $V2RAY_PATH/removeExp.sh
source $V2RAY_PATH/removeUser.sh
source $V2RAY_PATH/showUsers.sh
source $V2RAY_PATH/stats.sh
source $V2RAY_PATH/tls.sh
source $V2RAY_PATH/uninstall.sh
source $V2RAY_PATH/limitador.sh
source $V2RAY_PATH/desbloqueador.sh

menuv2ray() {

    pid_inst2() {
        [[ $1 = "" ]] && echo -e "\033[1;31m[OFF]" && return 0
        unset portas
        portas_var=$(lsof -V -i -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND")
        i=0
        while read port; do
            var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
            [[ "$(echo -e ${portas[@]} | grep "$var1 $var2")" ]] || {
                portas[$i]="$var1 $var2\n"
                let i++
            }
        done <<<"$portas_var"
        [[ $(echo "${portas[@]}" | grep "$1") ]] && echo -e "\033[1;32m[ Servicio Activo ]" || echo -e "\033[1;31m[ Servicio Desactivado ]"
    }

    showCabezera "CONTROLADOR DE V2RAY (WEBSOCKET+TLS)"
    msgCentrado -blanco "Estado actual: $(pid_inst2 v2ray)"
    msg -bar

    local num=1

    # INSTALAR
    opcionMenu -blanco $num "Instalar v2ray" false 2
    option[$num]="install"
    let num++

    # CAMBIAR PROTOCOLO
    opcionMenu -blanco $num "Cambiar protocolo"
    option[$num]="protocol"
    let num++

    # TLS
    opcionMenu -blanco $num "Activar tls" false 5
    option[$num]="tls"
    let num++

    # CAMBIAR PUERTO
    opcionMenu -blanco $num "Cambiar puerto"
    option[$num]="portv"
    let num++

    # PATH
    opcionMenu -blanco $num "Cambiar nombre de path"
    option[$num]="changepath"
    let num++

    msgCentradoBarra -gris "Administrar cuentas"

    # AGREGAR USUARIO
    opcionMenu -blanco $num "Agregar usuario uuid"
    option[$num]="addUser"
    let num++

    # REMOVER
    opcionMenu -blanco $num "Eliminar usuario uuid"
    option[$num]="removeUser"
    let num++

    # SHOW USER
    opcionMenu -blanco $num "Mostrar usuarios registrados"
    option[$num]="showUser"
    let num++

    # INFO ACCOUNT
    opcionMenu -blanco $num "Informacion de cuentas"
    option[$num]="info"
    let num++

    # STATS
    opcionMenu -blanco $num "Estadisticas de consumo"
    option[$num]="stats"
    let num++

    # LIMPIADOR DE EXPIRADOS
    VERIFYV2RAYLIMIT=$(ps x | grep -v grep | grep "limitadorv2ray")
    [[ -z ${VERIFYV2RAYLIMIT} ]] && monitorv2raylimit="\033[93m[ \033[1;31mOFF \033[93m]" || monitorv2raylimit="\033[93m[\033[1;32m ON \033[93m]"
    opcionMenu -blanco $num "Limitador de conexiones" false 2 && echo -e "${monitorv2raylimit}"
    option[$num]="limitador"
    let num++

    # DESBLOQUEO AUTOMATICO
    VERIFYV2RAYDESBLOQUEO=$(ps x | grep -v grep | grep "desbloqueadorv2ray")
    [[ -z ${VERIFYV2RAYDESBLOQUEO} ]] && monitorv2raydesbloqueo="\033[93m[ \033[1;31mOFF \033[93m]" || monitorv2raydesbloqueo="\033[93m[\033[1;32m ON \033[93m]"
    opcionMenu -blanco $num "Desbloqueador automatico" false 2 && echo -e "${monitorv2raydesbloqueo}"
    option[$num]="desbloqueador"
    let num++

    # LIMPIADOR DE EXPIRADOS
    VERIFYV2RAYEXP=$(ps x | grep -v grep | grep "limv2ray")
    [[ -z ${VERIFYV2RAYEXP} ]] && monitorv2rayexp="\033[93m[ \033[1;31mOFF \033[93m]" || monitorv2rayexp="\033[93m[\033[1;32m ON \033[93m]"
    opcionMenu -blanco $num "Limpiador de expirados" false 2 && echo -e "${monitorv2rayexp}"
    option[$num]="removeExp"
    let num++

    # BACKUP
    opcionMenu -blanco $num "Backup / base user y json"
    option[$num]="backup"
    let num++

    # DESINSTALAR
    opcionMenu -rojo $num "Desinstalar v2ray"
    option[$num]="unistallv2"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "install") intallv2ray ;;
    "protocol") protocolv2ray ;;
    "tls") tls ;;
    "portv") portv ;;
    "stats") stats ;;
    "unistallv2") unistallv2 ;;
    "info") infocuenta ;;
    "changepath") changepath ;;
    "addUser") addusr ;;
    "removeUser") delusr ;;
    "showUser") mosusr_kk ;;
    "removeExp") limpiador_activador ;;
    "limitador") limitadorv2ray ;;
    "desbloqueador") desbloqueadorv2ray ;;
    "backup") backup_fun ;;
    "unistallv2") unistallv2 ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuv2ray
}
