#!/bin/bash

limitadorv2ray() {

    showCabezera "LIMITADOR DE CUENTAS"
    msgCentrado -blanco "Esta Opcion Limita las Conexiones de V2RAY"
    msg -bar

    PIDGEN=$(ps aux | grep -v grep | grep "limitadorv2ray")

    if [[ -z $PIDGEN ]]; then
        msgCentrado -azul "¿Cada cuantos segundos ejecutar el limitador?"
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
            validarArchivo "$mainPath/temp/v2ray-T-Lim"
            echo "${tiemlim}" >$mainPath/temp/v2ray-T-Lim

        }
        #[[ -z "$tiemlim" ]] && tiemlim="120"
        if [[ "$tiemlim" != +([0-9]) ]]; then
            error
        fi

        [[ -z "$tiemlim" ]] && tiemlim="120"
        if [ "$tiemlim" -lt "1" ]; then
            error
        fi
        echo "${tiemlim}" >$mainPath/temp/v2ray-T-Lim
        screen -dmS limitadorv2ray watch -n $tiemlim "${mainPath}/auto/limitadorconexionesv2ray.sh"
    else
        for pid in $(echo $PIDGEN); do
            screen -S limitadorv2ray -p 0 -X quit
        done
        [[ -e $mainPath/temp/USRonlines ]] && rm $mainPath/temp/USRonlines
        [[ -e $mainPath/temp/USRexpired ]] && rm $mainPath/temp/USRexpired
        [[ -e $mainPath/temp/USRbloqueados ]] && rm $mainPath/temp/USRbloqueados
    fi
    msg -bar
    [[ -z ${VERIFYV2RAYLIMIT} ]] && monitorv2raylimit="\033[1;32m ACTIVADO " || monitorv2raylimit="\033[1;31m DESACTIVADO "
    echo -e "            $monitorv2raylimit  --  CON EXITO"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
