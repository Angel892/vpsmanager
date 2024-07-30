##-->>PROTOCOLO UDP SERVER
udp_serverr() {

    activar_badvpn() {
        mportas() {
            unset portas
            portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
            while read port; do
                var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
                [[ "$(echo -e $portas | grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
            done <<<"$portas_var"
            i=1
            echo -e "$portas"
        }
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        msg -amarillo "            INSTALADOR DE UDP-REQUEST"
        msg -bar
        echo -e "\033[1;97mDigite los puertos a activar de forma secuencial\nEjemplo:\033[1;32m 53 5300 5200 \033[1;97m| \033[1;93mPuerto recomendado \033[1;32m 5300\n"
        echo -ne "\033[1;97mDigite los Puertos:\033[1;32m " && read -p " " -e -i "53 5300" portasx
        validarArchivo "$mainPath/PortM/UDP-server.log"
        echo "$portasx" >$mainPath/PortM/UDP-server.log
        msg -bar
        totalporta=($portasx)
        unset PORT
        for ((i = 0; i < ${#totalporta[@]}; i++)); do
            [[ $(mportas | grep "${totalporta[$i]}") = "" ]] && {
                PORT+="${totalporta[$i]}\n"
                ip_nat=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n 1p)
                interfas=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | grep "$ip_nat" | awk {'print $NF'})
                ip_publica=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<<"$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")
                cat <<EOF >/etc/systemd/system/UDPserver.service
[Unit]
Description=UDPserver Service by LXServer
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/usr/bin/udpServer -ip=$ip_publica -net=$interfas -exclude=${totalporta[$i]} -mode=system
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target6
EOF

                systemctl start UDPserver &>/dev/null
                echo -e "\033[1;33m Puerto Escojido:\033[1;32m ${totalporta[$i]} OK"
            } || {
                echo -e "\033[1;33m Puerto Escojido:\033[1;31m ${totalporta[$i]} FAIL"
            }
        done
        [[ -z $PORT ]] && {
            echo -e "\033[1;31m  No se ha elegido ninguna puerto valido, reintente\033[0m"
            return 1
        }
        sleep 3s
        msg -bar

        [[ "$(ps x | grep /usr/bin/udpServer | grep -v grep | awk '{print $1}')" ]] && msg -verde "        >> UDP-SERVER INSTALADO CON EXITO <<" || msg -amarillo "               ERROR VERIFIQUE"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }

    desactivar_badvpn() {
        clear && clear
        msg -bar
        echo -e "\033[1;31m            DESISNTALANDO PUERTOS UDP-SERVER "
        msg -bar
        systemctl stop UDPserver &>/dev/null
        systemctl disable UDPserver &>/dev/null
        rm -rf /etc/systemd/system/UDPserver.service &>/dev/null
        rm -rf /usr/bin/udpServer
        validarArchivo "$mainPath/PortM/UDP-server.log"
        rm -rf $mainPath/PortM/UDP-server.log
        [[ ! "$(ps x | grep "/usr/bin/udpServer" | grep -v grep | awk '{print $1}')" ]] && echo -e "\033[1;32m        >> UDP-SERVER DESINSTALADO CON EXICO << "
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }

    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msg -amarillo "            INSTALADOR DE UDP-REQUEST"
    msg -bar
    if [[ ! -e /usr/bin/udpServer ]]; then
        wget -O /usr/bin/udpServer 'https://bitbucket.org/iopmx/udprequestserver/downloads/udpServer' &>/dev/null
        chmod +x /usr/bin/udpServer
    fi
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR UDP-SERVER  \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m DETENER TODOS LOS UDP-SERVER\e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    case $opcao in
    1)
        msg -bar
        activar_badvpn
        ;;
    2)
        msg -bar
        desactivar_badvpn
        ;;
    0)
        return;
        ;;
    *)
        echo -e "$ Porfavor use numeros del [0-14]"
        msg -bar
        udp_serverr
        ;;
    esac

    #exit 0
}
