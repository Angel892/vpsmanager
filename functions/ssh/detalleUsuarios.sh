#!/bin/bash

detalleUsuariosSSH() {
    clear && clear
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
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivas
    if [[ -e "$mainPath/cuentasactivas" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivas)
    fi
    if [[ -z ${mostrar_totales[@]} ]]; then
        msg -bar
        msg -tit
        msg -bar
        msgCentrado -rojo "Ningun usuario registrado"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -bar
        msg -tit
        msg -bar
        msgCentrado -amarillo "INFORMACION DE USUARIOS REGISTRADOS"
        msg -bar
        red=$(tput setaf 1)
        gren=$(tput setaf 2)
        yellow=$(tput setaf 3)

        txtvar=$(printf '%-23s' "\e[1;97mUSUARIO")
        txtvar+=$(printf '%-31s' "\e[1;33mCONTRASEÑA")
        txtvar+=$(printf '%-17s' "\e[1;31mFECHA")
        txtvar+=$(printf '%-15s' "\e[1;36mLIMITE")
        echo -e "\033[1;33m${txtvar}"

        VPSsec=$(date +%s)

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
                data_user=$(chage -l "$user" | grep -i co | awk -F ":" '{print $2}')
                txtvar=$(printf '%-25s' "\e[1;97m$user")
                if [[ -e "$mainPath/cuentassh" ]]; then
                    if [[ $(cat $mainPath/cuentassh | grep -w "${user}") ]]; then
                        txtvar+="$(printf '%-22s' "${yellow}$(cat $mainPath/cuentassh | grep -w "${user}" | cut -d'|' -f2)")"
                        DateExp="$(cat $mainPath/cuentassh | grep -w "${user}" | cut -d'|' -f3)"
                        DataSec=$(date +%s --date="$DateExp")
                        if [[ "$VPSsec" -gt "$DataSec" ]]; then
                            EXPTIME="${red}[Exp]"
                        else
                            EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
                        fi
                        txtvar+="$(printf '%-25s' "${red}${DateExp}${EXPTIME}")"
                        txtvar+="$(printf '%-1s' "\e[1;36m$(cat $mainPath/cuentassh | grep -w "${user}" | cut -d'|' -f4)")"
                    else
                        txtvar+="$(printf '%-21s' "${red}")"
                        txtvar+="$(printf '%-29s' "${red}")"
                        txtvar+="$(printf '%-5s' "${red}")"
                    fi
                fi
                echo -e "$txtvar"
            done <<<"$(mostrar_usuariosssh)"

        fi

        #--- CUENTAS HWDI
        mostrar_usuarioshwid() {
            for u in $(cat $mainPath/cuentahwid | cut -d'|' -f1); do
                echo "$u"
            done
        }
        [[ -e "$mainPath/cuentahwid" ]] && usuarios_ativos2=($(mostrar_usuarioshwid))
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
            while read user; do
                data_user=$(chage -l "$user" | grep -i co | awk -F ":" '{print $2}')
                txtvar=$(printf '%-42s' "\e[1;97m$user")
                nomhwid="$(printf '%-18s' "\e[1;36m$(cat $mainPath/cuentahwid | grep -w "${user}" | cut -d'|' -f5)")"
                if [[ -e "$mainPath/cuentahwid" ]]; then
                    if [[ $(cat $mainPath/cuentahwid | grep -w "${user}") ]]; then
                        #txtvar+="$(printf '%-18s' "${yellow}$(cat ${USRdatabase} | grep -w "${user}" | cut -d'|' -f2)")"
                        DateExp="$(cat $mainPath/cuentahwid | grep -w "${user}" | cut -d'|' -f3)"
                        DataSec=$(date +%s --date="$DateExp")
                        if [[ "$VPSsec" -gt "$DataSec" ]]; then
                            EXPTIME="${red}[Exp]"
                        else
                            EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
                        fi
                        txtvar+="$(printf '%-25s' "${red}${DateExp}${EXPTIME}")"
                        txtvar+="$(printf '%-1s' "\e[1;36m$(cat $mainPath/cuentahwid | grep -w "${user}" | cut -d'|' -f4)")"
                    else
                        txtvar+="$(printf '%-21s' "${red}")"
                        txtvar+="$(printf '%-29s' "${red}")"
                        txtvar+="$(printf '%-5s' "${red}")"
                    fi
                fi

                echo -e "$nomhwid\n$txtvar"
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
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN \e[0m\e[38;5;239m═══════════════"
            while read user; do
                data_user=$(chage -l "$user" | grep -i co | awk -F ":" '{print $2}')
                txtvar=$(printf '%-32s' "\e[1;97m$user")
                if [[ -e "$mainPath/cuentatoken" ]]; then
                    if [[ $(cat $mainPath/cuentatoken | grep -w "${user}") ]]; then
                        #txtvar+="$(printf '%-18s' "${yellow}$(cat ${USRdatabase} | grep -w "${user}" | cut -d'|' -f2)")"
                        txtvar+="$(printf '%-18s' "\e[1;36m$(cat $mainPath/cuentatoken | grep -w "${user}" | cut -d'|' -f5)")"
                        DateExp="$(cat $mainPath/cuentatoken | grep -w "${user}" | cut -d'|' -f3)"
                        DataSec=$(date +%s --date="$DateExp")
                        if [[ "$VPSsec" -gt "$DataSec" ]]; then
                            EXPTIME="${red}[Exp]"
                        else
                            EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
                        fi
                        txtvar+="$(printf '%-25s' "${red}${DateExp}${EXPTIME}")"
                        txtvar+="$(printf '%-1s' "\e[1;36m$(cat $mainPath/cuentatoken | grep -w "${user}" | cut -d'|' -f4)")"
                    else
                        txtvar+="$(printf '%-21s' "${red}")"
                        txtvar+="$(printf '%-29s' "${red}")"
                        txtvar+="$(printf '%-5s' "${red}")"
                    fi
                fi
                echo -e "$txtvar"
            done <<<"$(mostrar_usuariotoken)"
        fi
    fi
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
