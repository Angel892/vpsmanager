#!/bin/bash

##LIMITADOR
limitadorMenu() {

    showCabezera "LIMITADOR DE CUENTAS"
    msgCentrado -amarillo "Esta Opcion Limita las Conexiones de SSH/SSL/DROPBEAR"
    msg -bar

    PIDVRF="$(ps aux | grep "${mainPath}/helpers/limitador.sh" | grep -v grep | awk '{print $2}')"

    if [[ -z $PIDVRF ]]; then
        msg -bar
        echo -ne "\033[1;96m   ¿Cada cuantos segundos ejecutar el limitador?\n\033[1;97m  +Segundos = -Uso de CPU | -Segundos = +Uso de CPU\033[0;92m \n                Predeterminado:\033[1;37m 120s\n     Cuantos Segundos (Numeros Unicamente): " && read tiemlim

        error() {
            msg -rojo "Tiempo invalido,se ajustara a 120s (Tiempo por Defeto)"
            sleep 5s
            tput cuu1
            tput dl1
            tput cuu1
            tput dl1
            tiemlim="120"
            validarArchivo "$mainPath/temp/T-Lim"
            echo "${tiemlim}" >$mainPath/temp/T-Lim

        }
        #[[ -z "$tiemlim" ]] && tiemlim="120"
        if [[ "$tiemlim" != +([0-9]) ]]; then
            error
        fi
        [[ -z "$tiemlim" ]] && tiemlim="120"
        if [ "$tiemlim" -lt "120" ]; then
            error
        fi
        echo "${tiemlim}" >$mainPath/temp/T-Lim
        screen -dmS limitador watch -n $tiemlim "${mainPath}/helpers/limitador.sh"
    else
        for pid in $(echo $PIDVRF); do
            screen -S limitador -p 0 -X quit
        done
        [[ -e $mainPath/temp/USRonlines ]] && rm $mainPath/temp/USRonlines
        [[ -e $mainPath/temp/USRexpired ]] && rm $mainPath/temp/USRexpired
        [[ -e $mainPath/temp/USRbloqueados ]] && rm $mainPath/temp/USRbloqueados
    fi
    msg -bar
    [[ -z ${VERY} ]] && verificar="\033[1;32m ACTIVADO " || verificar="\033[1;31m DESACTIVADO "
    echo -e "            $verificar  --  CON EXITO"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
