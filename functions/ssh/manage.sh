#!/bin/bash

SSH_PATH="$functionsPath/ssh"

#ARCHIVOS NECESARIOS
source $SSH_PATH/crearCuenta.sh
source $SSH_PATH/cuentaTemporal.sh
source $SSH_PATH/detalleUsuarios.sh
source $SSH_PATH/removerUsuario.sh
source $SSH_PATH/bloquearCuenta.sh
source $SSH_PATH/editarCuenta.sh
source $SSH_PATH/usuariosConectados.sh
source $SSH_PATH/eliminarVencidos.sh
source $SSH_PATH/backup.sh
source $SSH_PATH/eliminarTodos.sh
source $SSH_PATH/renovarCuentas.sh
source $SSH_PATH/limitador.sh

menuSSH() {

    mostrar_usuarios() {
        #for u in $(awk -F : '$3 > 900 { print $1 }' /etc/passwd | grep -v "nobody" | grep -vi polkitd | grep -vi system-); do
        #    echo "$u"
        #done

        for u in $(cat $mainPath/cuentassh | cut -d'|' -f1); do
            echo "$u"
        done
    }

    unlockall2() {
        for user in $(cat /etc/passwd | awk -F : '$3 > 900 {print $1}' | grep -v "rick" | grep -vi "nobody"); do
            userpid=$(ps -u $user | awk {'print $1'})

            usermod -U $user &>/dev/null
        done
    }

    dropbear_pids() {
        local pids
        local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
        local NOREPEAT
        local reQ
        local Port
        while read port; do
            reQ=$(echo ${port} | awk '{print $1}')
            Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
            [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
            NOREPEAT+="$Port\n"
            case ${reQ} in
            dropbear)
                [[ -z $DPB ]] && local DPB=""
                DPB+="$Port "
                ;;
            esac
        done <<<"${portasVAR}"
        [[ ! -z $DPB ]] && echo -e $DPB
        #local port_dropbear="$DPB"
        local port_dropbear=$(ps aux | grep dropbear | awk NR==1 | awk '{print $17;}')
        cat /var/log/auth.log | grep -a -i dropbear | grep -a -i "Password auth succeeded" >/var/log/authday.log
        #cat /var/log/auth.log|grep "$(date|cut -d' ' -f2,3)" > /var/log/authday.log
        #cat /var/log/auth.log | tail -1000 >/var/log/authday.log
        local log=/var/log/authday.log
        local loginsukses='Password auth succeeded'
        [[ -z $port_dropbear ]] && return 1
        for port in $(echo $port_dropbear); do
            for pidx in $(ps ax | grep dropbear | grep "$port" | awk -F" " '{print $1}'); do
                pids="${pids}$pidx\n"
            done
        done
        for pid in $(echo -e "$pids"); do
            pidlogs=$(grep $pid $log | grep "$loginsukses" | awk -F" " '{print $3}')
            i=0
            for pidend in $pidlogs; do
                let i++
            done
            if [[ $pidend ]]; then
                login=$(grep $pid $log | grep "$pidend" | grep "$loginsukses")
                PID=$pid
                user=$(echo $login | awk -F" " '{print $10}' | sed -r "s/'//g")
                waktu=$(echo $login | awk -F" " '{print $2"-"$1,$3}')
                [[ -z $user ]] && continue
                echo "$user|$PID|$waktu"
            fi
        done
    }

    rm_user() {
        userdel --force "$1" &>/dev/null
    }

    openvpn_pids() {
        #nome|#loguin|#rcv|#snd|#time
        byte() {
            while read B dummy; do
                [[ "$B" -lt 1024 ]] && echo "${B} bytes" && break
                KB=$(((B + 512) / 1024))
                [[ "$KB" -lt 1024 ]] && echo "${KB} Kb" && break
                MB=$(((KB + 512) / 1024))
                [[ "$MB" -lt 1024 ]] && echo "${MB} Mb" && break
                GB=$(((MB + 512) / 1024))
                [[ "$GB" -lt 1024 ]] && echo "${GB} Gb" && break
                echo $(((GB + 512) / 1024)) terabytes
            done
        }
        for user in $(mostrar_usuarios); do
            user="$(echo $user | sed -e 's/[^a-z0-9 -]//ig')"
            [[ ! $(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log) ]] && continue
            i=0
            unset RECIVED
            unset SEND
            unset HOUR
            while read line; do
                IDLOCAL=$(echo ${line} | cut -d',' -f2)
                RECIVED+="$(echo ${line} | cut -d',' -f3)+"
                SEND+="$(echo ${line} | cut -d',' -f4)+"
                DATESEC=$(date +%s --date="$(echo ${line} | cut -d',' -f5 | cut -d' ' -f1,2,3,4)")
                TIMEON="$(($(date +%s) - ${DATESEC}))"
                MIN=$(($TIMEON / 60)) && SEC=$(($TIMEON - $MIN * 60)) && HOR=$(($MIN / 60)) && MIN=$(($MIN - $HOR * 60))
                HOUR+="${HOR}h:${MIN}m:${SEC}s\n"
                let i++
            done <<<"$(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log)"
            RECIVED=$(echo $(echo ${RECIVED}0 | bc) | byte)
            SEND=$(echo $(echo ${SEND}0 | bc) | byte)
            HOUR=$(echo -e $HOUR | sort -n | tail -1)
            echo -e "$user|$i|$RECIVED|$SEND|$HOUR"
        done
    }

    local num=1

    showCabezera "SSH MANAGER"

    # CREAR CUENTA
    opcionMenu -blanco $num "Crear cuenta"
    option[$num]="crear"
    let num++

    # CREAR CUENTA TEMPORAL
    opcionMenu -blanco $num "Crear cuenta temporal"
    option[$num]="crearTemporal"
    let num++

    # REMOVER USUARIO
    opcionMenu -blanco $num "Remover usuario"
    option[$num]="remover"
    let num++

    # BLOQUEAR USUARIO
    opcionMenu -blanco $num "Bloquear / Desbloquear usuario"
    option[$num]="bloquear"
    let num++

    # EDITAR USUARIO
    opcionMenu -blanco $num "Editar cuenta"
    option[$num]="editar"
    let num++

    # EDITAR USUARIO
    opcionMenu -blanco $num "Renovar cuenta"
    option[$num]="renovar"
    let num++

    # DETALLES
    opcionMenu -blanco $num "Detalle de todos los usuarios"
    option[$num]="detalles"
    let num++

    # USUARIOS CONECTADOS
    opcionMenu -blanco $num "Usuarios conectados"
    option[$num]="conectados"
    let num++

    # ELIMINAR USUARIOS VENCIDOS
    opcionMenu -blanco $num "Eliminar usuarios vencidos"
    option[$num]="eliminarVencidos"
    let num++

    # BACKUP
    opcionMenu -blanco $num "Backup de usuarios"
    option[$num]="backup"
    let num++

    # BANNER
    opcionMenu -blanco $num "Agregar / Eliminar banner"
    option[$num]="banner"
    let num++

    # ELIMINAR TODOS LOS USUARIOS
    opcionMenu -blanco $num "Eliminar todos los usuarios"
    option[$num]="eliminarTodos"
    let num++

    # LIMITADOR DE CUENTAS
    VERY="$(ps aux | grep "$(verif_fun)" | grep -v grep)"
    [[ -z ${VERY} ]] && verificar="\e[1;93m[\033[1;31m DESACTIVADO \e[1;93m]" || verificar="\e[1;93m[\033[1;32m ACTIVO \e[1;93m]"
    opcionMenu -blanco $num "Limitador de cuentas ${VERY}"
    option[$num]="limitador"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "crear") crearCuentaSSH ;;
    "crearTemporal") crearCuentaTemporalSSH ;;
    "remover") removerUsuarioSSH ;;
    "bloquear") bloquearDesbloquearUsuarioSSH ;;
    "editar") editarCuentaSSH ;;
    "detalles") detalleUsuariosSSH ;;
    "conectados") usuariosConectadosSSH ;;
    "eliminarVencidos") eliminarUsuariosVencidosSSH ;;
    "backup") backupUsuariosSSH ;;
    "banner") gestionarBannerSSH ;;
    "eliminarTodos") eliminarTodosUsuariosSSH ;;
    "renovar") renovarCuentaSSH ;;
    "limitador") limitadorMenu ;;
    "volver") mainMenu ;;
    *) 
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" 
        sleep 2
        menuSSH
    ;;
    esac
}
