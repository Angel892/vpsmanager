#--- PROTOCOLO SSLH
sshl_install() {
    clear && clear
    declare -A cor=([0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m")
    sslh_inicial() {
        clear && clear
        [[ $(dpkg --get-selections | grep -w "sslh" | head -1) ]] && {
            msg -bar
            echo -e "\033[1;31m                 DESINSTALANDO SSLH"
            msg -bar
            service sslh stop >/dev/null 2>&1
            fun_bar "apt-get purge sslh -y"
            msg -bar
            echo -e "\033[1;32m        >> SSLH DESINSTALADO  CON EXITO <<"
            msg -bar
            return 0
        }
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;93m           INSTALADOR SSLH SCRIPT LXServer"
        msg -bar
        echo -e "\033[1;32m                 Instalando SSLH"
        msg -bar
        echo -e "\033[1;97m A continuacion se le pedira tipo de instalacion\nescojer \033[1;31mstandalone \033[1;97my dar ENTER"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m  Presiona enter para Continuar \n'
        msg -bar
        clear && clear
        apt-get install sslh -y
        msg -bar
        msg -verde "              >> INSTALADO CON EXITO <<"
        msg -bar
        return 0
    }

    edit_sslh() {
        clear && clear
        service sslh stop >/dev/null 2>&1
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;32m              CONFIGURAR E INICIAR SSLH"
        msg -bar
        while true; do
            echo -ne "\033[1;97m Puerto principal SSLH:\033[1;32m" && read -p " " -e -i "443" SSLHPORT
            [[ $(mportas | grep -w "$SSLHPORT") ]] || break
            echo -e "\033[1;33m Este Puerto esta en uso usar Otro"
            sleep 5s
            tput cuu1 && tput dl1
            tput cuu1 && tput dl1
            unset SSLPORT
        done
        #SELECC PORT SSH
        portssh() {
            echo 'DAEMON=/usr/sbin/sslh' >/etc/default/sslh
            echo 'Run=yes' >>/etc/default/sslh
            chmod +x /etc/default/sslh
            echo -ne "\033[1;97m -- > \033[1;93m Cual es su Puerto SSH:\033[1;32m" && read -p " " -e -i "22" SSHPORT
            PORTSSHF="--ssh 127.0.0.1:$SSHPORT"
        }
        portssl() {
            echo -ne "\033[1;97m -- > \033[1;93m Cual es su Puerto SSL:\033[1;32m" && read -p " " -e -i "442" SSLPORT
            PORTSSLF="--ssl 127.0.0.1:$SSLPORT"
        }
        portopenvpn() {
            echo -ne "\033[1;97m -- > \033[1;93m Cual es su Puerto SSL:\033[1;32m" && read -p " " -e -i "1194" OPENVPNPORT
            PORTOPENVPNF="--openvpn 127.0.0.1:$OPENVPNPORT"
        }
        portauto() {
            echo -ne "\033[1;97m -- > \033[1;93m Cual es su Puerto AUTOMATICO:\033[1;32m" && read -p " " -e -i "80" AUTOMATICO
            AUTOMATICO="--anyprot 127.0.0.1:$AUTOMATICO"
        }
        echo -ne "\n\e[1;96m Agregar Port SSH\e[1;93m [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read portssh
        echo 'DAEMON=/usr/sbin/sslh' >/etc/default/sslh
        echo 'Run=yes' >>/etc/default/sslh
        chmod +x /etc/default/sslh
        [[ "$portssh" = "s" || "$portssh" = "S" ]] && portssh
        echo -ne "\e[1;96m Agregar Port SSL\e[1;93m [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read portssl
        [[ "$portssl" = "s" || "$portssl" = "S" ]] && portssl
        echo -ne "\e[1;96m Agregar Port OPENVPN\e[1;93m [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read portopenvpn
        [[ "$portopenvpn" = "s" || "$portopenvpn" = "S" ]] && portopenvpn
        echo -ne "\e[1;96m Agregar Port AUTOMATICO\e[1;93m [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read portauto
        [[ "$portauto" = "s" || "$portauto" = "S" ]] && portauto

        echo 'DAEMON_OPTS="--user sslh --listen 0.0.0.0:'$SSLHPORT' '$PORTSSHF' '$PORTSSLF' '$PORTOPENVPNF' '$AUTOMATICO' --pidfile /var/run/sslh/sslh.pid"' >>/etc/default/sslh
        service sslh restart
        sleep 3s
        msg -bar
        SSLH=$(ps -ef | grep "/var/run/sslh/sslh.pid" | grep -v grep | awk -F "pts" '{print $1}')
        [[ -z ${SSLH} ]] && SSLH="\033[1;31m               >> FALLO << " || SSLH="\033[1;32m           >> SSLH INSTALADO CON EXITO << "
        echo -e "$SSLH"
        msg -bar
        return 0
    }

    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\e[1;93m          INSTALADOR DE SSLH | SCRIPT LXServer"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR | DESISNTALAR SSLH \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m EDITAR PUERTOS SSLH\e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    case $opcao in
    1)
        msg -bar
        sslh_inicial
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    2)
        msg -bar
        edit_sslh
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    0)
        return
        ;;
    esac

    sshl_install
}
