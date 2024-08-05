#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

desbloqueadorv2ray() {
    local blockips_file="$mainPath/v2ray/blockips"
    [[ ! -f $blockips_file ]] && touch $blockips_file

    showCabezera "DESBLOQUEO DE IPS"

    msg -amarillo "IP               | STATUS"

    while read -r ip; do
        sudo ip route del blackhole "${ip}" >/dev/null 2>&1
        msgne -blanco "${ip} | " && msg -verde "[DESBLOQUEADO]"
    done <"${blockips_file}"

    echo "" > $blockips_file
    msg -bar

}

desbloqueadorv2ray
