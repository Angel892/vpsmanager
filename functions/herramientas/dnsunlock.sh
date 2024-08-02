#---DNS UNLOCKS
dns_unlock() {

    dnsnetflix() {
        echo "nameserver $dnsp" >/etc/resolv.conf
        #echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        /etc/init.d/ssrmu stop &>/dev/null
        /etc/init.d/ssrmu start &>/dev/null
        /etc/init.d/shadowsocks-r stop &>/dev/null
        /etc/init.d/shadowsocks-r start &>/dev/null
        msg -bar
        echo -e "${VERDE}  DNS AGREGADOS CON EXITO"
    }
    showCabezera "AGREGARDOR DE DNS PERSONALES"

    echo -e "\033[1;97m Esta funcion es para DNS Unlocks's"
    msg -bar
    echo -e "\033[1;39m Solo es para Protolos con Interfas Tun."
    echo -e "\033[1;39m Como: SS,SSR,V2RAY"
    echo -e "\033[1;39m APK: V2RAYNG, SHADOWSHOK , SHADOWSOCKR "
    msg -bar
    echo -e "\033[1;93m Recuerde escojer entre 1 DNS ya sea el de MX,ARG \n segun le aya entregado el BOT."
    echo ""
    echo -e "\033[1;97m Ingrese su DNS a usar: \033[1;92m"
    read -p "   " dnsp
    echo ""
    msg -bar
    read -p " Estas seguro de continuar?  [ s | n ]: " dnsnetflix
    [[ "$dnsnetflix" = "s" || "$dnsnetflix" = "S" ]] && dnsnetflix
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
}
