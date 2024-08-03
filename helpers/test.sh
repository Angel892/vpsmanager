#--- FIREWALL
firewall_fun() {

    PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
    export PATH
    declare -A cor=([0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m")

    sh_ver="1.0.11"
    Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
    Info="${Green_font_prefix}[Informacion]${Font_color_suffix}"
    Error="${Red_font_prefix}[Error]${Font_color_suffix}"

    smtp_port="25,26,465,587"
    pop3_port="109,110,995"
    imap_port="143,218,220,993"
    other_port="24,50,57,105,106,158,209,1109,24554,60177,60179"
    bt_key_word="torrent
.torrent
peer_id=
announce
info_hash
get_peers
find_node
BitTorrent
announce_peer
BitTorrent protocol
announce.php?passkey=
magnet:
xunlei
sandai
Thunder
XLLiveUD"

    check_sys() {
        if [[ -f /etc/redhat-release ]]; then
            release="centos"
        elif cat /etc/issue | grep -q -E -i "debian"; then
            release="debian"
        elif cat /etc/issue | grep -q -E -i "ubuntu"; then
            release="ubuntu"
        elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
            release="centos"
        elif cat /proc/version | grep -q -E -i "debian"; then
            release="debian"
        elif cat /proc/version | grep -q -E -i "ubuntu"; then
            release="ubuntu"
        elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
            release="centos"
        fi
        bit=$(uname -m)
    }
    check_BT() {
        Cat_KEY_WORDS
        BT_KEY_WORDS=$(echo -e "$Ban_KEY_WORDS_list" | grep "torrent")
    }
    check_SPAM() {
        Cat_PORT
        SPAM_PORT=$(echo -e "$Ban_PORT_list" | grep "${smtp_port}")
    }
    Cat_PORT() {
        Ban_PORT_list=$(iptables -t filter -L OUTPUT -nvx --line-numbers | grep "REJECT" | awk '{print $13}')
    }
    Cat_KEY_WORDS() {
        Ban_KEY_WORDS_list=""
        Ban_KEY_WORDS_v6_list=""
        if [[ ! -z ${v6iptables} ]]; then
            Ban_KEY_WORDS_v6_text=$(${v6iptables} -t mangle -L OUTPUT -nvx --line-numbers | grep "DROP")
            Ban_KEY_WORDS_v6_list=$(echo -e "${Ban_KEY_WORDS_v6_text}" | sed -r 's/.*\"(.+)\".*/\1/')
        fi
        Ban_KEY_WORDS_text=$(${v4iptables} -t mangle -L OUTPUT -nvx --line-numbers | grep "DROP")
        Ban_KEY_WORDS_list=$(echo -e "${Ban_KEY_WORDS_text}" | sed -r 's/.*\"(.+)\".*/\1/')
    }
    View_PORT() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        Cat_PORT
        echo -e "\e[97m=========${Red_background_prefix}  Puerto Bloqueado Actualmente  ${Font_color_suffix}==========="
        echo -e "$Ban_PORT_list"
    }
    View_KEY_WORDS() {
        Cat_KEY_WORDS
        echo -e "\e[97m=============${Red_background_prefix}  Actualmente Prohibido  ${Font_color_suffix}=============="
        echo -e "$Ban_KEY_WORDS_list"
    }
    View_ALL() {
        echo
        View_PORT
        View_KEY_WORDS
        msg -bar2

        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        firewall_fun
    }
    Save_iptables_v4_v6() {
        if [[ ${release} == "centos" ]]; then
            if [[ ! -z "$v6iptables" ]]; then
                service ip6tables save
                chkconfig --level 2345 ip6tables on
            fi
            service iptables save
            chkconfig --level 2345 iptables on
        else
            if [[ ! -z "$v6iptables" ]]; then
                ip6tables-save >/etc/ip6tables.up.rules
                echo -e "#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules\n/sbin/ip6tables-restore < /etc/ip6tables.up.rules" >/etc/network/if-pre-up.d/iptables
            else
                echo -e "#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules" >/etc/network/if-pre-up.d/iptables
            fi
            iptables-save >/etc/iptables.up.rules
            chmod +x /etc/network/if-pre-up.d/iptables
        fi
    }
    Set_key_word() {
        $1 -t mangle -$3 OUTPUT -m string --string "$2" --algo bm --to 65535 -j DROP
    }
    Set_tcp_port() {
        [[ "$1" = "$v4iptables" ]] && $1 -t filter -$3 OUTPUT -p tcp -m multiport --dports "$2" -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable
        [[ "$1" = "$v6iptables" ]] && $1 -t filter -$3 OUTPUT -p tcp -m multiport --dports "$2" -m state --state NEW,ESTABLISHED -j REJECT --reject-with tcp-reset
    }
    Set_udp_port() { $1 -t filter -$3 OUTPUT -p udp -m multiport --dports "$2" -j DROP; }
    Set_SPAM_Code_v4() {
        for i in ${smtp_port} ${pop3_port} ${imap_port} ${other_port}; do
            Set_tcp_port $v4iptables "$i" $s
            Set_udp_port $v4iptables "$i" $s
        done
    }
    Set_SPAM_Code_v4_v6() {
        for i in ${smtp_port} ${pop3_port} ${imap_port} ${other_port}; do
            for j in $v4iptables $v6iptables; do
                Set_tcp_port $j "$i" $s
                Set_udp_port $j "$i" $s
            done
        done
    }
    Set_PORT() {
        if [[ -n "$v4iptables" ]] && [[ -n "$v6iptables" ]]; then
            Set_tcp_port $v4iptables $PORT $s
            Set_udp_port $v4iptables $PORT $s
            Set_tcp_port $v6iptables $PORT $s
            Set_udp_port $v6iptables $PORT $s
        elif [[ -n "$v4iptables" ]]; then
            Set_tcp_port $v4iptables $PORT $s
            Set_udp_port $v4iptables $PORT $s
        fi
        Save_iptables_v4_v6
    }
    Set_KEY_WORDS() {
        key_word_num=$(echo -e "${key_word}" | wc -l)
        for ((integer = 1; integer <= ${key_word_num}; integer++)); do
            i=$(echo -e "${key_word}" | sed -n "${integer}p")
            Set_key_word $v4iptables "$i" $s
            [[ ! -z "$v6iptables" ]] && Set_key_word $v6iptables "$i" $s
        done
        Save_iptables_v4_v6
    }
    Set_BT() {
        key_word=${bt_key_word}
        Set_KEY_WORDS
        Save_iptables_v4_v6
    }
    Set_SPAM() {
        if [[ -n "$v4iptables" ]] && [[ -n "$v6iptables" ]]; then
            Set_SPAM_Code_v4_v6
        elif [[ -n "$v4iptables" ]]; then
            Set_SPAM_Code_v4
        fi
        Save_iptables_v4_v6
    }
    Set_ALL() {
        Set_BT
        Set_SPAM
    }
    Ban_BT() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\e[1;93m              PANEL DE FIREWALL LATAM"
        msg -bar
        check_BT
        [[ ! -z ${BT_KEY_WORDS} ]] && echo -e "${Error} Torrent bloqueados y Palabras Claves, no es\nnecesario volver a prohibirlas !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        s="A"
        Set_BT
        View_ALL
        echo -e "${Info} Torrent bloqueados y Palabras Claves !"
        msg -bar2
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        firewall_fun
    }
    Ban_SPAM() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\e[1;93m              PANEL DE FIREWALL LATAM"
        msg -bar
        check_SPAM
        [[ ! -z ${SPAM_PORT} ]] && echo -e "${Error} Se detectó un puerto SPAM bloqueado, no es\nnecesario volver a bloquear !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        s="A"
        Set_SPAM
        View_ALL
        echo -e "${Info} Puertos SPAM Bloqueados !"
        msg -bar2
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        firewall_fun
    }
    Ban_ALL() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\e[1;93m              PANEL DE FIREWALL LATAM"
        msg -bar
        check_BT
        check_SPAM
        s="A"
        if [[ -z ${BT_KEY_WORDS} ]]; then
            if [[ -z ${SPAM_PORT} ]]; then
                Set_ALL
                View_ALL
                echo -e "${Info} Torrent bloqueado, Palabras Claves y Puertos SPAM !"
                msg -bar2
            else
                Set_BT
                View_ALL
                echo -e "${Info} Torrent bloqueado y Palabras Claves !"
            fi
        else
            if [[ -z ${SPAM_PORT} ]]; then
                Set_SPAM
                View_ALL
                echo -e "${Info} Puerto SPAM (spam) prohibido !"
            else
                echo -e "${Error} Torrent Bloqueado, Palabras Claves y\n Puertos SPAM,no es necesario volver a prohibir !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
            fi
        fi
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        firewall_fun
    }
    UnBan_BT() {
        check_BT
        [[ -z ${BT_KEY_WORDS} ]] && echo -e "${Error} Torrent y Palabras Claves no bloqueadas, verifique !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        s="D"
        Set_BT
        View_ALL
        echo -e "${Info} Torrent Desbloqueados y Palabras Claves !"
        msg -bar2
    }
    UnBan_SPAM() {
        check_SPAM
        [[ -z ${SPAM_PORT} ]] && echo -e "${Error} Puerto SPAM no detectados, verifique !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        s="D"
        Set_SPAM
        View_ALL
        echo -e "${Info} Puertos de SPAM Desbloqueados !"
        msg -bar2
    }
    UnBan_ALL() {
        check_BT
        check_SPAM
        s="D"
        if [[ ! -z ${BT_KEY_WORDS} ]]; then
            if [[ ! -z ${SPAM_PORT} ]]; then
                Set_ALL
                View_ALL
                echo -e "${Info} Torrent, Palabras Claves y Puertos SPAM Desbloqueados !"
                msg -bar2
            else
                Set_BT
                View_ALL
                echo -e "${Info} Torrent, Palabras Claves Desbloqueados !"
                msg -bar2
            fi
        else
            if [[ ! -z ${SPAM_PORT} ]]; then
                Set_SPAM
                View_ALL
                echo -e "${Info} Puertos SPAM Desbloqueados !"
                msg -bar2
            else
                echo -e "${Error} No se  detectan Torrent, Palabras Claves y \nPuertos SPAM Bloqueados, verifique !" && msg -bar && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
            fi
        fi
    }
    ENTER_Ban_KEY_WORDS_type() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\e[1;93m              PANEL DE FIREWALL LATAM"
        msg -bar
        Type=$1
        Type_1=$2
        if [[ $Type_1 != "ban_1" ]]; then
            echo -e "Por favor seleccione un tipo de entrada:"
            echo ""
            echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m ENTRADA MANUAL  \e[97m \n"
            echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m LECTURA LOCAL DE ARCHIVOS\e[97m \n"
            echo -ne " \e[1;93m [\e[1;32m3\e[1;93m]\033[1;31m > \033[1;97m LECTURA DESDE DIRECCION DE RED\e[97m \n"
            echo""
            msg -bar
            echo -ne "\e[1;97m(Por defecto: 1. Entrada manual):\033[1;92m " && read key_word_type
        fi
        [[ -z "${key_word_type}" ]] && key_word_type="1"
        if [[ ${key_word_type} == "1" ]]; then
            if [[ $Type == "ban" ]]; then
                ENTER_Ban_KEY_WORDS
            else
                ENTER_UnBan_KEY_WORDS
            fi
        elif [[ ${key_word_type} == "2" ]]; then
            ENTER_Ban_KEY_WORDS_file
        elif [[ ${key_word_type} == "3" ]]; then
            ENTER_Ban_KEY_WORDS_url
        else
            if [[ $Type == "ban" ]]; then
                ENTER_Ban_KEY_WORDS
            else
                ENTER_UnBan_KEY_WORDS
            fi
        fi
    }
    ENTER_Ban_PORT() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\e[1;93m              PANEL DE FIREWALL LATAM"
        msg -bar

        echo -e "\e[1;97mIngrese el puerto que desea Bloquear"
        if [[ ${Ban_PORT_Type_1} != "1" ]]; then
            echo -e "
	${Green_font_prefix}======== Ejemplo Descripción ========${Font_color_suffix}
	
 \e[1;97m-Puerto único: 25 
 -Multipuerto: 25, 26, 465, 587 
 -Segmento de puerto: 25:587 " && echo
        fi
        msg -bar
        echo -ne "\e[1;97m(Preciona Intro y Cancela):\033[1;92m " && read PORT
        [[ -z "${PORT}" ]] && echo "Cancelado..." && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
    }
    ENTER_Ban_KEY_WORDS() {

        if [[ ${Type_1} != "ban_1" ]]; then
            echo ""
            echo -e "          ${Green_font_prefix}======== Ejemplo Descripción ========${Font_color_suffix}
	
 -Palabra : youtube o youtube.com o www.youtube.com
 -Palabra : .zip o .tar " && echo
        fi
        echo -ne "\e[1;97m(Intro se cancela por defecto):\033[1;92m " && read key_word
        [[ -z "${key_word}" ]] && echo "Cancelado ..." && View_ALL && echo -ne "\e[1;97m(Intro se cancela por defecto):\033[1;92m " && read portbg
    }
    ENTER_Ban_KEY_WORDS_file() {
        echo""
        echo -e "\e[1;97mIngrese el archivo local de palabras en root"
        echo -ne "\e[1;97m(Leer key_word.txt o ruta):\033[1;92m " && read key_word
        [[ -z "${key_word}" ]] && key_word="/root/key_word.txt"
        if [[ -e "${key_word}" ]]; then
            key_word=$(cat "${key_word}")
            [[ -z ${key_word} ]] && echo -e "${Error} El contenido del archivo está vacío. !" && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        else
            echo -e "${Error} Archivo no encontrado ${key_word} !" && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        fi
    }
    ENTER_Ban_KEY_WORDS_url() {
        echo ""
        echo -e "\e[1;97mIngrese la dirección del archivo de red de palabras \nclave que se prohibirá / desbloqueará \n(Ejemplo, http: //xxx.xx/key_word.txt)" && echo
        echo -ne "\e[1;97m(Intro se cancela por defecto):\033[1;92m " && read key_word
        [[ -z "${key_word}" ]] && echo "Cancelado ..." && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        key_word=$(wget --no-check-certificate -t3 -T5 -qO- "${key_word}")
        [[ -z ${key_word} ]] && echo -e "${Error} El contenido del archivo de red está vacío o se agotó el tiempo de acceso !" && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
    }
    ENTER_UnBan_KEY_WORDS() {
        View_KEY_WORDS
        echo""
        echo -e "Ingrese la palabra clave que desea desbloquear" && echo
        read -e -p "(Intro se cancela por defecto):" key_word
        [[ -z "${key_word}" ]] && echo "Cancelado ..." && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
    }
    ENTER_UnBan_PORT() {
        msg -bar
        echo -e "Ingrese el puerto que desea desempaquetar:\n"
        echo -ne "\e[1;97m(Intro se cancela por defecto):\033[1;92m " && read PORT
        [[ -z "${PORT}" ]] && echo "Cancelado ..." && View_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
    }
    Ban_PORT() {
        s="A"
        ENTER_Ban_PORT
        Set_PORT
        echo -e "${Info} Puerto bloqueado [ ${PORT} ] !\n"
        Ban_PORT_Type_1="1"
        while true; do
            ENTER_Ban_PORT
            Set_PORT
            echo -e "${Info} Puerto bloqueado [ ${PORT} ] !\n"
        done
        View_ALL
    }
    Ban_KEY_WORDS() {
        s="A"
        ENTER_Ban_KEY_WORDS_type "ban"
        Set_KEY_WORDS
        echo -e "${Info} Palabras clave bloqueadas [ ${key_word} ] !\n"
        while true; do
            ENTER_Ban_KEY_WORDS_type "ban" "ban_1"
            Set_KEY_WORDS
            echo -e "${Info} Palabras clave bloqueadas [ ${key_word} ] !\n"
        done
        View_ALL
    }
    UnBan_PORT() {
        s="D"
        View_PORT
        [[ -z ${Ban_PORT_list} ]] && echo -e "${Error} Se detecta cualquier puerto no bloqueado !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        ENTER_UnBan_PORT
        Set_PORT
        echo -e "${Info} Puerto decapsulado [ ${PORT} ] !\n"
        while true; do
            View_PORT
            [[ -z ${Ban_PORT_list} ]] && echo -e "${Error} No se detecta puertos bloqueados !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
            ENTER_UnBan_PORT
            Set_PORT
            echo -e "${Info} Puerto decapsulado [ ${PORT} ] !\n"
        done
        View_ALL
    }
    UnBan_KEY_WORDS() {
        s="D"
        Cat_KEY_WORDS
        [[ -z ${Ban_KEY_WORDS_list} ]] && echo -e "${Error} No se ha detectado ningún bloqueo !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        ENTER_Ban_KEY_WORDS_type "unban"
        Set_KEY_WORDS
        echo -e "${Info} Palabras clave desbloqueadas [ ${key_word} ] !\n"
        while true; do
            Cat_KEY_WORDS
            [[ -z ${Ban_KEY_WORDS_list} ]] && echo -e "${Error} No se ha detectado ningún bloqueo !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
            ENTER_Ban_KEY_WORDS_type "unban" "ban_1"
            Set_KEY_WORDS
            echo -e "${Info} Palabras clave desbloqueadas [ ${key_word} ] !\n"
        done
        View_ALL
    }
    UnBan_KEY_WORDS_ALL() {
        Cat_KEY_WORDS
        [[ -z ${Ban_KEY_WORDS_text} ]] && echo -e "${Error} No se detectó ninguna clave, verifique !" && msg -bar2 && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        if [[ ! -z "${v6iptables}" ]]; then
            Ban_KEY_WORDS_v6_num=$(echo -e "${Ban_KEY_WORDS_v6_list}" | wc -l)
            for ((integer = 1; integer <= ${Ban_KEY_WORDS_v6_num}; integer++)); do
                ${v6iptables} -t mangle -D OUTPUT 1
            done
        fi
        Ban_KEY_WORDS_num=$(echo -e "${Ban_KEY_WORDS_list}" | wc -l)
        for ((integer = 1; integer <= ${Ban_KEY_WORDS_num}; integer++)); do
            ${v4iptables} -t mangle -D OUTPUT 1
        done
        Save_iptables_v4_v6
        View_ALL
        echo -e "${Info} Todas las palabras clave han sido desbloqueadas !"
    }
    check_iptables() {
        v4iptables=$(iptables -V)
        v6iptables=$(ip6tables -V)
        if [[ ! -z ${v4iptables} ]]; then
            v4iptables="iptables"
            if [[ ! -z ${v6iptables} ]]; then
                v6iptables="ip6tables"
            fi
        else
            echo -e "${Error} El firewall de iptables no está instalado !
Por favor, instale el firewall de iptables: 
CentOS Sistema： yum install iptables -y
Debian / Ubuntu Sistema： apt-get install iptables -y"
        fi
    }
    resetiptables() {
        msg -bar
        echo -e "\e[1;97m           Reiniciando Ipetables Espere"
        iptables -F && iptables -X && iptables -t nat -F && iptables -t nat -X && iptables -t mangle -F && iptables -t mangle -X && iptables -t raw -F && iptables -t raw -X && iptables -t security -F && iptables -t security -X && iptables -P INPUT ACCEPT && iptables -P FORWARD ACCEPT && iptables -P OUTPUT ACCEPT
        echo -e "\e[1;92m       >> IPTABLES reiniciadas con EXITO <<"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        firewall_fun
    }
    check_sys
    check_iptables
    action=$1
    if [[ ! -z $action ]]; then
        [[ $action = "banbt" ]] && Ban_BT && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        [[ $action = "banspam" ]] && Ban_SPAM && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        [[ $action = "banall" ]] && Ban_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        [[ $action = "unbanbt" ]] && UnBan_BT && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        [[ $action = "unbanspam" ]] && UnBan_SPAM && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
        [[ $action = "unbanall" ]] && UnBan_ALL && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && firewall_fun
    fi
    clear
    clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\e[1;93m              PANEL DE FIREWALL LATAM"
    echo -e "\033[38;5;239m═══════════════════\e[48;5;1m\e[38;5;230m  BLOQUEAR  \e[0m\e[38;5;239m═════════════════════"

    echo -e "\e[1;93m  [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m TORRENT Y PALABRAS CLAVE"              #Ban_BT
    echo -e "\e[1;93m  [\e[1;32m2\e[1;93m]\033[1;31m > \e[1;97m PUERTOS SPAM "                         #Ban_SPAM
    echo -e "\e[1;93m  [\e[1;32m3\e[1;93m]\033[1;31m > \e[1;97m TORRENT PALABRAS CLAVE Y PUERTOS SPAM" #Ban_ALL
    echo -e "\e[1;93m  [\e[1;32m4\e[1;93m]\033[1;31m > \e[1;97m PUERTO PERSONALIZADO"                  #Ban_PORT
    echo -e "\e[1;93m  [\e[1;32m5\e[1;93m]\033[1;31m > \e[1;97m PALABRAS CLAVE PERSONALIZADAS"         #Ban_KEY_WORDS
    echo -e "\033[38;5;239m═════════════════\e[48;5;2m\e[38;5;22m  DESBLOQUEAR  \e[0m\e[38;5;239m════════════════════"
    echo -e "\e[1;93m  [\e[1;32m6\e[1;93m]\033[1;31m > \e[1;97m TORRENT Y PALABRAS CLAVE"                #UnBan_BT
    echo -e "\e[1;93m  [\e[1;32m7\e[1;93m]\033[1;31m > \e[1;97m PUERTOS SPAM"                            #UnBan_SPAM
    echo -e "\e[1;93m  [\e[1;32m8\e[1;93m]\033[1;31m > \e[1;97m TORRENT PALABRAS CLAVE Y PUERTOS SPAM"   #UnBan_ALL
    echo -e "\e[1;93m  [\e[1;32m9\e[1;93m]\033[1;31m > \e[1;97m PUERTO PERSONALIZADO"                    #UnBan_PORT
    echo -e "\e[1;93m [\e[1;32m10\e[1;93m]\033[1;31m > \e[1;97m PALABRA CLAVE PERSONALIZADAS"            #UnBan_KEY_WORDS
    echo -e "\e[1;93m [\e[1;32m11\e[1;93m]\033[1;31m > \e[1;97m TODAS LAS PALABRAS CLAVE PERSONALIZADAS" #UnBan_KEY_WORDS_ALL
    echo -e "\e[1;93m [\e[1;32m12\e[1;93m]\033[1;31m > \e[1;92m REINICIAR TOTAS LAS IPTABLES"            #UnBan_KEY_WORDS_ALL
    echo -e "\033[38;5;239m════════════════════════════════════════════════════"
    echo -e "\e[1;93m [\e[1;32m13\e[1;93m]\033[1;31m > \e[1;93m VER LA LISTA ACTUAL DE PROHIBIDOS" #View_ALL
    msg -bar
    echo -e "    \e[97m\033[1;41m ENTER SIN RESPUESTA REGRESA A MENU ANTERIOR \033[0;97m"
    msg -bar
    echo -ne "\033[1;97m   └⊳ Seleccione una opcion [0-18]: \033[1;32m" && read num
    case "$num" in
    1)
        Ban_BT
        ;;
    2)
        Ban_SPAM
        ;;
    3)
        Ban_ALL
        ;;
    4)
        Ban_PORT
        ;;
    5)
        Ban_KEY_WORDS
        ;;
    6)
        UnBan_BT
        ;;
    7)
        UnBan_SPAM
        ;;
    8)
        UnBan_ALL
        ;;
    9)
        UnBan_PORT
        ;;
    10)
        UnBan_KEY_WORDS
        ;;
    11)
        UnBan_KEY_WORDS_ALL
        ;;
    12)
        resetiptables
        ;;
    13)
        View_ALL
        ;;
    *)
        menu
        ;;
    esac
    exit 0

}
