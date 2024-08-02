#!/bin/bash

#--- FUNCION AUTO LIMPIEZA Y FRESH RAM
autolimpieza_fun() {
    showCabezera "AUTO MANTENIMIENTO"

    PIDVRF4="$(ps aux | grep "autolimpieza" | grep -v grep | awk '{print $2}')"
    if [[ -z $PIDVRF4 ]]; then
        msgCentrado -blanco "Se procedera cada 12 hrs a"
        echo ""
        msg -verde " >> Actulizar Paquetes"
        msg -verde " >> Remover Paquetes Obsoletos"
        msg -verde " >> Se Limpiara Cache sys/temp "
        msg -verde " >> Se Refrescara RAM"
        msg -verde " >> Se Refrescara SWAP"
        msg -verde " >> Limpieza de VRAM de v2ray (Si esta Activo)"
        echo ""
        screen -dmS autolimpieza watch -n 43200 $mainPath/auto/clean.sh
    else
        screen -S autolimpieza -p 0 -X quit
    fi
    msg -bar
    [[ -z ${VERY4} ]] && autolim="\033[1;32m ACTIVADO " || autolim="\033[1;31m DESACTIVADO "
    echo -e "            $autolim  --  CON EXITO"
    msgSuccess
}
