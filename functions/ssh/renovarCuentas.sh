#!/bin/bash

renovarCuentaSSH() {
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
        return 1
    }
    [[ ! $(echo ${mostrar_totales[@]} | grep -w "$useredit") ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return 1
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
