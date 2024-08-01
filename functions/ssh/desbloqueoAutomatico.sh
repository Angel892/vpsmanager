##DESBLOEUEAR
desbloqueoAutomatico() {

    showCabezera "DESBLOQUEO AUT. Y LIMPIADOR DE EXPIARDOS"

    msgCentrado -blanco "Esta opcion desbloquea a usuarios bloqueados por"
    msgCentrado -blanco "el limitador y limpia los usuarios expirados"
    msg -bar

    PIDVRF2="$(ps aux | grep "${mainPath}/helpers/desbloqueo.sh" | grep -v grep | awk '{print $2}')"
    if [[ -z $PIDVRF2 ]]; then

        msgCentrado -azul "¿Cada cuantos segundos ejecutar el desbloqueador?"
        msgCentrado -amarillo "+Segundos = -Uso de CPU | -Segundos = +Uso de CPU"
        msgCentrado -verde "Predeterminado: 120s"
        msg -bar
        msgne -blanco "Cuantos Segundos (Numeros Unicamente): " && msgne -verde ""
        read -p " " -e -i "10" tiemdes

        error() {
            msg -verm "Tiempo invalido,se ajustara a 120s (Tiempo por Defeto)"
            sleep 5s
            tput cuu1
            tput dl1
            tput cuu1
            tput dl1
            tiemdes="120"
            echo "${tiemdes}" >$mainPath/temp/T-Des
        }
        #[[ -z "$tiemdes" ]] && tiemdes="120"
        if [[ "$tiemdes" != +([0-9]) ]]; then
            error
        fi
        [[ -z "$tiemdes" ]] && tiemdes="120"
        if [ "$tiemdes" -lt "1" ]; then
            error
        fi
        echo "${tiemdes}" >$mainPath/temp/T-Des
        screen -dmS desbloqueador watch -n $tiemdes "${mainPath}/helpers/desbloqueo.sh"
        #screen -dmS very2 $mainPath/menu.sh desbloqueo
    else
        for pid in $(echo $PIDVRF2); do
            screen -S desbloqueador -p 0 -X quit
        done

    fi
    msg -bar
    [[ -z ${VERY2} ]] && desbloqueo="\033[1;32m ACTIVADO " || desbloqueo="\033[1;31m DESACTIVADO "
    echo -e "            $desbloqueo  --  CON EXITO"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
