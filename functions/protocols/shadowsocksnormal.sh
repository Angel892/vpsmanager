#--- PROTO SHADOWSOCK NORMAL
proto_shadowsockN() {
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
    vpsIP() {
        MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
        MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
        [[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
    }
    fun_eth() {
        eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
        [[ $eth != "" ]] && {
            msg -bar
            echo -e "${BLANCO}  Aplicar Sistema Para Mejorar Paquetes SSH?"
            echo -e "${BLANCO}  Opcion Para Usuarios Avanzados"
            msg -bar
            read -p " [S/N]: " -e -i n sshsn
            [[ "$sshsn" = @(s|S|y|Y) ]] && {
                echo -e "${VERDE} Correccion de problemas de paquetes en SSH..."
                echo -e " Cual es la Tasa de RX"
                echo -ne "[ 1 - 999999999 ]: "
                read rx
                [[ "$rx" = "" ]] && rx="999999999"
                echo -e " Cual es la Tasa de  TX"
                echo -ne "[ 1 - 999999999 ]: "
                read tx
                [[ "$tx" = "" ]] && tx="999999999"
                apt-get install ethtool -y >/dev/null 2>&1
                ethtool -G $eth rx $rx tx $tx >/dev/null 2>&1
            }
            msg -bar
        }
    }

    fun_shadowsocks() {
        [[ -e /etc/shadowsocks.json ]] && {

            clear && clear
            msg -bar
            echo -e "\033[1;31m               DESINSTALANDO SHADOWSOCK"
            msg -bar
            [[ $(ps x | grep ssserver | grep -v grep | awk '{print $1}') != "" ]] && kill -9 $(ps x | grep ssserver | grep -v grep | awk '{print $1}') >/dev/null 2>&1 && ssserver -c /etc/shadowsocks.json -d stop >/dev/null 2>&1
            echo -e "\033[1;32m     >> SHADOWSOCK-N DESINSTALADO CON EXITO << "
            msg -bar
            rm /etc/shadowsocks.json
            menuProtocols
        }
        while true; do
            clear && clear
            msg -bar
            msg -tit
            msg -bar
            msg -ama "      INSTALADOR SHADOWSOCKS | SCRIPT LXServer"
            msg -bar
            echo -e "\033[1;97m Selecione una Criptografia"
            msg -bar
            encript=(aes-256-gcm aes-192-gcm aes-128-gcm aes-256-ctr aes-192-ctr aes-128-ctr aes-256-cfb aes-192-cfb aes-128-cfb camellia-128-cfb camellia-192-cfb camellia-256-cfb chacha20-ietf-poly1305 chacha20-ietf chacha20 rc4-md5)
            for ((s = 0; s < ${#encript[@]}; s++)); do
                echo -e " [${s}] - ${encript[${s}]}"
            done
            msg -bar
            while true; do
                unset cript
                echo -ne "\033[1;97mEscoja una Criptografia:\033[1;32m " && read -p " " -e -i "0" cript
                [[ ${encript[$cript]} ]] && break
                echo -e "Opcion Invalida"
            done
            encriptacao="${encript[$cript]}"
            [[ ${encriptacao} != "" ]] && break
            echo -e "Opcion Invalida"
        done
        #ESCOLHENDO LISTEN
        msg -bar
        echo -e "\033[1;97m Seleccione el puerto para Shadowsocks\033[0m"
        msg -bar
        while true; do
            unset Lport
            echo -ne "\033[1;97m  Puerto:\033[1;32m " && read Lport
            [[ $(mportas | grep "$Lport") = "" ]] && break
            echo -e " ${Lport}: Puerto Invalido"
        done
        #INICIANDO
        msg -bar
        echo -ne "\033[1;97m  Ingrese una contraseña:\033[1;32m " && read Pass
        msg -bar
        echo -e "\033[1;97m            -- Iniciando Instalacion -- "
        msg -bar
        echo -e "\033[1;93m Despaquetando Shadowsock"
        fun_bar 'sudo apt-get install shadowsocks -y'
        echo -e "\033[1;93m Despaquetando libsodium"
        fun_bar 'sudo apt-get install libsodium-dev -y'
        echo -e "\033[1;93m Despaquetando python-pip"
        fun_bar 'sudo apt-get install python-pip -y'
        echo -e "\033[1;93m Despaquetando setups"
        fun_bar 'sudo pip install --upgrade setuptools'
        echo -e "\033[1;93m Actualizando Ficheros"
        fun_bar 'pip install --upgrade pip -y'
        echo -e "\033[1;93m Revisando Ficheros"
        fun_bar 'pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U'
        echo -ne '{\n"server":"' >/etc/shadowsocks.json
        echo -ne "0.0.0.0" >>/etc/shadowsocks.json
        echo -ne '",\n"server_port":' >>/etc/shadowsocks.json
        echo -ne "${Lport},\n" >>/etc/shadowsocks.json
        echo -ne '"local_port":1080,\n"password":"' >>/etc/shadowsocks.json
        echo -ne "${Pass}" >>/etc/shadowsocks.json
        echo -ne '",\n"timeout":600,\n"method":"' >>/etc/shadowsocks.json
        echo -ne "${encriptacao}" >>/etc/shadowsocks.json
        echo -ne '"\n}' >>/etc/shadowsocks.json
        ssserver -c /etc/shadowsocks.json -d start >/dev/null 2>&1
        value=$(ps x | grep ssserver | grep -v grep)
        [[ $value != "" ]] && value="\033[1;32m      >> SHADOW SOCK INSTALADO CON EXITO << " || value="\033[1;31m            ERROR"
        msg -bar
        echo -e "${value}"
        msg -bar
        return 0
    }
    fun_shadowsocks
    ufw disable >/dev/null 2>&1
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    proto_shadowsockN
}
