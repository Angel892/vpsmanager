#---AJUSTES INTERNOS DE VPS
ajuste_in() {

    reiniciar_ser() { #REINICIO DE PROTOCOLOS BASICOS
        echo -ne " \033[1;31m[ ! ] Services stunnel4 restart"
        service stunnel4 restart >/dev/null 2>&1
        [[ -e /etc/init.d/stunnel4 ]] && /etc/init.d/stunnel4 restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services squid restart"
        service squid restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services squid3 restart"
        service squid3 restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services apache2 restart"
        service apache2 restart >/dev/null 2>&1
        [[ -e /etc/init.d/apache2 ]] && /etc/init.d/apache2 restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services openvpn restart"
        service openvpn restart >/dev/null 2>&1
        [[ -e /etc/init.d/openvpn ]] && /etc/init.d/openvpn restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services dropbear restart"
        service dropbear restart >/dev/null 2>&1
        [[ -e /etc/init.d/dropbear ]] && /etc/init.d/dropbear restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services ssh restart"
        service ssh restart >/dev/null 2>&1
        [[ -e /etc/init.d/ssh ]] && /etc/init.d/ssh restart >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        echo -ne " \033[1;31m[ ! ] Services fail2ban restart"
        (
            [[ -e /etc/init.d/ssh ]] && /etc/init.d/ssh restart
            fail2ban-client -x stop && fail2ban-client -x start
        ) >/dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    host_name() { #CAMBIO DE HOSTNAME
        unset name
        while [[ ${name} = "" ]]; do
            echo -ne "\033[1;37m Digite Nuevo Hostname: " && read name
            tput cuu1 && tput dl1
        done
        hostnamectl set-hostname $name
        if [ $(hostnamectl status | head -1 | awk '{print $3}') = "${name}" ]; then
            echo -e "\033[1;33m     Host alterado corretamente!, reiniciar VPS"
        else
            echo -e "\033[1;33m                Host no modificado!"
        fi
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    editports() {
        port() {
            local portas
            local portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
            i=0
            while read port; do
                var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
                [[ "$(echo -e ${portas} | grep -w "$var1 $var2")" ]] || {
                    portas+="$var1 $var2 $portas"
                    echo "$var1 $var2"
                    let i++
                }
            done <<<"$portas_var"
        }
        verify_port() {
            local SERVICE="$1"
            local PORTENTRY="$2"
            [[ ! $(echo -e $(port | grep -v ${SERVICE}) | grep -w "$PORTENTRY") ]] && return 0 || return 1
        }
        edit_squid() {
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            msg -bar
            msg -amarillo "REDEFINIR PUERTOS SQUID"
            msg -bar
            if [[ -e /etc/squid/squid.conf ]]; then
                local CONF="/etc/squid/squid.conf"
            elif [[ -e /etc/squid3/squid.conf ]]; then
                local CONF="/etc/squid3/squid.conf"
            fi
            NEWCONF="$(cat ${CONF} | grep -v "http_port")"
            msg -ne "Nuevos Puertos: "
            read -p "" newports
            for PTS in $(echo ${newports}); do
                verify_port squid "${PTS}" && echo -e "\033[1;33mPort $PTS \033[1;32mOK" || {
                    echo -e "\033[1;33mPort $PTS \033[1;31mFAIL"
                    return 1
                }
            done
            rm ${CONF}
            while read varline; do
                echo -e "${varline}" >>${CONF}
                if [[ "${varline}" = "#portas" ]]; then
                    for NPT in $(echo ${newports}); do
                        echo -e "http_port ${NPT}" >>${CONF}
                    done
                fi
            done <<<"${NEWCONF}"
            msg -blanco "AGUARDE"
            service squid restart &>/dev/null
            service squid3 restart &>/dev/null
            sleep 1s
            msg -bar
            echo -e "\e[92m              PUERTOS REDEFINIDOS"
            msg -bar
        }
        edit_apache() {
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            msg -bar
            msg -blanco "REDEFINIR PUERTOS APACHE"
            msg -bar
            local CONF="/etc/apache2/ports.conf"
            local NEWCONF="$(cat ${CONF})"
            msg -ne "Nuevos Puertos: "
            read -p "" newports
            for PTS in $(echo ${newports}); do
                verify_port apache "${PTS}" && echo -e "\033[1;33mPort $PTS \033[1;32mOK" || {
                    echo -e "\033[1;33mPort $PTS \033[1;31mFAIL"
                    return 1
                }
            done
            rm ${CONF}
            while read varline; do
                if [[ $(echo ${varline} | grep -w "Listen") ]]; then
                    if [[ -z ${END} ]]; then
                        echo -e "Listen ${newports}" >>${CONF}
                        END="True"
                    else
                        echo -e "${varline}" >>${CONF}
                    fi
                else
                    echo -e "${varline}" >>${CONF}
                fi
            done <<<"${NEWCONF}"
            msg -blanco "AGUARDE"
            service apache2 restart &>/dev/null
            sleep 1s
            msg -bar
            echo -e "\e[92m              PUERTOS REDEFINIDOS"
            msg -bar
        }
        edit_openvpn() {
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            msg -bar
            msg -blanco "REDEFINIR PUERTOS OPENVPN"
            msg -bar
            local CONF="/etc/openvpn/server.conf"
            local CONF2="/etc/openvpn/client-common.txt"
            local NEWCONF="$(cat ${CONF} | grep -v [Pp]ort)"
            local NEWCONF2="$(cat ${CONF2})"
            msg -ne "Nuevos puertos: "
            read -p "" newports
            for PTS in $(echo ${newports}); do
                verify_port openvpn "${PTS}" && echo -e "\033[1;33mPort $PTS \033[1;32mOK" || {
                    echo -e "\033[1;33mPort $PTS \033[1;31mFAIL"
                    return 1
                }
            done
            rm ${CONF}
            while read varline; do
                echo -e "${varline}" >>${CONF}
                if [[ ${varline} = "proto tcp" ]]; then
                    echo -e "port ${newports}" >>${CONF}
                fi
            done <<<"${NEWCONF}"
            rm ${CONF2}
            while read varline; do
                if [[ $(echo ${varline} | grep -v "remote-random" | grep "remote") ]]; then
                    echo -e "$(echo ${varline} | cut -d' ' -f1,2) ${newports} $(echo ${varline} | cut -d' ' -f4)" >>${CONF2}
                else
                    echo -e "${varline}" >>${CONF2}
                fi
            done <<<"${NEWCONF2}"
            msg -blanco "AGUARDE"
            service openvpn restart &>/dev/null
            /etc/init.d/openvpn restart &>/dev/null
            sleep 1s
            msg -bar
            echo -e "\e[92m               PUERTOS REDEFINIDOS"
            msg -bar
        }
        edit_dropbear() {
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            tput cuu1 >&2 && tput dl1 >&2
            msg -bar
            msg -blanco "REDEFINIR PUERTOS DROPBEAR"
            msg -bar
            local CONF="/etc/default/dropbear"
            local NEWCONF="$(cat ${CONF} | grep -v "DROPBEAR_EXTRA_ARGS")"
            msg -ne "Nuevos Puertos: "
            read -p "" newports
            for PTS in $(echo ${newports}); do
                verify_port dropbear "${PTS}" && echo -e "\033[1;33mPort $PTS \033[1;32mOK" || {
                    echo -e "\033[1;33mPort $PTS \033[1;31mFAIL"
                    return 1
                }
            done
            rm -rf ${CONF}
            while read varline; do
                echo -e "${varline}" >>${CONF}
                if [[ ${varline} = "NO_START=1" ]]; then
                    echo -e 'DROPBEAR_EXTRA_ARGS="VAR"' >>${CONF}
                    for NPT in $(echo ${newports}); do
                        sed -i "s/VAR/-p ${NPT} VAR/g" ${CONF}
                    done
                    sed -i "s/VAR//g" ${CONF}
                fi
            done <<<"${NEWCONF}"
            msg -blanco "AGUARDE"
            SOPORTE rd &>/dev/null
            sleep 1s
            msg -bar
            echo -e "\e[92m              PUERTOS REDEFINIDOS"
            msg -bar
        }
        edit_openssh() {
            msg -blanco "REDEFINIR PUERTOS OPENSSH"
            msg -bar
            local CONF="/etc/ssh/sshd_config"
            local NEWCONF="$(cat ${CONF} | grep -v [Pp]ort)"
            msg -ne "Nuevos Puertos: "
            read -p "" newports
            for PTS in $(echo ${newports}); do
                verify_port sshd "${PTS}" && echo -e "\033[1;33mPort $PTS \033[1;32mOK" || {
                    echo -e "\033[1;33mPort $PTS \033[1;31mFAIL"
                    return 1
                }
            done
            rm ${CONF}
            for NPT in $(echo ${newports}); do
                echo -e "Port ${NPT}" >>${CONF}
            done
            while read varline; do
                echo -e "${varline}" >>${CONF}
            done <<<"${NEWCONF}"
            msg -blanco "AGUARDE"
            service ssh restart &>/dev/null
            service sshd restart &>/dev/null
            sleep 1s
            msg -bar
            echo -e "\e[92m              PUERTOS REDEFINIDOS"
            msg -bar
        }

        main_fun() {
            clear && clear
            msg -bar
            msg -tit ""
            msg -bar
            msg -amarillo "                EDITAR PUERTOS ACTIVOS "
            msg -bar
            unset newports
            i=0
            while read line; do
                let i++
                case $line in
                squid | squid3) squid=$i ;;
                apache | apache2) apache=$i ;;
                openvpn) openvpn=$i ;;
                dropbear) dropbear=$i ;;
                sshd) ssh=$i ;;
                esac
            done <<<"$(port | cut -d' ' -f1 | sort -u)"
            for ((a = 1; a <= $i; a++)); do
                [[ $squid = $a ]] && echo -ne "\033[1;32m [$squid] > " && msg -blanco "REDEFINIR PUERTOS SQUID"
                [[ $apache = $a ]] && echo -ne "\033[1;32m [$apache] > " && msg -blanco "REDEFINIR PUERTOS APACHE"
                [[ $openvpn = $a ]] && echo -ne "\033[1;32m [$openvpn] > " && msg -blanco "REDEFINIR PUERTOS OPENVPN"
                [[ $dropbear = $a ]] && echo -ne "\033[1;32m [$dropbear] > " && msg -blanco "REDEFINIR PUERTOS DROPBEAR"
                [[ $ssh = $a ]] && echo -ne "\033[1;32m [$ssh] > " && msg -blanco "REDEFINIR PUERTOS SSH"
            done
            echo -ne "$(msg -bar)\n\033[1;32m [0] > " && msg -blanco "\e[97m\033[1;41m VOLVER \033[1;37m"
            msg -bar
            while true; do
                echo -ne "\033[1;37mSeleccione: " && read selection
                tput cuu1 && tput dl1
                [[ ! -z $squid ]] && [[ $squid = $selection ]] && edit_squid && break
                [[ ! -z $apache ]] && [[ $apache = $selection ]] && edit_apache && break
                [[ ! -z $openvpn ]] && [[ $openvpn = $selection ]] && edit_openvpn && break
                [[ ! -z $dropbear ]] && [[ $dropbear = $selection ]] && edit_dropbear && break
                [[ ! -z $ssh ]] && [[ $ssh = $selection ]] && edit_openssh && break
                [[ "0" = $selection ]] && break
            done
            #exit 0
        }
        main_fun
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }

    cambiopass() { #CAMBIO DE PASS ROOT
        echo -e "${BLANCO} Esta herramienta cambia la contraseña de su servidor vps"
        echo -e "${BLANCO} Esta contraseña es utilizada como usuario root"
        msg -bar
        echo -ne "Desea Seguir? [S/N]: "
        read x
        [[ $x = @(n|N) ]] && msg -bar && return
        msg -bar
        #Inicia Procedimentos
        echo -e "${BLANCO} Escriba su nueva contraseña"
        msg -bar
        read -p " Nuevo passwd: " pass
        (
            echo $pass
            echo $pass
        ) | passwd root 2>/dev/null
        sleep 1s
        msg -bar
        echo -e "${BLANCO} Contraseña cambiada con exito!"
        echo -e "${BLANCO} Su contraseña ahora es: ${VERDE}$pass"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    rootpass() { #AGREGAR ROOT A AWS Y GOOGLE VPS
        clear
        msg -bar
        echo -e "${BLANCO}  Esta herramienta cambia a usuario root las VPS de "
        echo -e "${BLANCO}             GoogleCloud y Amazon"
        msg -bar
        echo -ne " Desea Seguir? [S/N]: "
        read x
        [[ $x = @(n|N) ]] && msg -bar && return
        msg -bar
        #Inicia Procedimentos
        echo -e "                 Aplicando Configuraciones"
        fun_bar "service ssh restart"
        #Parametros Aplicados
        sed -i "s;PermitRootLogin prohibit-password;PermitRootLogin yes;g" /etc/ssh/sshd_config
        sed -i "s;PermitRootLogin without-password;PermitRootLogin yes;g" /etc/ssh/sshd_config
        sed -i "s;PasswordAuthentication no;PasswordAuthentication yes;g" /etc/ssh/sshd_config
        msg -bar
        echo -e "Escriba su contraseña root actual o cambiela"
        msg -bar
        read -p " Nuevo passwd: " pass
        (
            echo $pass
            echo $pass
        ) | passwd 2>/dev/null
        sleep 1s
        msg -bar
        echo -e "${BLANCO} Configuraciones aplicadas con exito!"
        echo -e "${BLANCO} Su contraseña ahora es: ${VERDE}$pass"
        service ssh restart >/dev/null 2>&1
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    pamcrack() { #DESACTIVAR PASS ALFANUMERICO
        echo -e "${BLANCO} Liberar passwd ALFANUMERICO"
        msg -bar
        echo -ne " Desea Seguir? [S/N]: "
        read x
        [[ $x = @(n|N) ]] && msg -bar && return
        echo -e ""
        wget -O /etc/pam.d/common-password https://github.com/Angel892/vpsmanager/raw/master/helpers/common-password &>/dev/null
        chmod +rwx /etc/pam.d/common-password
        fun_bar "service ssh restart"
        echo -e ""
        echo -e " \033[1;31m[ ! ]\033[1;33m Pass Alfanumerico Desactivado"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\e[1;93m            AJUSTES INTERNOS DEL VPS  "
    msg -bar
    echo -e "\e[1;93m  [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR HOSTNAME VPS"
    echo -e "\e[1;93m  [\e[1;32m2\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR CONTRASEÑA ROOT"
    echo -e "\e[1;93m  [\e[1;32m3\e[1;93m]\033[1;31m > \e[1;97mAGREGAR ROOT a GoogleCloud y Amazon"
    echo -e "\e[1;93m  [\e[1;32m4\e[1;93m]\033[1;31m > \e[1;97mDESACTIVAR PASS ALFANUMERICO"
    echo -e "\e[1;93m  [\e[1;32m5\e[1;93m]\033[1;31m > \e[1;97mEDITOR DE PUERTOS"
    msg -bar
    echo -e "    \e[97m\033[1;41m ENTER SIN RESPUESTA REGRESA A MENU ANTERIOR \033[0;97m"
    msg -bar
    echo -ne "\033[0;97m  └⊳ Seleccione una Opcion: \033[1;32m" && read opx
    tput cuu1 && tput dl1

    case $opx in
    1)
        host_name
        ;;
    2)
        cambiopass
        ;;
    3)
        rootpass
        ;;
    4)
        pamcrack
        ;;
    5)
        editports
        ;;
    *)
        return
        ;;
    esac

}
