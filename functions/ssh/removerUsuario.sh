#!/bin/bash

removerUsuarioSSH() {

    rm_user() {
        userdel --force "$1" &>/dev/null
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
        usuario_del="${mostrar_totales[$selection]}"
    else
        usuario_del="$selection"
    fi

    [[ -z $usuario_del ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        return 1
    }
    [[ ! $(echo ${mostrar_totales[@]} | grep -w "$usuario_del") ]] && {
        msg -rojo "error, Usuario Invalido"
        msg -bar
        return 1
    }
    msgne -amarillo "Usuario Seleccionado: " && echo -ne "$usuario_del"
    pkill -u $usuario_del
    droplim=$(dropbear_pids | grep -w "$usuario_del" | cut -d'|' -f2)
    kill -9 $droplim &>/dev/null
    rm_user "$usuario_del" && msg -verde " [ Removido ]" || msg -rojo " [ No Removido ]"

    #SSH
    if [[ -z ${usuarios_ativos1[@]} ]]; then
        echo "" >/dev/null 2>&1
    else
        [[ $(grep -o -i $usuario_del $mainPath/cuentassh) ]] && {
            userb=$(cat $mainPath/cuentassh | grep -n -w $usuario_del | cut -d'|' -f1 | cut -d':' -f1)
            sed -i "${userb}d" $mainPath/cuentassh >/dev/null 2>&1
        }
    fi
    #HWID
    if [[ -z ${usuarios_ativos2[@]} ]]; then
        echo "" >/dev/null 2>&1
    else
        [[ $(grep -o -i $usuario_del $mainPath/cuentahwid) ]] && {
            sed -i '/'$usuario_del'/d' $mainPath/cuentahwid >/dev/null 2>&1
        }
    fi
    #TOKEN
    if [[ -z ${usuarios_ativos3[@]} ]]; then
        echo "" >/dev/null 2>&1
    else
        [[ $(grep -o -i $usuario_del $mainPath/cuentatoken) ]] && {
            sed -i '/'$usuario_del'/d' $mainPath/cuentatoken >/dev/null 2>&1
        }
    fi

    rm -rf $mainPath/temp/userlock
    rm -rf $mainPath/temp/Limiter.log
    unlockall2
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
