#!/bin/bash

eliminarUsuariosVencidosSSH() {
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msgCentrado -amarillo "BORRANDO USUARIOS EXPIRADOS "
    msg -bar
    red=$(tput setaf 1)
    gren=$(tput setaf 2)
    yellow=$(tput setaf 3)
    txtvar=$(printf '%-42s' "\e[1;97m   USUARIOS")
    txtvar+=$(printf '%-1s' "\e[1;32m  VALIDIDEZ")
    echo -e "\033[1;92m${txtvar}"

    expired="${red}Usuario Expirado"
    valid="${gren}Usuario Vigente"
    never="${yellow}Usuario Ilimitado"
    removido="${red}Eliminado"
    DataVPS=$(date +%s)
    #CUENTAS SSH
    mostrar_usuariosssh() {
        for u in $(cat $mainPath/cuentassh | cut -d'|' -f1); do
            echo "$u"
        done
    }
    [[ -e "$mainPath/cuentassh" ]] && usuarios_ativos1=($(mostrar_usuariosssh))
    if [[ -z ${usuarios_ativos1[@]} ]]; then
        echo "" >/dev/null 2>&1
    else
        echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
        while read user; do
            DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')
            usr=$user
            while [[ ${#usr} -lt 34 ]]; do
                usr=$usr" "
            done
            [[ "$DataUser" = " never" ]] && {
                echo -e "\e[1;97m$usr $never"
                continue
            }
            DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$DataVPS" ]]; then
                echo -ne "\e[1;97m$usr $expired"
                pkill -u $user &>/dev/null
                droplim=$(dropbear_pids | grep -w "$user" | cut -d'|' -f2)
                kill -9 $droplim &>/dev/null
                # droplim=`droppids|grep -w "$user"|cut -d'|' -f2`
                # kill -9 $droplim &>/dev/null
                rm_user "$user" && echo -e " y ($removido)"
                userb=$(cat $mainPath/cuentassh | grep -n -w $user | cut -d'|' -f1 | cut -d':' -f1)
                sed -i "${userb}d" $mainPath/cuentassh
            else
                echo -e "\e[1;97m$usr $valid"
            fi
        done <<<"$(mostrar_usuariosssh)"
    fi
    #---SSH HWID
    mostrar_usuarioshwid() {
        for u in $(cat $mainPath/cuentahwid | cut -d'|' -f1); do
            echo "$u"
        done
    }
    [[ -e "$mainPath/cuentahwid" ]] && usuarios_ativos2=($(mostrar_usuarioshwid))
    if [[ -z ${usuarios_ativos2[@]} ]]; then
        echo "" >/dev/null 2>&1
    else
        echo -e "\033[38;5;239m═════════════════\e[100m\e[97m  CUENTAS HWID  \e[0m\e[38;5;239m═════════════════"

        while read user; do
            DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')
            usr=$user
            while [[ ${#usr} -lt 34 ]]; do
                usr=$usr" "
            done
            [[ "$DataUser" = " never" ]] && {
                echo -e "\e[1;97m$usr $never"
                continue
            }
            DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$DataVPS" ]]; then
                echo -ne "\e[1;97m$usr $expired"
                pkill -u $user &>/dev/null
                droplim=$(dropbear_pids | grep -w "$user" | cut -d'|' -f2)
                kill -9 $droplim &>/dev/null
                # droplim=`droppids|grep -w "$user"|cut -d'|' -f2`
                # kill -9 $droplim &>/dev/null
                rm_user "$user" && echo -e " y ($removido)"
                sed -i '/'$user'/d' $mainPath/cuentahwid
            else
                echo -e "\e[1;97m$usr $valid"
            fi
        done <<<"$(mostrar_usuarioshwid)"
    fi
    #--- CUENTAS TOKEN
    mostrar_usuariotoken() {
        for u in $(cat $mainPath/cuentatoken | cut -d'|' -f1); do
            echo "$u"
        done
    }
    [[ -e "$mainPath/cuentatoken" ]] && usuarios_ativos3=($(mostrar_usuariotoken))
    if [[ -z ${usuarios_ativos3[@]} ]]; then
        echo "" >/dev/null 2>&1
    else
        echo -e "\033[38;5;239m═════════════════\e[100m\e[97m  CUENTAS TOKEN  \e[0m\e[38;5;239m═════════════════"
        while read user; do
            DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')
            usr=$user
            while [[ ${#usr} -lt 34 ]]; do
                usr=$usr" "
            done
            [[ "$DataUser" = " never" ]] && {
                echo -e "\e[1;97m$usr $never"
                continue
            }
            DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$DataVPS" ]]; then
                echo -ne "\e[1;97m$usr $expired"
                pkill -u $user &>/dev/null
                droplim=$(dropbear_pids | grep -w "$user" | cut -d'|' -f2)
                kill -9 $droplim &>/dev/null
                # droplim=`droppids|grep -w "$user"|cut -d'|' -f2`
                # kill -9 $droplim &>/dev/null
                rm_user "$user" && echo -e "y ($removido)"
                sed -i '/'$user'/d' $mainPath/cuentatoken
            else
                echo -e "\e[1;97m$usr $valid"
            fi
        done <<<"$(mostrar_usuariotoken)"
    fi
    validarArchivo "$mainPath/temp/userlock"
    rm -rf $mainPath/temp/userlock
    validarArchivo "$mainPath/temp/userexp"
    rm -rf $mainPath/temp/userexp
    unlockall2
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
