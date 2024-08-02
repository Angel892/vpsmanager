#!/bin/bash

mainPath="/etc/vpsmanager"

#---------------------------AUTO INICIO---------------------------#

# REINICIO DE BADVPN
reset_badvpn() {
    portasx=$(cat $mainPath/PortM/Badvpn.log)
    totalporta=($portasx)
    for ((i = 0; i < ${#totalporta[@]}; i++)); do
        screen -dmS badvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:${totalporta[$i]} --max-clients 1000 --max-connections-for-client 10
    done
}
if [[ "$1" = "resetbadvpn" ]]; then
    reset_badvpn >/dev/null 2>&1
    exit
fi

# AUTO WEBSOKET
reset_psoket() {
    for portdic in $(cat $mainPath/PortM/PDirect.log); do
        screen -dmS pydic-"$portdic" python $mainPath/filespy/PDirect-$portdic.py
    done
}
if [[ "$1" = "resetwebsocket" ]]; then
    reset_psoket >/dev/null 2>&1
    exit
fi

# LIMPIADOR AUTOMATICO
limpiadorAuto() {
    screen -dmS autolimpieza watch -n 43200 $mainPath/auto/clean.sh
}
if [[ "$1" = "limpiador" ]]; then
    limpiadorAuto >/dev/null 2>&1
    exit
fi

# AUTO MONITOR PROTO
resetprotos_fun() {
    tiemmoni=$(cat $mainPath/temp/T-Mon)
    screen -dmS monitorproto watch -n $tiemmoni $mainPath/auto/monitorServicios.sh
}
if [[ "$1" = "resetprotos" ]]; then
    resetprotos_fun >/dev/null 2>&1
    exit
fi

# AUTO LIMITADOR
resetlimitador_fun() {
    tiemlim=$(cat $mainPath/temp/T-Lim)
    screen -dmS limitador watch -n $tiemlim $mainPath/auto/limitador.sh
}
if [[ "$1" = "resetlimitador" ]]; then
    resetlimitador_fun >/dev/null 2>&1
    exit
fi

# AUTO DESBLOQUEO
resetdesbloqueador_fun() {
    tiemdes=$(cat $mainPath/temp/T-Des)
    screen -dmS desbloqueador watch -n $tiemdes $mainPath/auto/desbloqueo.sh
}
if [[ "$1" = "resetdesbloqueador" ]]; then
    resetdesbloqueador_fun >/dev/null 2>&1
    exit
fi

#---------------------------MONITOR DE PROTOCOLOS---------------------------#

#--- REINICIAR SSH
reset_ssh() {

    # BACKUP DIARIO
    find $mainPath/temp/BackTotal -mmin +1440 -type f -delete >/dev/null 2>&1
    [[ -e $mainPath/temp/BackTotal ]] || {

        rm -rf /root/Backup-LX.tar.gz >/dev/null 2>&1
        mkdir /root/backup-LX/
        export UGIDLIMIT=1000
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd >/root/backup-LX/passwd.mig
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group >/root/backup-LX/group.mig
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - | egrep -f - /etc/shadow >/root/backup-LX/shadow.mig
        cp /etc/gshadow /root/backup-LX/gshadow.mig >/dev/null 2>&1
        cp $mainPath/cuentassh /root/backup-LX/cuentassh >/dev/null 2>&1
        cp $mainPath/cuentahwid /root/backup-LX/cuentahwid >/dev/null 2>&1
        cp $mainPath/cuentatoken /root/backup-LX/cuentatoken >/dev/null 2>&1
        cp $mainPath/temp/.passw /root/backup-LX/.passw >/dev/null 2>&1
        tar -zcvpf /root/backup-LX/home.tar.gz /home >/dev/null 2>&1
        cd /root
        tar -czvf Backup-LX.tar.gz backup-LX >/dev/null 2>&1
        echo "Backup Diario Activo | $Fecha " >$mainPath/temp/BackTotal
    } &>/dev/null

    SSH=$(ps x | grep "/usr/sbin/sshd" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $SSH ]]; then
        service ssh restart
        msg_service SSH
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetssh" ]]; then
    reset_ssh >/dev/null 2>&1
    exit
fi

#--- REINICIAR SSL
reset_ssl() {
    SSL=$(ps x | grep "stunnel4" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $SSL ]]; then
        service stunnel4 restart
        msg_service SSL
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetssl" ]]; then
    reset_ssl >/dev/null 2>&1
    exit
fi

#--- REINICIAR DROPBEAR
reset_drop() {
    DROPBEAR=$(ps x | grep "/usr/sbin/dropbear" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $DROPBEAR ]]; then
        sed -i "s/=1/=0/g" /etc/default/dropbear
        service dropbear restart
        sed -i "s/=0/=1/g" /etc/default/dropbear
        #msg_service DROPBEAR
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetdropbear" ]]; then
    reset_drop >/dev/null 2>&1
    exit
fi

#--- REINICIAR SQUID
reset_squid() {
    SQUID=$(ps x | grep "/usr/sbin/squid" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $SQUID ]]; then
        service squid restart
        msg_service SQUID
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetsquid" ]]; then
    reset_squid >/dev/null 2>&1
    exit
fi

#--- REINICIAR APACHE
reset_apache() {
    APACHE=$(ps x | grep "apache" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $APACHE ]]; then
        service apache2 restart
        msg_service APACHE
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetapache" ]]; then
    reset_apache >/dev/null 2>&1
    exit
fi

#--- REINICIAR V2RAY
reset_v2ray() {
    V2RAY=$(ps x | grep "v2ray" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $V2RAY ]]; then
        service v2ray restart
        msg_service V2RAY
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetv2ray" ]]; then
    reset_v2ray >/dev/null 2>&1
    exit
fi

#--- REINICIAR WEBSOCKET
reset_websocket() {
    for portdic in $(cat $mainPath/PortM/PDirect.log); do

        WEBSOCKET=$(ps x | grep "pydic-$portdic" | grep -v "grep" | awk -F "pts" '{print $1}')
        if [[ ! $WEBSOCKET ]]; then
            screen -dmS pydic-"$portdic" python $mainPath/filespy/PDirect-$portdic.py
            msg_service WEBSOCKET-$portdic
        else

            echo "ok"
        fi

    done
}
if [[ "$1" = "resetwebp" ]]; then
    reset_websocket >/dev/null 2>&1
    exit
fi
