#!/bin/bash

removerUsuarioSSH() {
    clear && clear
    msg -bar
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
    if [[ -z ${mostrar_totales[@]} ]]; then
        msg -tit
        msg -bar
        msgCentrado -rojo "BORAR USUARIO  | Ningun usuario registrado"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -tit
        msg -bar
        msgCentrado -amarillo "BORAR USUARIO |  Usuarios Activos del Servidor"
        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
        fi
        i=0
        for us in $(echo ${usuarios_ativos1[@]}); do
            opcionMenu -blanco $i "$us"
            let i++
        done
        #HWID
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
        fi
        for us in $(echo ${usuarios_ativos2[@]}); do
            nomhwid="$(cat $mainPath/cuentahwid | grep -w "${us}" | cut -d'|' -f5)"
            msg -ne "\e[1;93m [\e[1;32m$i\e[1;93m]\033[1;31m >" && echo -e "\e[1;97m ${us} \e[1;93m| \e[1;96m$nomhwid"
            let i++
        done
        #TOKEN
        if [[ -z ${usuarios_ativos3[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN \e[0m\e[38;5;239m═══════════════"
        fi
        for us in $(echo ${usuarios_ativos3[@]}); do
            nomtoken="$(cat $mainPath/cuentatoken | grep -w "${us}" | cut -d'|' -f5)"
            msg -ne "\e[1;93m [\e[1;32m$i\e[1;93m]\033[1;31m >" && echo -e "\e[1;97m ${us} \e[1;93m| \e[1;96m$nomtoken"
            let i++
        done
    fi
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