#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

#--- EJECUTOR MOTITOR DE PROTOCOLOS
monitor_auto() {
    for servicex in $(cat $mainPath/temp/monitorpt); do
        rebootnb $servicex
    done
}

monitor_auto
