#!/bin/bash

editarCuentaSSH() {

    edit_user_fun() {

        local cuentasPath="$mainPath/cuentassh";

        validarArchivo "$cuentasPath"

        #nome senha dias limite
        (
            echo "$2"
            echo "$2"
        ) | passwd $1 >/dev/null 2>&1 || return 1
        datexp=$(date "+%F" -d " + $3 days") && valid=$(date '+%C%y-%m-%d' -d " + $3 days")
        chage -E $valid $1 2>/dev/null || return 1
        userb=$(cat $cuentasPath | grep -n -w $1 | cut -d'|' -f1 | cut -d':' -f1)
        sed -i "${userb}d" $cuentasPath
        echo "$1|$2|${datexp}|$4" >>$cuentasPath
    }

    clear && clear
    msg -bar

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
    if [[ -e "$mainPath/cuentasactivast" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
    fi

    GetNormalUsers

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
        msg -rojo "error, Usuario Invalido"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return 1
    }

    while true; do
        msgne -blanco "Usuario Seleccionado: " && echo -e "\e[1;32m [ $useredit ]"
        msgne -blanco "Nueva Contraseña de: " && read senhauser
        if [[ -z "$senhauser" ]]; then
            errorFun "nullo" && continue
        elif [[ "${#senhauser}" -lt "$minCaracteres" ]]; then
            errorFun "minimo" && continue
        elif [[ "${#senhauser}" -gt "$maxCaracteres" ]]; then
            errorFun "maximo" && continue
        fi
        break
    done
    while true; do
        msgne -blanco "Dias de Duracion de: " && read diasuser
        if [[ -z "$diasuser" ]]; then
            errorFun "nullo" && continue
        elif [[ "$diasuser" != +([0-9]) ]]; then
            errorFun "soloNumeros" && continue
        elif [[ "$diasuser" -gt "$duracionMaxima" ]]; then
            errorFun "duracionMaxima" && continue
        fi
        break
    done
    while true; do
        msgne -blanco "Nuevo Limite de Conexion de: " && read limiteuser
        if [[ -z "$limiteuser" ]]; then
            errorFun "nullo" && continue
        elif [[ "$limiteuser" != +([0-9]) ]]; then
            errorFun "soloNumeros" && continue
        elif [[ "$limiteuser" -gt "$limiteMaximo" ]]; then
            errorFun "limiteMaximo" && continue
        fi
        break
    done
    tput cuu1 && tput dl1
    tput cuu1 && tput dl1
    tput cuu1 && tput dl1
    tput cuu1 && tput dl1
    msgne -blanco "Usuario: " && echo -e "$useredit"
    msgne -blanco "Contraseña: " && echo -e "$senhauser"
    msgne -blanco "Dias de Duracion: " && echo -e "$diasuser"
    msgne -blanco "Fecha de Expiracion: " && echo -e "$(date "+%F" -d " + $diasuser days")"
    msgne -blanco "Limite de Conexiones: " && echo -e "$limiteuser"
    msg -bar

    validarArchivo "$mainPath/temp/Limiter.log"

    edit_user_fun "${useredit}" "${senhauser}" "${diasuser}" "${limiteuser}" && msgCentrado -verde "Usuario Modificado Con Exito" && rm -rf $mainPath/temp/Limiter.log || msgCentrado -rojo "Error, Usuario no Modificado"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
