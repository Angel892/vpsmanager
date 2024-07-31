#!/bin/bash

bloquearDesbloquearUsuarioSSH() {
    clear && clear
    msg -bar

    block_userfun() {
        local USRloked="$mainPath/temp/userlock"
        validarArchivo "$USRloked"
        local LIMITERLOG="$mainPath/temp/Limiter.log"
        validarArchivo "$LIMITERLOG"
        local LIMITERLOG2="$mainPath/temp/Limiter2.log"
        validarArchivo "$LIMITERLOG2"


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
            # droplim=`droppids|grep -w "$1"|cut -d'|' -f2`
            # kill -9 $droplim &>/dev/null
            droplim=$(dropbear_pids | grep -w "$1" | cut -d'|' -f2)
            kill -9 $droplim &>/dev/null
            echo $1 >>${USRloked}
            return 0
        fi
    }

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivas
    if [[ -e "$mainPath/cuentasactivas" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivas)
    fi

    GetAllUsersBlock

    msg -bar
    msgCentrado -amarillo "Escriba o Seleccione un Usuario"
    msg -bar
    unset selection

    while [[ ${selection} = "" ]]; do
        echo -ne "\033[1;97m No. \e[1;32m" && read selection
        tput cuu1 && tput dl1
    done

    if [[ ! $(echo "${selection}" | egrep '[^0-9]') ]]; then
        usuario_del="${mostrar_totales[$selection]}"
    else
        usuario_del="$selection"
    fi

    [[ -z $usuario_del ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        bloquearDesbloquearUsuarioSSH
    }
    [[ ! $(echo ${mostrar_totales[@]} | grep -w "$usuario_del") ]] && {
        msg -rojo "error, Usuario Invalido"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        bloquearDesbloquearUsuarioSSH
    }
    msgne -amarillo "Usuario Seleccionado: " && echo -ne "$usuario_del"

    block_userfun "$usuario_del" && msg -rojo "[ Bloqueado ]" || msg -verd "[ Desbloqueado ]"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    menuSSH
}
