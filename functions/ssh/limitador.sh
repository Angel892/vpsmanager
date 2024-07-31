#!/bin/bash

#-BLOQUEO
block_userfun() {
    local USRloked="$mainPath/temp/userlock"
    local LIMITERLOG="$mainPath/temp/Limiter.log"
    local LIMITERLOG2="$mainPath/temp/Limiter2.log"

    validarArchivo "$LIMITERLOG2"
    validarArchivo "$USRloked"
    validarArchivo "$LIMITERLOG"

    if [[ $2 = "-loked" ]]; then
        [[ $(cat ${USRloked} | grep -w "$1") ]] && return 1

        pkill -u $1 &>/dev/null

    fi

    if [[ $(cat ${USRloked} | grep -w "$1") ]]; then
        usermod -U "$1" &>/dev/null
        [[ -e ${USRloked} ]] && {
            newbase=$(cat ${USRloked} | grep -w -v "$1")
            [[ -e ${USRloked} ]] && rm ${USRloked}
            for value in $(echo ${newbase}); do
                echo $value >>${USRloked}
            done
        }
        [[ -e ${LIMITERLOG} ]] && [[ $(cat ${LIMITERLOG} | grep -w "$1") ]] && {
            newbase=$(cat ${LIMITERLOG} | grep -w -v "$1")
            [[ -e ${LIMITERLOG} ]] && rm ${LIMITERLOG}
            for value in $(echo ${newbase}); do
                echo $value >>${LIMITERLOG}
                echo $value >>${LIMITERLOG}
            done
        }
        return 1
    else

        usermod -L "$1" &>/dev/null

        pkill -u $1 &>/dev/null

        droplim=$(dropbear_pids | grep -w "$1" | cut -d'|' -f2)
        kill -9 $droplim &>/dev/null

        openlim=$(openvpn_pids | grep -w "$1" | cut -d'|' -f2)
        kill -9 $openlim &>/dev/null

        echo $1 >>${USRloked}
        return 0
    fi

}

verif_fun() {
    local conexao
    local limite
    local TIMEUS
    declare -A conexao
    declare -A limite
    declare -A TIMEUS
    local USRloked="$mainPath/temp/userlock"
    local LIMITERLOG="$mainPath/temp/Limiter.log"
    local LIMITERLOG2="$mainPath/temp/Limiter2.log"

    validarArchivo "$USRloked"
    validarArchivo "$LIMITERLOG"
    validarArchivo "$LIMITERLOG2"

    validarArchivo "$mainPath/temp/userexp"
    validarArchivo "$mainPath/temp/USRexpired"
    validarArchivo "$mainPath/temp/USRbloqueados"
    validarArchivo "$mainPath/temp/USRonlines"

    [[ $(dpkg --get-selections | grep -w "openssh" | head -1) ]] && local SSH=ON || local SSH=OFF
    [[ $(dpkg --get-selections | grep -w "dropbear" | head -1) ]] && local DROP=ON || local DROP=OFF
    [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && local OPEN=ON || local OPEN=OFF

    unset EXPIRED
    unset ONLINES
    unset BLOQUEADO
    local TimeNOW=$(date +%s)
    # INICIA VERIFICAȃOINICIANDO VERIFICACION

    mostrar_usuariossh() {
        for u in $(cat $mainPath/cuentassh | cut -d'|' -f1); do
            echo "$u"
        done
    }
    mostrar_usuariohwid() {
        for u in $(cat $mainPath/cuentahwid | cut -d'|' -f1); do
            echo "$u"
        done
    }
    mostrar_usuariotoken() {
        for u in $(cat $mainPath/cuentatoken | cut -d'|' -f1); do
            echo "$u"
        done
    }
    [[ -e "$mainPath/cuentassh" ]] && usuarios_ativos1=($(mostrar_usuariossh))
    [[ -e "$mainPath/cuentahwid" ]] && usuarios_ativos2=($(mostrar_usuariohwid))
    [[ -e "$mainPath/cuentatoken" ]] && usuarios_ativos3=($(mostrar_usuariotoken))
    for us in $(echo ${usuarios_ativos1[@]}); do
        echo "${us}"
    done >$mainPath/cuentasactivas
    for us in $(echo ${usuarios_ativos2[@]}); do
        echo "${us}"
    done >>$mainPath/cuentasactivas
    for us in $(echo ${usuarios_ativos3[@]}); do
        echo "${us}"
    done >>$mainPath/cuentasactivas
    mostrar_totales() {
        for u in $(cat $mainPath/cuentasactivas | cut -d'|' -f1); do
            echo "$u"
        done
    }

    echo "Hoalaa"
    return
    [[ -e "$mainPath/cuentasactivas" ]] && usuarios_totales=($(mostrar_totales))
    if [[ -z ${usuarios_totales[@]} ]]; then
        echo "" >/dev/null 2>&1
    else

        while read user; do

            ##EXPIRADOS
            local DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')

            if [[ ! -z "$(echo $DataUser | grep never)" ]]; then
                echo -e "\033[1;31mILIMITADO"
                continue
            fi

            local DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$TimeNOW" ]]; then
                EXPIRED="1+"
                [[ $(cat ${USRloked} | grep -w "$user") ]] || {

                    echo "$user" >>$mainPath/temp/userexp
                    echo "$user (EXPIRADO) $(date +%r--%d/%m/%y)" >>$LIMITERLOG2
                    echo "USER: $user (LOKED - EXPIRED) $(date +%r)" >>$LIMITERLOG
                }
                block_userfun $user -loked
                continue
            fi

            #----CONTADOR DE ONLINES
            local PID="0+"
            [[ $SSH = ON ]] && PID+="$(ps aux | grep -v grep | grep sshd | grep -w "$user" | grep -v root | wc -l 2>/dev/null)+"
            [[ $DROP = ON ]] && PID+="$(dropbear_pids | grep -w "$user" | wc -l 2>/dev/null)+"
            [[ $OPEN = ON ]] && [[ $(openvpn_pids | grep -w "$user" | cut -d'|' -f2) ]] && PID+="$(openvpn_pids | grep -w "$user" | cut -d'|' -f2)+"
            local ONLINES+="$(echo ${PID}0 | bc)+"
            echo "${ONLINES}0" | bc >$mainPath/temp/USRonlines

            #----CONTADOR DE LIMITE X USER
            local conexao[$user]="$(echo ${PID}0 | bc)"
            local limite[$user]="$(cat $mainPath/cuentassh | grep -w "${user}" | cut -d'|' -f4)"
            [[ -z "${limite[$user]}" ]] && continue
            [[ "${limite[$user]}" != +([0-9]) ]] && continue
            if [[ "${conexao[$user]}" -gt "${limite[$user]}" ]]; then
                local lock=$(block_userfun $user -loked)
                usermod -L "$user" &>/dev/null

                echo "$user (LIM-MAXIMO) $(date +%r--%d/%m/%y)" >>$LIMITERLOG
                echo "$user (LIM-MAXIMO) $(date +%r--%d/%m/%y)" >>$LIMITERLOG2
                continue
            fi

            echo "${EXPIRED}0" | bc >$mainPath/temp/USRexpired
        done <<<"$(mostrar_totales)"
    fi
    sed -i '/'-loked'/d' $mainPath/temp/userlock
    BLOQUEADO="$(wc -l $mainPath/temp/userlock | awk '{print $1}')"
    BLOQUEADO2="$(echo ${BLOQUEADO} | bc)0"
    BLOQUEADO3="/10"
    echo "${BLOQUEADO2}${BLOQUEADO3}" | bc >$mainPath/temp/USRbloqueados
    sed -i -e 's/^[ \t]*//; s/[ \t]*$//; /^$/d' $mainPath/temp/userexp
    EXPIRADO="$(wc -l $mainPath/temp/userexp | awk '{print $1}')"
    EXPIRADO2="$(echo ${EXPIRADO} | bc)0"
    EXPIRADO3="/10"
    echo "${EXPIRADO2}${EXPIRADO3}" | bc >$mainPath/temp/USRexpired

    clear
}

##LIMITADOR
limitadorMenu() {

    showCabezera "LIMITADOR DE CUENTAS"
    msgCentrado -amarillo "Esta Opcion Limita las Conexiones de SSH/SSL/DROPBEAR"
    msg -bar

    PIDVRF="$(ps aux | grep "${verif}" | grep -v grep | awk '{print $2}')"

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
        screen -dmS limitador watch -n $tiemlim $(verif_fun)
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
