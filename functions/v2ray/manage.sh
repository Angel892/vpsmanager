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

    # CREAR CUENTA
    opcionMenu -blanco $num "Instalar v2ray" false 2
    option[$num]="install"
    let num++

    # CREAR CUENTA TEMPORAL
    opcionMenu -blanco $num "Cambiar protocolo"
    option[$num]="protocol"
    let num++

    # REMOVER USUARIO
    opcionMenu -blanco $num "Activar tls" false 5
    option[$num]="tls"
    let num++

    # BLOQUEAR USUARIO
    opcionMenu -blanco $num "Cambiar puerto"
    option[$num]="portv"
    let num++

    # EDITAR USUARIO
    opcionMenu -blanco $num "Cambiar nombre de path"
    option[$num]="changepath"
    let num++

    msgCentradoBarra -gris "Administrar cuentas"

    # EDITAR USUARIO
    opcionMenu -blanco $num "Agregar usuario uuid"
    option[$num]="addUser"
    let num++

    # DETALLES
    opcionMenu -blanco $num "Eliminar usuario uuid"
    option[$num]="removeUser"
    let num++

    # USUARIOS CONECTADOS
    opcionMenu -blanco $num "Mostrar usuarios registrados"
    option[$num]="showUser"
    let num++

    # ELIMINAR USUARIOS VENCIDOS
    opcionMenu -blanco $num "Informacion de cuentas"
    option[$num]="info"
    let num++

    # BACKUP
    opcionMenu -blanco $num "Estadisticas de consumo"
    option[$num]="stats"
    let num++

    # BANNER
    opcionMenu -blanco $num "Limpiador de expirados"
    option[$num]="removeExp"
    let num++

    # ELIMINAR TODOS LOS USUARIOS
    opcionMenu -blanco $num "Backup / base user y json"
    option[$num]="backup"
    let num++

    # ELIMINAR TODOS LOS USUARIOS
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
