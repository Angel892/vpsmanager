#!/bin/bash

renovarCuentaSSH() {

    renew_user_fun() {
        #USUARIO-DIAS
        datexp=$(date "+%F" -d " + $2 days") && valid=$(date '+%C%y-%m-%d' -d " + $2 days")
        chage -E $valid $1 2>/dev/null || return 1
        validarArchivo "$mainPath/temp/userexp"
        sed -i '/'$1'/d' $mainPath/temp/userexp 2>/dev/null
        ##-->>LECTOR DE CUENTAS
        if [[ -e "$mainPath/cuentassh" ]]; then
            readarray -t usuarios_ativos1 < <(cut -d '|' -f1 $mainPath/cuentassh)
        fi
        if [[ -e "$mainPath/cuentahwid" ]]; then
            readarray -t usuarios_ativos2 < <(cut -d '|' -f1 $mainPath/cuentahwid)
        fi
        if [[ -e "$mainPath/cuentatoken" ]]; then
            readarray -t usuarios_ativos3 < <(cut -d '|' -f1 $mainPath/cuentatoken)
        fi
        ##-->>GENERAR USUARIOS TOTALES
        cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
        if [[ -e "$mainPath/cuentasactivast" ]]; then
            readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
        fi

        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            [[ $(grep -o -i $1 $mainPath/cuentassh) ]] && {
                pass=$(cat $mainPath/cuentassh | grep -w "$1" | cut -d'|' -f2)
                limit=$(cat $mainPath/cuentassh | grep -w "$1" | cut -d'|' -f4)
                userb=$(cat $mainPath/cuentassh | grep -n -w $1 | cut -d'|' -f1 | cut -d':' -f1)
                sed -i "${userb}d" $mainPath/cuentassh
                echo "$1|$pass|${datexp}|$limit|$userb" >>$mainPath/cuentassh
            }
        fi
        #HWID
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            [[ $(grep -o -i $1 $mainPath/cuentahwid) ]] && {
                nomhwid="$(cat $mainPath/cuentahwid | grep -w "$1" | cut -d'|' -f5)"
                sed -i '/'$1'/d' $mainPath/cuentahwid
                echo "$1||${datexp}||$nomhwid" >>$mainPath/cuentahwid
            }
        fi
        #TOKEN
        if [[ -z ${usuarios_ativos3[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            [[ $(grep -o -i $1 $mainPath/cuentatoken) ]] && {
                nomtoken="$(cat $mainPath/cuentatoken | grep -w "$1" | cut -d'|' -f5)"
                sed -i '/'$1'/d' $mainPath/cuentatoken
                echo "$1||${datexp}||$nomtoken" >>$mainPath/cuentatoken
            }
        fi
        echo "" >/dev/null 2>&1
    }

    clear && clear
    msg -bar

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
    if [[ -e "$mainPath/cuentasactivast" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
    fi

    GetAllUsers

    msg -bar
    msgCentrado -amarillo "Escriba o Seleccione un Usuario"
    msg -bar
    unset selection
    while [[ -z ${selection} ]]; do
        msgne -blanco "Seleccione Una Opcion: " && read selection
        tput cuu1 && tput dl1
    done

    if [[ ! $(echo "${selection}" | egrep '[^0-9]') ]]; then
        useredit="${mostrar_totales[$selection]}"
    else
        useredit="$selection"
    fi

    [[ -z $useredit ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return
    }
    [[ ! $(echo ${mostrar_totales[@]} | grep -w "$useredit") ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return
    }

    while true; do
        echo -ne "\e[1;97m Nueva Duracion\033[1;33m [\033[1;32m $useredit \033[1;33m]\033[1;97m: " && read diasuser
        if [[ -z "$diasuser" ]]; then
            echo -e '\n\n\n'
            err_fun "bullo" && continue
        elif [[ "$diasuser" != +([0-9]) ]]; then
            echo -e '\n\n\n'
            err_fun "soloNumeros" && continue
        elif [[ "$diasuser" -gt "$duracionMaxima" ]]; then
            echo -e '\n\n\n'
            err_fun "duracionMaxima" && continue
        fi
        break
    done
    msg -bar

    renew_user_fun "${useredit}" "${diasuser}" && msgCentrado -verde "Usuario Renovado Con Exito" || msgCentrado -rojo "Error, Usuario no Modificado"

    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
