#!/bin/bash

#--- MONITOR DE PROTOCOLOS AUTO
monservi_fun() {
    #AUTO INICIAR
    automprotos() {
        echo '#!/bin/sh -e' >/etc/rc.local
        sudo chmod +x /etc/rc.local
        echo "sudo rebootnb reboot" >>/etc/rc.local
        echo "sudo rebootnb resetprotos" >>/etc/rc.local
    }
    autobadvpn() {
        echo "sudo rebootnb resetbadvpn" >>/etc/rc.local
    }
    autowebsoket() {
        echo "sudo rebootnb resetwebsocket" >>/etc/rc.local
    }
    autolimitador() {
        echo "sudo rebootnb resetlimitador" >>/etc/rc.local
    }
    autodesbloqueador() {
        echo "sudo rebootnb resetdesbloqueador" >>/etc/rc.local
    }
    #MONITOREAR
    monssh() {
        echo "resetssh" >$mainPath/temp/monitorpt
    }
    mondropbear() {
        echo "resetdropbear" >>$mainPath/temp/monitorpt
    }
    monssl() {
        echo "resetssl" >>$mainPath/temp/monitorpt
    }
    monsquid() {
        echo "resetsquid" >>$mainPath/temp/monitorpt
    }
    monapache() {
        echo "resetapache" >>$mainPath/temp/monitorpt
    }
    monv2ray() {
        echo "resetv2ray" >>$mainPath/temp/monitorpt
    }
    monwebsoket() {
        echo "resetwebp" >>$mainPath/temp/monitorpt
    }
    showCabezera "MONITOR DE SERVICIONS PRINCIPALES"
    #AUTO INICIOS
    PIDVRF3="$(ps aux | grep "monitorproto" | grep -v grep | awk '{print $2}')"
    if [[ -z $PIDVRF3 ]]; then
        echo -e "\e[1;32m >>> AUTO INICIOS"
        echo -ne "\e[1;96m # Iniciar M-PROTOCOLOS ante reboot\e[1;93m [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read automprotos
        echo '#!/bin/sh -e' >/etc/rc.local
        sudo chmod +x /etc/rc.local
        echo "sudo rebootnb reboot" >>/etc/rc.local
        [[ "$automprotos" = "s" || "$automprotos" = "S" ]] && automprotos
        echo -ne "\e[1;97m Iniciar BADVPN ante reboot\e[1;93m ....... [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read autobadvpn
        [[ "$autobadvpn" = "s" || "$autobadvpn" = "S" ]] && autobadvpn
        echo -ne "\e[1;97m Iniciar PROXY-WEBSOKET ante reboot\e[1;93m [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read autowebsoket
        [[ "$autowebsoket" = "s" || "$autowebsoket" = "S" ]] && autowebsoket
        echo -ne "\e[1;97m Iniciar LIMITADOR ante reboot\e[1;93m .... [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read autolimitador
        [[ "$autolimitador" = "s" || "$autolimitador" = "S" ]] && autolimitador
        echo -ne "\e[1;97m Iniciar DESBLOQUEADOR ante reboot\e[1;93m  [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read autodesbloqueador
        [[ "$autodesbloqueador" = "s" || "$autodesbloqueador" = "S" ]] && autodesbloqueador
        echo "sleep 2s" >>/etc/rc.local
        echo "exit 0" >>/etc/rc.local
        msg -bar
        echo -e "\e[1;32m >>> MONITOR DE PROTOCOLOS"
        echo -ne "\e[1;97m Monitorear SSH\e[1;93m ................... [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read monssh
        echo "null" >$mainPath/temp/monitorpt
        [[ "$monssh" = "s" || "$monssh" = "S" ]] && monssh
        echo -ne "\e[1;97m Monitorear DROPBEAR\e[1;93m .............. [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read mondropbear
        [[ "$mondropbear" = "s" || "$mondropbear" = "S" ]] && mondropbear
        echo -ne "\e[1;97m Monitorear SSL\e[1;93m ................... [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read monssl
        [[ "$monssl" = "s" || "$monssl" = "S" ]] && monssl
        echo -ne "\e[1;97m Monitorear SQUID\e[1;93m ................. [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read monsquid
        [[ "$monsquid" = "s" || "$monsquid" = "S" ]] && monsquid
        echo -ne "\e[1;97m Monitorear APACHE\e[1;93m ................ [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read monapache
        [[ "$monapache" = "s" || "$monapache" = "S" ]] && monapache
        echo -ne "\e[1;97m Monitorear V2RAY\e[1;93m ................. [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read monv2ray
        [[ "$monv2ray" = "s" || "$monv2ray" = "S" ]] && monv2ray
        echo -ne "\e[1;97m Monitorear PROXY WEBSOCKET\e[1;93m ....... [\033[1;97m s \033[1;93m| \033[1;97mn \033[1;93m]\033[1;97m: \e[1;32m" && read monwebsoket
        [[ "$monwebsoket" = "s" || "$monwebsoket" = "S" ]] && monwebsoket
        msg -bar
        echo -ne "\033[1;96m   ¿Cada cuantos segundos ejecutar el Monitor?\n\033[1;97m  +Segundos = -Uso de CPU | -Segundos = +Uso de CPU\033[0;92m \n                Predeterminado:\033[1;37m 120s\n     Cuantos Segundos (Numeros Unicamente): " && read tiemmoni
        error() {
            msg -verm "Tiempo invalido,se ajustara a 120s (Tiempo por Defeto)"
            sleep 5s
            tput cuu1
            tput dl1
            tput cuu1
            tput dl1
            tiemmoni="120"
            echo "${tiemmoni}" >$mainPath/temp/T-Mon

        }
        #[[ -z "$tiemmoni" ]] && tiemmoni="120"
        if [[ "$tiemmoni" != +([0-9]) ]]; then
            error
        fi
        [[ -z "$tiemmoni" ]] && tiemmoni="120"
        if [ "$tiemmoni" -lt "1" ]; then
            error
        fi
        echo "${tiemmoni}" >$mainPath/temp/T-Mon
        screen -dmS monitorproto watch -n $tiemmoni $mainPath/auto/monitorServicios.sh
    else
        for pid in $(echo $PIDVRF3); do
            screen -S monitorproto -p 0 -X quit
            rm -rf /etc/rc.local >/dev/null 2>&1
        done
    fi
    [[ -z ${VERY3} ]] && monitorservi="\033[1;32m ACTIVADO " || monitorservi="\033[1;31m DESACTIVADO "
    echo -e "            $monitorservi  --  CON EXITO"
    msgSuccess
}
