#!/bin/bash

crearCuentaSSH() {

    validarArchivo "$mainPath/cuentasactivas"

    add_user() {

        local user=$1
        local password=$2
        local exp=$3
        local conex=$4

        #nome senha Dias limite
        [[ $(cat /etc/passwd | grep $user: | grep -vi [a-z]$user | grep -v [0-9]$user >/dev/null) ]] && return 1
        valid=$(date '+%C%y-%m-%d' -d " +$exp days") && datexp=$(date "+%F" -d " + $exp days")
        useradd -m -s /bin/false $user -e ${valid} >/dev/null 2>&1 || return 1
        (
            echo $password
            echo $password
        ) | passwd $user 2>/dev/null || {
            userdel --force $user
            return 1
        }

        validarArchivo "$mainPath/cuentassh"
        validarArchivo "$mainPath/regtotal"

        echo "$user|$password|${datexp}|$conex" >>$mainPath/cuentassh
        echo "$user|$password|${datexp}|$conex" >>$mainPath/regtotal
        echo "" >/dev/null 2>&1
    }

    # Open VPN
    newclient() {

        local user=$1
        local password=$2

        #Nome #Senha
        usermod -p $(openssl passwd -1 $password) $user
        while [[ ${newfile} != @(s|S|y|Y|n|N) ]]; do
            msg -bar
            read -p "Crear Archivo OpenVPN? [S/N]: " -e -i S newfile
            tput cuu1 && tput dl1
        done
        if [[ ${newfile} = @(s|S) ]]; then
            # Generates the custom client.ovpn
            rm -rf /etc/openvpn/easy-rsa/pki/reqs/$user.req
            rm -rf /etc/openvpn/easy-rsa/pki/issued/$user.crt
            rm -rf /etc/openvpn/easy-rsa/pki/private/$user.key
            cd /etc/openvpn/easy-rsa/
            ./easyrsa build-client-full $user nopass >/dev/null 2>&1
            cd

            cp /etc/openvpn/client-common.txt ~/$user.ovpn
            echo "<ca>" >>~/$user.ovpn
            cat /etc/openvpn/easy-rsa/pki/ca.crt >>~/$user.ovpn
            echo "</ca>" >>~/$user.ovpn
            echo "<cert>" >>~/$user.ovpn
            cat /etc/openvpn/easy-rsa/pki/issued/$user.crt >>~/$user.ovpn
            echo "</cert>" >>~/$user.ovpn
            echo "<key>" >>~/$user.ovpn
            cat /etc/openvpn/easy-rsa/pki/private/$user.key >>~/$user.ovpn
            echo "</key>" >>~/$user.ovpn
            echo "<tls-auth>" >>~/$user.ovpn
            cat /etc/openvpn/ta.key >>~/$user.ovpn
            echo "</tls-auth>" >>~/$user.ovpn

            while [[ ${ovpnauth} != @(s|S|y|Y|n|N) ]]; do
                read -p "Colocar autenticacion de usuario en el archivo? [S/N]: " -e -i S ovpnauth
                tput cuu1 && tput dl1
            done
            [[ ${ovpnauth} = @(s|S) ]] && sed -i "s;auth-user-pass;<auth-user-pass>\n$user\n$password\n</auth-user-pass>;g" ~/$user.ovpn
            cd $HOME
            zip ./$user.zip ./$user.ovpn >/dev/null 2>&1
            rm ./$user.ovpn >/dev/null 2>&1

            echo -e "\033[1;31mArchivo creado: ($HOME/$user.zip)"

        fi
    }

    cuenta_normal() {
        clear
        msg -bar
        msgCentrado -amarillo "----- CUENTA NORMAL  ------"
        msg -bar
        while true; do
            msgne -blanco "Digite Nuevo Usuario: " && read nomeuser
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
            msgne -blanco "Digite Nueva Contraseña: " && read senhauser
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
            msgne -blanco "Digite Tiempo de Validez: " && read diasuser
            if [[ -z "$diasuser" ]]; then
                errorFun "nullo" && continue
            elif [[ "$diasuser" != +([0-9]) ]]; then
                errorFun "soloNumeros" && continue
            fi
            break
        done
        while true; do
            msgne -blanco "Digite conexiones maximas: " && read limiteuser
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
        add_user "${nomeuser}" "${senhauser}" "${diasuser}" "${limiteuser}" && msgCentrado -verde "Usuario Creado con Exito" || msgCentrado -rojo "Error, Usuario no creado" && msg -bar
        [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && newclient "$nomeuser" "$senhauser"

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    }
    #####-----CUENTA HWID
    cuenta_hwid() {
        clear
        msg -bar
        msgCentrado -amarillo "----- CUENTA HWID  ------"
        msg -bar
        while true; do
            msgne -blanco "Digite HWID: " && read nomeuser
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
            msgne -blanco "Digite Nombre: " && read nickhwid
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
            msgne -blanco "Digite Tiempo de Validez: " && read diasuser
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
            msgCentrado -rojo "Error, Usuario no creado"
            return 0
        }
        valid=$(date '+%C%y-%m-%d' -d " +$diasuser days") && datexp=$(date "+%F" -d " + $diasuser days")
        userdel $nomeuser >/dev/null 2>&1
        useradd -m -s /bin/false $nomeuser -e ${valid} >/dev/null 2>&1 || {
            msgCentrado -rojo "Error, Usuario no creado"
            return 0
        }
        (
            echo $nomeuser
            echo $nomeuser
        ) | passwd $nomeuser 2>/dev/null || {
            userdel --force $nomeuser

            return 1
        }

        validarArchivo "$mainPath/cuentahwid"
        validarArchivo "$mainPath/regtotal"

        echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/cuentahwid
        echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/regtotal
        msgCentrado -verde "Usuario Creado con Exito"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    }
    #####-----CUENTA TOKEN
    cuenta_token() {
        clear
        msg -bar
        msgCentrado -amarillo "----- CUENTA TOKEN  ------"
        msg -bar
        passgeneral() {
            msgne -blanco "DIGITE SU TOKEN GENERAL: " && read passgeneral
            validarArchivo "$mainPath/temp/.passw"
            echo "$passgeneral" >$mainPath/temp/.passw
            msg -bar
        }

        [[ -e "$mainPath/temp/.passw" ]] || passgeneral
        while true; do
            msgne -blanco "Digite TOKEN: " && read nomeuser
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
            msgne -blanco "Digite Nombre: " && read nickhwid
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
            msgne -blanco "Digite Tiempo de Validez: " && read diasuser
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
            msg -rojo "Error, Usuario no creado"
            return 0
        }
        valid=$(date '+%C%y-%m-%d' -d " +$diasuser days") && datexp=$(date "+%F" -d " + $diasuser days")
        useradd -m -s /bin/false $nomeuser -e ${valid} >/dev/null 2>&1 || {
            msg -rojo "Error, Usuario no creado"
            return 0
        }
        (
            echo $passtoken
            echo $passtoken
        ) | passwd $nomeuser 2>/dev/null || {
            userdel --force $nomeuser
            return 1
        }

        validarArchivo "$mainPath/cuentatoken"
        validarArchivo "$mainPath/regtotal"

        echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/cuentatoken
        echo "$nomeuser||${datexp}||${nickhwid}" >>$mainPath/regtotal
        msgCentrado -verde "Usuario Creado con Exito"

        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    }

    while true; do

        clear && clear
        msg -bar
        ##-->>GENERAR USUARIOS TOTALES
        cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivas
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

        local num=1

        msg -bar
        msgCentrado -azul "--   Seleccione primero Tipo de Cuenta   --"

        # NORMAL
        opcionMenu -blanco $num "NORMAL" false 0
        option[$num]="normal"
        let num++

        # HWID
        opcionMenu -blanco $num "HWID" false 0
        option[$num]="hwid"
        let num++

        # TOKEN
        opcionMenu -blanco $num "TOKEN"
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
