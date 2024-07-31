#--- SLOWN DNS
proto_slowndns() {
    mkdir -p $mainPath/temp/SlowDNS/install >/dev/null 2>&1
    mkdir -p $mainPath/temp/SlowDNS/Key >/dev/null 2>&1
    SlowDNSinstall="$mainPath/temp/SlowDNS/install"
    SlowDNSconf="$mainPath/temp/SlowDNS/Key"
    info() {

        nodata() {
            msg -bar
            echo -e "\e[1;91m        NOSE CUENTA CON REGISTRO DE SLOWDNS"
            return 1
        }
        echo -e "\e[1;97m        INFORMACION DE SU CONECCION SLOWDNS"
        [[ -e ${SlowDNSconf}/domain_ns ]] && msg -amarillo "Su NS (Nameserver): $(cat ${SlowDNSconf}/domain_ns)" || nodata
        [[ -e ${SlowDNSconf}/server.pub ]] && msg -amarillo "Su Llave: $(cat ${SlowDNSconf}/server.pub)"
    }

    drop_port() {
        local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
        local NOREPEAT
        local reQ
        local Port
        unset DPB
        while read port; do
            reQ=$(echo ${port} | awk '{print $1}')
            Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
            [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
            NOREPEAT+="$Port\\n"

            case ${reQ} in
            sshd | dropbear | trojan | stunnel4 | stunnel | python | python3 | v2ray | xray) DPB+=" $reQ:$Port" ;;
            *) continue ;;
            esac
        done <<<"${portasVAR}"
    }

    ini_slow() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        msg -amarillo "               INSTALADOR SLOWDNS"
        msg -bar
        drop_port
        n=1
        for i in $DPB; do
            proto=$(echo $i | awk -F ":" '{print $1}')
            proto2=$(printf '%-12s' "$proto")
            port=$(echo $i | awk -F ":" '{print $2}')
            echo -e " \e[1;93m [\e[1;32m$n\e[1;93m]\033[1;31m $(msg -rojo2 ">") $(msg -amarillo "$proto2")$(msg -azu "$port")"
            drop[$n]=$port
            num_opc="$n"
            let n++
        done
        msg -bar
        opc=$(selectionFun $num_opc)
        echo "${drop[$opc]}" >${SlowDNSconf}/puerto
        PORT=$(cat ${SlowDNSconf}/puerto)
        msg -bar "              INSTALADOR SLOWDNS"
        msg -bar
        echo -e " $(msg -amarillo "Puerto de coneccion atraves de SlowDNS:") $(msg -verde "$PORT")"
        msg -bar

        unset NS
        while [[ -z $NS ]]; do
            echo -ne "\e[1;93m Tu dominio NS: \e[1;31m" && read NS
            tput cuu1 && tput dl1
        done
        echo "$NS" >${SlowDNSconf}/domain_ns
        echo -e " $(msg -amarillo "Tu dominio NS:") $(msg -verde "$NS")"
        msg -bar

        if [[ ! -e ${SlowDNSinstall}/dns-server ]]; then
            msg -amarillo " Descargando ejecutable SlowDNS"
            if wget -O ${SlowDNSinstall}/dns-server https://github.com/Angel892/vpsmanager/raw/master/LINKS_LIBRERIAS/dns-server &>/dev/null; then
                chmod +x ${SlowDNSinstall}/dns-server
                msg -verde "[OK]"
            else
                msg -rojo "[fail]"
                msg -bar
                msg -amarillo "No se pudo descargar el binario"
                msg -rojo "Instalacion canselada"
            fi
            msg -bar
        fi

        [[ -e "${SlowDNSconf}/server.pub" ]] && pub=$(cat ${SlowDNSconf}/server.pub)

        if [[ ! -z "$pub" ]]; then
            echo -ne "\e[1;93m Usar clave existente [S/N]: \e[1;32m" && read ex_key

            case $ex_key in
            s | S | y | Y)
                tput cuu1 && tput dl1
                echo -e " $(msg -amarillo "Tu clave:") $(msg -verde "$(cat ${SlowDNSconf}/server.pub)")"
                ;;
            n | N)
                tput cuu1 && tput dl1
                rm -rf ${SlowDNSconf}/server.key
                rm -rf ${SlowDNSconf}/server.pub
                ${SlowDNSinstall}/dns-server -gen-key -privkey-file ${SlowDNSconf}/server.key -pubkey-file ${SlowDNSconf}/server.pub &>/dev/null
                echo -e " $(msg -amarillo "Tu clave:") $(msg -verde "$(cat ${SlowDNSconf}/server.pub)")"
                ;;
            *) ;;
            esac
        else
            rm -rf ${SlowDNSconf}/server.key
            rm -rf ${SlowDNSconf}/server.pub
            ${SlowDNSinstall}/dns-server -gen-key -privkey-file ${SlowDNSconf}/server.key -pubkey-file ${SlowDNSconf}/server.pub &>/dev/null
            echo -e " $(msg -amarillo "Tu clave:") $(msg -verde "$(cat ${SlowDNSconf}/server.pub)")"
        fi
        msg -bar
        msg -amarillo "   Iniciando SlowDNS...."

        iptables -I INPUT -p udp --dport 5300 -j ACCEPT
        iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
        echo "nameserver 1.1.1.1 " >/etc/resolv.conf
        echo "nameserver 1.0.0.1 " >>/etc/resolv.conf

        if screen -dmS slowdns ${SlowDNSinstall}/dns-server -udp :5300 -privkey-file ${SlowDNSconf}/server.key $NS 127.0.0.1:$PORT; then
            msg -verde "              >> INSTALADO CON EXITO <<"
        else
            msg -rojo "Con fallo!!!"
        fi

    }

    reset_slow() {
        clear && clear
        msg -bar
        msg -amarillo "                REINICIANDO SLOWDNS...."
        screen -S slowdns -p 0 -X quit
        [[ -e ${SlowDNSconf}/domain_ns ]] && NS=$(cat ${SlowDNSconf}/domain_ns)
        [[ -e ${SlowDNSconf}/puerto ]] && PORT=$(cat ${SlowDNSconf}/puerto)
        screen -dmS slowdns ${SlowDNSinstall}/dns-server -udp :5300 -privkey-file /root/server.key $NS 127.0.0.1:$PORT
        msg -verde "              >> REINICIADO CON EXITO << "

    }
    stop_slow() {

        echo -e "\e[1;31m                DESISNTALAR SLOWDNS"
        screen -S slowdns -p 0 -X quit
        msg -verde "            >> DESINSTALADO CON EXITO << "

    }
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\e[1;93m                INSTALADOR SLOWNDNS"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR SLOWDNS\e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m REINICIAR SLOWDNS \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m3\e[1;93m]\033[1;31m > \033[1;97m INFORMACON \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m4\e[1;93m]\033[1;31m > \033[1;97m DETENER SLOWNDNS \e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    tput cuu1 && tput dl1
    case $opcao in

    1)
        ini_slow
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    2)
        reset_slow
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    3)
        info
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    4)
        stop_slow
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    0)
        return
        ;;
    esac

    proto_slowndns
}
