#--- PROTOCOLO TPOVER
proto_ptcpover() {
    activar_tcpover() {
        meu_ip() {
            MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
            MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
            [[ "$MEU_IP" != "$MEU_IP2" ]] && echo "$MEU_IP2" || echo "$MEU_IP"
        }
        IP=(meu_ip)
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
        echo -e "\033[1;33m     INSTALADOR DE TCPOVER | SCRIPT LATAM \033[1;37m"
        msg -bar
        porta_socket=
        while [[ -z $porta_socket || ! -z $(mportas | grep -w $porta_socket) ]]; do
            echo -ne "\033[1;97m Digite el Puerto para el TCPOVER:\033[1;92m" && read -p " " -e -i "8888" porta_socket
        done
        msg -bar
        echo -ne "\033[1;97m Digite una banner txt:\n \033[1;31m" && read -p " " -e -i "SCRIP-LATAM" passg
        msg -bar
        while read service; do
            [[ -z $service ]] && break
            echo "127.0.0.1:$(echo $service | cut -d' ' -f2)=$(echo $service | cut -d' ' -f1)"
        done <<<"$(mportas)"
        [[ -e $HOME/socks ]] && rm -rf $HOME/socks >/dev/null 2>&1
        [[ -d $HOME/socks ]] && rm -rf $HOME/socks >/dev/null 2>&1
        cd $HOME && mkdir socks >/dev/null 2>&1
        cd socks
        patch="https://raw.githubusercontent.com/NetVPS/LATAM_Oficial/main/Ejecutables/backsocz.zip"
        arq="backsocz.zip"
        wget $patch >/dev/null 2>&1
        unzip $arq >/dev/null 2>&1
        mv -f /root/socks/backsocz/./ssh /etc/ssh/sshd_config && service ssh restart 1>/dev/null 2>/dev/null
        mv -f /root/socks/backsocz/sckt$(python3 --version | awk '{print $2}' | cut -d'.' -f1,2) /usr/sbin/sckt
        mv -f /root/socks/backsocz/scktcheck /bin/scktcheck
        chmod +x /bin/scktcheck
        chmod +x /usr/sbin/sckt
        rm -rf $HOME/root/socks
        cd $HOME
        screen -dmS sokz scktcheck "$porta_socket" "$passg" >/dev/null 2>&1
        [[ "$(ps x | grep scktcheck | grep -v grep | awk '{print $1}')" ]] && msg -verd "         >> TCPOVER INSTALADO CON EXITO <<" || msg -ama "               ERROR VERIFIQUE"
        msg -bar
    }

    desactivar_gettunel() {
        clear && clear
        msg -bar
        echo -e "\033[1;31m                DESINSTALAR TCPOVER  "
        msg -bar
        echo -e "\033[1;97m Procesando ...."
        fun_bar "kill -9 $(ps x | grep scktcheck | grep -v grep | awk '{print $1'}) >/dev/null 2>&1"
        msg -bar
        [[ ! "$(ps x | grep scktcheck | grep -v grep | awk '{print $1}')" ]] && echo -e "\033[1;32m       >> TCPOVER DESINSTALADO CON EXITO << "
        msg -bar
    }

    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\033[1;33m       INSTALADOR DE GETTUNEL | SCRIPT LATAM \033[1;37m"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR TCPOVER  \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m DETENER TCPOVER \e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -bra "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    case $opcao in
    1)
        msg -bar
        activar_tcpover
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    2)
        msg -bar
        desactivar_gettunel
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    esac
    menu_inst

}
