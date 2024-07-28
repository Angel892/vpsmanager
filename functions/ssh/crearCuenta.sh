#!/bin/bash

crearCuentaSSH() {
    while true; do

        clear && clear
        msg -bar
        if [[ -e "$mainPath/cuentasactivas" ]]; then
            readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivas)
        fi
        if [[ -z ${mostrar_totales[@]} ]]; then
            msg -tit
            msgCentrado -amarillo "AGREGAR USUARIO | Ningun Usuario Registrado"
            msg -bar
        else
            msg -tit
            msg -bar
            msgCentrado -amarillo "AGREGAR USUARIO | Usuarios  Activos en Servidor"
            ##-->>LECTOR DE CUENTAS
            if [[ -e "$mainPath/cuentassh" ]]; then
                readarray -t usuarios_ativos1 < <(cut -d '|' -f1 $mainPath/cuentassh)
                readarray -t usuarios_ativosf2 < <(cut -d '|' -f2 $mainPath/cuentassh)
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
            #SSH
            if [[ -z ${usuarios_ativos1[@]} ]]; then
                echo "" >/dev/null 2>&1
            else
                echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
            fi
            i=1
            for us in $(echo ${usuarios_ativos1[@]}); do
                echo -e " \e[1;32m$i\033[1;31m -\e[1;97m ${us}"
                let i++
            done
            #HWID
            if [[ -z ${usuarios_ativos2[@]} ]]; then
                echo "" >/dev/null 2>&1
            else
                echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
            fi
            i=1
            for us in $(echo ${usuarios_ativos2[@]}); do
                echo -e " \e[1;32m$i\033[1;31m -\e[1;97m ${us}"
                let i++
            done
            #TOKEN
            if [[ -z ${usuarios_ativos3[@]} ]]; then
                echo "" >/dev/null 2>&1
            else
                echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN  \e[0m\e[38;5;239m═══════════════"
            fi
            i=1
            for us in $(echo ${usuarios_ativos3[@]}); do
                echo -e " \e[1;32m$i\033[1;31m -\e[1;97m ${us}"
                let i++
            done
        fi

        cuenta_normal() {
            msg -bar
            echo -e "\e[1;97m             ----- CUENTA NORMAL  ------"
            msg -bar
            while true; do
                echo -ne "\e[1;93mDigite Nuevo Usuario: \e[1;32m" && read nomeuser
                nomeuser="$(echo $nomeuser | sed -e 's/[^a-z0-9 -]//ig')"
                if [[ -z $nomeuser ]]; then
                    errorFun "nullo" && continue
                elif [[ "${#nomeuser}" -lt "$minCaracteres" ]]; then
                    errorFun "corto" && continue
                elif [[ "${#nomeuser}" -gt "$maxCaracteres" ]]; then
                    errorFun "largo" && continue
                elif [[ "$(echo ${usuarios_ativos1[@]} | grep -w "$nomeuser")" ]]; then
                    errorFun "existente" $nomeuser && continue
                elif [[ "$(echo ${usuarios_ativosf2[@]} | grep -w "$nomeuser")" ]]; then
                    errorFun "existente" $nomeuser && continue
                fi
                break
            done

            while true; do
                echo -ne "\e[1;93mDigite Nueva Contraseña: \e[1;32m" && read senhauser
                if [[ -z $senhauser ]]; then
                    errorFun "nullo" && continue
                elif [[ "${#senhauser}" -lt "$minCaracteres" ]]; then
                    errorFun "corto" && continue
                elif [[ "${#senhauser}" -gt "$maxCaracteres" ]]; then
                    errorFun "largo" && continue
                fi
                break
            done
            while true; do
                echo -ne "\e[1;93mDigite Tiempo de Validez: \e[1;32m" && read diasuser
                if [[ -z "$diasuser" ]]; then
                    errorFun "nullo" && continue
                elif [[ "$diasuser" != +([0-9]) ]]; then
                    errorFun "soloNumeros" && continue
                fi
                break
            done
            while true; do
                echo -ne "\e[1;93mDigite conexiones maximas: \e[1;32m" && read limiteuser
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
            echo -ne "\e[38;5;202mIP del Servidor \e[1;97m" && echo -e "$(vpsIP)"
            echo -ne "\e[38;5;202mUsuario: \e[1;97m" && echo -e "$nomeuser"
            echo -ne "\e[38;5;202mContraseña: \e[1;97m" && echo -e "$senhauser"
            echo -ne "\e[38;5;202mDias de Duracion: \e[1;97m" && echo -e "$diasuser"
            echo -ne "\e[38;5;202mFecha de Expiracion: \e[1;97m" && echo -e "$(date "+%F" -d " + $diasuser days")"
            echo -ne "\e[38;5;202mLimite de Conexiones: \e[1;97m" && echo -e "$limiteuser"
            msg -bar
            add_user "${nomeuser}" "${senhauser}" "${diasuser}" "${limiteuser}" && echo -e "\e[1;32m            Usuario Creado con Exito" || msg -rojo "         Error, Usuario no creado" && msg -bar
            [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && newclient "$nomeuser" "$senhauser"
            rebootnb "backbaseu" 2>/dev/null

            read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
            controlador_ssh
        }
        #####-----CUENTA HWID
        cuenta_hwid() {
            msg -bar
            echo -e "\e[1;97m               ----- CUENTA HWID  ------"
            msg -bar
            while true; do
                echo -ne "\e[1;93mDigite HWID: \e[1;32m" && read nomeuser
                nomeuser="$(echo $nomeuser | sed -e 's/[^a-z0-9 -]//ig')"
                if [[ -z $nomeuser ]]; then
                    errorFun "nullo" && continue
                elif [[ "${#nomeuser}" -lt "$minCaracteres" ]]; then
                    errorFun "minimo" && continue
                elif [[ "${#nomeuser}" -gt "$maxCaracteres" ]]; then
                    errorFun "maximo" && continue
                elif [[ "$(echo ${usuarios_ativos2[@]} | grep -w "$nomeuser")" ]]; then
                    errorFun "existente" $nomeuser && continue
                fi
                break
            done

            while true; do
                echo -ne "\e[1;93mDigite Nombre: \e[1;32m" && read nickhwid
                nickhwid="$(echo $nickhwid | sed -e 's/[^a-z0-9 -]//ig')"
                if [[ -z $nickhwid ]]; then
                    errorFun "nullo" && continue
                elif [[ "${#nickhwid}" -lt "$minCaracteres" ]]; then
                    errorFun "minimo" && continue
                elif [[ "${#nickhwid}" -gt "$maxCaracteres" ]]; then
                    errorFun "maximo" && continue
                elif [[ "$(echo ${usuarios_ativos2[@]} | grep -w "$nickhwid")" ]]; then
                    errorFun "existente" $nickhwid && continue
                fi
                break
            done
            while true; do
                echo -ne "\e[1;93mDigite Tiempo de Validez: \e[1;32m" && read diasuser
                if [[ -z "$diasuser" ]]; then
                    errorFun "nullo" && continue
                elif [[ "$diasuser" != +([0-9]) ]]; then
                    errorFun "soloNumeros" && continue
                fi
                break
            done
            tput cuu1 && tput dl1
            tput cuu1 && tput dl1
            echo -ne "\e[38;5;202mIP del Servidor \e[1;97m" && echo -e "$(vpsIP)"
            echo -ne "\e[38;5;202mHWID: \e[1;97m" && echo -e "$nomeuser"
            echo -ne "\e[38;5;202mUsuario: \e[1;97m" && echo -e "$nickhwid"
            echo -ne "\e[38;5;202mDias de Duracion: \e[1;97m" && echo -e "$diasuser"
            echo -ne "\e[38;5;202mFecha de Expiracion: \e[1;97m" && echo -e "$(date "+%F" -d " + $diasuser days")"
            msg -bar
            [[ $(cat /etc/passwd | grep $nomeuser: | grep -vi [a-z]$nomeuser | grep -v [0-9]$nomeuser >/dev/null) ]] && {
                msg -rojo "         Error, Usuario no creado"
                return 0
            }
            valid=$(date '+%C%y-%m-%d' -d " +$diasuser days") && datexp=$(date "+%F" -d " + $diasuser days")
            userdel $nomeuser >/dev/null 2>&1
            useradd -m -s /bin/false $nomeuser -e ${valid} >/dev/null 2>&1 || {
                msg -rojo "         Error, Usuario no creado"
                return 0
            }
            (
                echo $nomeuser
                echo $nomeuser
            ) | passwd $nomeuser 2>/dev/null || {
                userdel --force $nomeuser

                return 1
            }
            echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/cuentahwid
            echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/regtotal
            msg -amarillo "\e[1;32m            Usuario Creado con Exito"
            msg -bar
            rebootnb "backbaseu" 2>/dev/null

            read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
            controlador_ssh
        }
        #####-----CUENTA TOKEN
        cuenta_token() {
            msg -bar
            echo -e "\e[1;97m               ----- CUENTA TOKEN  ------"
            msg -bar
            passgeneral() {
                echo -ne "\e[1;93mDIGITE SU TOKEN GENERAL:\e[1;32m " && read passgeneral
                echo "$passgeneral" >$mainPath/temp/.passw
                msg -bar
            }
            [[ -e "$mainPath/temp/.passw" ]] || passgeneral
            while true; do
                echo -ne "\e[1;93mDigite TOKEN: \e[1;32m" && read nomeuser
                nomeuser="$(echo $nomeuser | sed -e 's/[^a-z0-9 -]//ig')"
                if [[ -z $nomeuser ]]; then
                    errorFun "nullo" && continue
                elif [[ "${#nomeuser}" -lt "$minCaracteres" ]]; then
                    errorFun "minimo" && continue
                elif [[ "${#nomeuser}" -gt "$maxCaracteres" ]]; then
                    errorFun "maximo" && continue
                elif [[ "$(echo ${usuarios_ativos3[@]} | grep -w "$nomeuser")" ]]; then
                    errorFun "existente" $nomeuser && continue
                fi
                break
            done

            while true; do
                echo -ne "\e[1;93mDigite Nombre: \e[1;32m" && read nickhwid
                nickhwid="$(echo $nickhwid | sed -e 's/[^a-z0-9 -]//ig')"
                if [[ -z $nickhwid ]]; then
                    errorFun "nullo" && continue
                elif [[ "${#nickhwid}" -lt "$minCaracteres" ]]; then
                    errorFun "minimo" && continue
                elif [[ "${#nickhwid}" -gt "$maxCaracteres" ]]; then
                    errorFun "maximo" && continue
                elif [[ "$(echo ${usuarios_ativos2[@]} | grep -w "$nickhwid")" ]]; then
                    errorFun "existente" $nickhwid && continue
                fi
                break
            done

            while true; do
                echo -ne "\e[1;93mDigite Tiempo de Validez: \e[1;32m" && read diasuser
                if [[ -z "$diasuser" ]]; then
                    errorFun "nullo" && continue
                elif [[ "$diasuser" != +([0-9]) ]]; then
                    errorFun "soloNumeros" && continue
                fi
                break
            done
            tput cuu1 && tput dl1
            tput cuu1 && tput dl1
            echo -ne "\e[38;5;202mIP del Servidor \e[1;97m" && echo -e "$(vpsIP)"
            echo -ne "\e[38;5;202mToken: \e[1;97m" && echo -e "$nomeuser"
            echo -ne "\e[38;5;202mUsuario: \e[1;97m" && echo -e "$nickhwid"
            echo -ne "\e[38;5;202mDias de Duracion: \e[1;97m" && echo -e "$diasuser"
            echo -ne "\e[38;5;202mFecha de Expiracion: \e[1;97m" && echo -e "$(date "+%F" -d " + $diasuser days")"
            msg -bar
            passtoken=$(cat $mainPath/temp/.passw | tr -d " \t\n\r")

            [[ $(cat /etc/passwd | grep $nomeuser: | grep -vi [a-z]$nomeuser | grep -v [0-9]$nomeuser >/dev/null) ]] && {
                msg -rojo "         Error, Usuario no creado"
                return 0
            }
            valid=$(date '+%C%y-%m-%d' -d " +$diasuser days") && datexp=$(date "+%F" -d " + $diasuser days")
            useradd -m -s /bin/false $nomeuser -e ${valid} >/dev/null 2>&1 || {
                msg -rojo "         Error, Usuario no creado"
                return 0
            }
            (
                echo $passtoken
                echo $passtoken
            ) | passwd $nomeuser 2>/dev/null || {
                userdel --force $nomeuser
                return 1
            }
            echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/cuentatoken
            echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/regtotal
            msg -amarillo "\e[1;32m            Usuario Creado con Exito"
            rebootnb "backbaseu" 2>/dev/null

            msg -bar
            read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
            controlador_ssh
        }

        local num=1

        msg -bar
        echo -e "\033[1;36m   --   Seleccione primero Tipo de Cuenta   --"

        # NORMAL
        opcionMenu -blanco $num "NORMAL" false 2
        option[$num]="normal"
        let num++

        # HWID
        opcionMenu -blanco $num "HWID" false 2
        option[$num]="hwid"
        let num++

        # TOKEN
        opcionMenu -blanco $num "TOKEN" false 2
        option[$num]="token"
        let num++

        msg -bar

        # SALIR
        opcionMenu -rojo 0 "Volver al menu anterior"
        option[0]="volver"

        msg -bar

        selection=$(selectionFun $num)
        case ${option[$selection]} in
        "normal") cuenta_normal ;;
        "hwid") cuenta_hwid ;;
        "token") cuenta_token ;;
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;

        esac
    done
}
