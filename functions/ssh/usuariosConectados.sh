#!/bin/bash

#MONITOR DE USER
usuariosConectadosSSH() {
    clear && clear
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
    done >$mainPath/cuentasactivast
    for us in $(echo ${usuarios_ativos2[@]}); do
        echo "${us}"
    done >>$mainPath/cuentasactivast
    for us in $(echo ${usuarios_ativos3[@]}); do
        echo "${us}"
    done >>$mainPath/cuentasactivast
    mostrar_totales() {
        for u in $(cat $mainPath/cuentasactivast | cut -d'|' -f1); do
            echo "$u"
        done
    }

    usuarios_totales=($(mostrar_totales))
    if [[ -z ${usuarios_totales[@]} ]]; then
        msg -bar
        msg -tit
        msg -bar
        msgCentrado -amarillo "MONITOR | Ningun usuario registrado"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -bar
        msg -tit
        msg -bar

        yellow=$(tput setaf 3)
        gren=$(tput setaf 2)
        echo -e "\e[93m   MONITOR DE CONEXIONES SSH/DROPBEAR/SSL/OPENVPN"
        msg -bar
        txtvar=$(printf '%-46s' "\e[1;97m USUARIO")
        txtvar+=$(printf '%-10s' "\e[1;93m CONEXIONES")
        #txtvar+=$(printf '%-16s' "TIME/ON")
        echo -e "\033[1;92m${txtvar}"
        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
            while read user; do
                _=$(
                    PID="0+"
                    [[ $(dpkg --get-selections | grep -w "openssh" | head -1) ]] && PID+="$(ps aux | grep -v grep | grep sshd | grep -w "$user" | grep -v root | wc -l)+"
                    [[ $(dpkg --get-selections | grep -w "dropbear" | head -1) ]] && PID+="$(dropbear_pids | grep -w "${user}" | wc -l)+"
                    [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && [[ $(openvpn_pids | grep -w "$user" | cut -d'|' -f2) ]] && PID+="$(openvpn_pids | grep -w "$user" | cut -d'|' -f2)+"
                    PID+="0"

                    [[ -z $(cat $mainPath/cuentassh | grep -w "${user}") ]] && MAXUSER="?" || MAXUSER="$(cat $mainPath/cuentassh | grep -w "${user}" | cut -d'|' -f4)"
                    [[ $(echo $PID | bc) -gt 0 ]] && user="$user \e[1;93m[\033[1;32m ON \e[1;93m]" || user="$user \e[1;93m[\033[1;31m OFF \e[1;93m]"
                    TOTALPID="$(echo $PID | bc)/$MAXUSER"
                    while [[ ${#user} -lt 67 ]]; do
                        user=$user" "
                    done

                    echo -e "\e[1;97m $user $TOTALPID " >&2
                ) &
                pid=$!
                sleep 0.5
            done <<<"$(mostrar_usuariossh)"
            while [[ -d /proc/$pid ]]; do
                sleep 1s
            done
        fi
        #HWID
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
            while read user; do
                _=$(
                    PID="0+"
                    [[ $(dpkg --get-selections | grep -w "openssh" | head -1) ]] && PID+="$(ps aux | grep -v grep | grep sshd | grep -w "$user" | grep -v root | wc -l)+"
                    [[ $(dpkg --get-selections | grep -w "dropbear" | head -1) ]] && PID+="$(dropbear_pids | grep -w "${user}" | wc -l)+"
                    [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && [[ $(openvpn_pids | grep -w "$user" | cut -d'|' -f2) ]] && PID+="$(openvpn_pids | grep -w "$user" | cut -d'|' -f2)+"
                    PID+="0"
                    nomhwid="\e[1;96m$(cat $mainPath/cuentahwid | grep -w "${user}" | cut -d'|' -f5)"
                    [[ -z $(cat $mainPath/cuentahwid | grep -w "${user}") ]] && MAXUSER="?" || MAXUSER="$(cat $mainPath/cuentahwid | grep -w "${user}" | cut -d'|' -f4)"
                    [[ $(echo $PID | bc) -gt 0 ]] && user="$user \e[1;93m[\033[1;32m ON \e[1;93m]" || user="$user \e[1;93m[\033[1;31m OFF \e[1;93m]"
                    TOTALPID="$(echo $PID | bc)"
                    while [[ ${#user} -lt 69 ]]; do
                        user=$user" "
                    done
                    echo -e "$nomhwid\e[1;97m\n$user $TOTALPID " >&2
                ) &
                pid=$!
                sleep 0.5s
            done <<<"$(mostrar_usuariohwid)"
            while [[ -d /proc/$pid ]]; do
                sleep 1s
            done
        fi
        #TOKEN
        if [[ -z ${usuarios_ativos3[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN  \e[0m\e[38;5;239m═══════════════"
            while read user; do
                _=$(
                    PID="0+"
                    [[ $(dpkg --get-selections | grep -w "openssh" | head -1) ]] && PID+="$(ps aux | grep -v grep | grep sshd | grep -w "$user" | grep -v root | wc -l)+"
                    [[ $(dpkg --get-selections | grep -w "dropbear" | head -1) ]] && PID+="$(dropbear_pids | grep -w "${user}" | wc -l)+"
                    [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && [[ $(openvpn_pids | grep -w "$user" | cut -d'|' -f2) ]] && PID+="$(openvpn_pids | grep -w "$user" | cut -d'|' -f2)+"
                    PID+="0"
                    nomtoken="$(cat $mainPath/cuentatoken | grep -w "${user}" | cut -d'|' -f5)"
                    [[ -z $(cat $mainPath/cuentatoken | grep -w "${user}") ]] && MAXUSER="?" || MAXUSER="$(cat $mainPath/cuentatoken | grep -w "${user}" | cut -d'|' -f4)"
                    [[ $(echo $PID | bc) -gt 0 ]] && user="$user \e[1;96m$nomtoken \e[1;93m[\033[1;32m ON \e[1;93m]" || user="$user \e[1;96m$nomtoken \e[1;93m[\033[1;31m OFF \e[1;93m]"
                    TOTALPID="$(echo $PID | bc)"
                    while [[ ${#user} -lt 76 ]]; do
                        user=$user" "
                    done
                    echo -e "\e[1;97m $user $TOTALPID " >&2
                ) &
                pid=$!
                sleep 0.5s
            done <<<"$(mostrar_usuariotoken)"
            while [[ -d /proc/$pid ]]; do
                sleep 1s
            done
        fi
    fi

    contador_online 2>/dev/null

    validarArchivo "$mainPath/temp/Tonli"

    onlinest=$(cat $mainPath/temp/Tonli)
    msg -bar
    echo -e "\033[1;32m            TOTAL DE CONECTADOS:\033[1;36m[\e[97m $onlinest \033[1;36m]"
    msg -bar

    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
