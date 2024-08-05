#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

desbloqueadorv2ray() {
    local blockips_file="$mainPath/v2ray/blockips"
    [[ ! -f $blockips_file ]] && touch $blockips_file

    showCabezera "DESBLOQUEO DE IPS"

    msg -amarillo "IP               | STATUS"

    while read -r ip; do
        #sudo ip route add blackhole "${ip}" >/dev/null 2>&1
        echo $ip
    done <"${blockips_file}"

    #echo "" > $logPath
    msg -bar

}

desbloqueadorv2ray
