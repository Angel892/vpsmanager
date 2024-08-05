#!/bin/bash

desbloqueadorv2ray() {

    validarArchivo "$mainPath/temp/v2raydesbloqueo-T-Lim"

    showCabezera "DESBLOQUEADOR AUTOMATICO"
    msgCentrado -blanco "Esta Opcion Desbloquea automaticamente los usuarios v2ray"
    msg -bar

    PIDGEN=$(ps aux | grep -v grep | grep "desbloqueadorv2ray")

    if [[ -z $PIDGEN ]]; then
        msgCentrado -azul "¿Cada cuantos segundos ejecutar el desbloqueador?"
        msgCentrado -amarillo "+Segundos = -Uso de CPU | -Segundos = +Uso de CPU"
        msgCentrado -verde "Predeterminado: 120s"
        msg -bar
        msgne -blanco "Cuantos Segundos (Numeros Unicamente): " && msgne -verde ""
        read -p " " -e -i "120" tiemlim

        error() {
            msg -rojo "Tiempo invalido,se ajustara a 120s (Tiempo por Defeto)"
            sleep 5s
            tput cuu1
            tput dl1
            tput cuu1
            tput dl1
            tiemlim="120"
            echo "${tiemlim}" >$mainPath/temp/v2raydesbloqueo-T-Lim

        }
        #[[ -z "$tiemlim" ]] && tiemlim="120"
        if [[ "$tiemlim" != +([0-9]) ]]; then
            error
        fi

        [[ -z "$tiemlim" ]] && tiemlim="120"
        if [ "$tiemlim" -lt "1" ]; then
            error
        fi
        echo "${tiemlim}" >$mainPath/temp/v2raydesbloqueo-T-Lim
        screen -dmS desbloqueadorv2ray watch -n $tiemlim "${mainPath}/auto/desbloqueadorv2ray.sh"
    else
        for pid in $(echo $PIDGEN); do
            screen -S desbloqueadorv2ray -p 0 -X quit
        done
    fi
    msg -bar
    [[ -z ${VERIFYV2RAYLIMIT} ]] && monitorv2raylimit="\033[1;32m ACTIVADO " || monitorv2raylimit="\033[1;31m DESACTIVADO "
    echo -e "            $monitorv2raylimit  --  CON EXITO"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
