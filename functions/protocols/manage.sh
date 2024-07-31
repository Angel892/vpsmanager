#!/bin/bash

menuProtocols() {

    local PROTOCOLS_PATH="/etc/vpsmanager/functions/protocols"

    source $PROTOCOLS_PATH/apache.sh
    source $PROTOCOLS_PATH/nginx.sh
    source $PROTOCOLS_PATH/dotnet.sh
    source $PROTOCOLS_PATH/mysql.sh
    source $PROTOCOLS_PATH/nodejs.sh
    source $PROTOCOLS_PATH/badvpn.sh
    source $PROTOCOLS_PATH/dropbear.sh
    source $PROTOCOLS_PATH/ssl.sh
    source $PROTOCOLS_PATH/squid.sh
    source $PROTOCOLS_PATH/openvpn.sh
    source $PROTOCOLS_PATH/shadowsocksnormal.sh
    source $PROTOCOLS_PATH/shadowsockliv.sh
    source $PROTOCOLS_PATH/slowdns.sh
    source $PROTOCOLS_PATH/gettunnel.sh
    source $PROTOCOLS_PATH/tcpover.sh
    source $PROTOCOLS_PATH/sshl.sh
    source $PROTOCOLS_PATH/udpserver.sh
    source $PROTOCOLS_PATH/psiphone.sh
    source $PROTOCOLS_PATH/pwebsokete.sh
    source $PROTOCOLS_PATH/popenvpn.sh
    source $PROTOCOLS_PATH/ppublico.sh
    source $PROTOCOLS_PATH/pprivado.sh
    source $PROTOCOLS_PATH/python.sh

    local num=1

    clear
    msg -bar
    msgCentrado -amarillo "ADMINISTRADOR DE PROTOCOLOS"
    msg -bar

    # APACHE
    opcionMenu -blanco $num "Apache" true 0 "apache2" "f"
    option[$num]="apache"
    let num++

    # NGINX
    opcionMenu -blanco $num "Nginx" true 0 "nginx" "f"
    option[$num]="nginx"
    let num++

    # DOTNET
    opcionMenu -blanco $num "Dotnet" true 0 "dotnet" "v"
    option[$num]="dotnet"
    let num++

    # MYSQL
    opcionMenu -blanco $num "Mysql" true 0 "mysql" "f"
    option[$num]="mysql"
    let num++

    # NODE JS
    opcionMenu -blanco $num "Node js" true 0 "node" "v"
    option[$num]="nodejs"
    let num++

    # PYTHON
    opcionMenu -blanco $num "Python" true 0 "python3" "f"
    option[$num]="python"
    let num++

    msgCentradoBarra -amarillo "PROTOCOLOS NET"

    # BADVPN
    opcionMenu -blanco $num "BADVPN" true 0 "badvpn"
    option[$num]="badvpn"
    let num++

    # DROPBEAR
    opcionMenu -blanco $num "DROPBEAR" true 0 "dropbear"
    option[$num]="dropbear"
    let num++

    # SSL
    opcionMenu -blanco $num "SSL" true 0 "stunnel4"
    option[$num]="ssl"
    let num++

    # SQUID
    opcionMenu -blanco $num "SQUID" true 0 "squid"
    option[$num]="squid"
    let num++

    # OPENVPN
    opcionMenu -blanco $num "OPENVPN" true 0 "openvpn"
    option[$num]="openvpn"
    let num++

    # SHADOWSOCK NORMAL
    opcionMenu -blanco $num "SHADOWSOCK NORMAL" true 0 "ssserver"
    option[$num]="shadowsocksnormal"
    let num++

    # SHADOWSHOW LIV
    opcionMenu -blanco $num "SHADOWSOCK LIV +OBFS" true 0 "ss-server"
    option[$num]="shadowsockliv"
    let num++

    # SLOWDNS
    opcionMenu -blanco $num "SLOWDNS" true 0 "slowdns"
    option[$num]="slowdns"
    let num++

    # GETTUNEL
    opcionMenu -blanco $num "GETTUNEL" true 0 "PGet.py"
    option[$num]="gettunnel"
    let num++

    # TCP OVER
    opcionMenu -blanco $num "TCP-OVER" true 0 "scktcheck"
    option[$num]="tcpover"
    let num++

    # SSLH
    opcionMenu -blanco $num "SSLH" true 0 "/var/run/sslh/sslh.pid" "f"
    option[$num]="sslh"
    let num++

    # UDP REQUEST
    opcionMenu -blanco $num "UDP-REQUEST" true 0 "/usr/bin/udpServer"
    option[$num]="udpserver"
    let num++

    # PSIPHON
    opcionMenu -blanco $num "SERVIDOR PSIPHONE" true 0 "psiserver"
    option[$num]="psiphone"
    let num++

    msgCentradoBarra -amarillo "PROXY´S"

    # WEB SOCKET
    opcionMenu -blanco $num "WEBSOKET STATUS EDITABLE" true 0 "pydic-*"
    option[$num]="websockete"
    let num++

    # PROXY VPN
    opcionMenu -blanco $num "PROXY OPENVPN" true 0 "POpen.py"
    option[$num]="popenvpn"
    let num++

    # PROXY PUBLICO
    opcionMenu -blanco $num "PROXY PUBLICO" true 0 "PPub.py"
    option[$num]="ppublico"
    let num++

    # PROXY PRIVADO
    opcionMenu -blanco $num "PROXY PRIVADO" true 0 "PPriv.py"
    option[$num]="pprivado"
    let num++

    msg -bar

    # VOLVER AL MENU ANTERIOR
    opcionMenu -rojo 0 "Regresar al menu anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "apache") menuApache ;;
    "nginx") menuNginx ;;
    "dotnet") menuDotnet ;;
    "mysql") menuMysql ;;
    "nodejs") menuNodeJS ;;
    "badvpn") proto_badvpn ;;
    "dropbear") proto_dropbear ;;
    "ssl") proto_ssl ;;
    "squid") proto_squid ;;
    "openvpn") proto_openvpn ;;
    "shadowsocksnormal") proto_shadowsockN ;;
    "shadowsockliv") proto_shadowsockL ;;
    "slowdns") proto_slowndns ;;
    "gettunnel") proto_pgettunel ;;
    "tcpover") proto_ptcpover ;;
    "sslh") sshl_install ;;
    "udpserver") udp_serverr ;;
    "psiphone") server_psiphones ;;
    "websockete") proto_websockete ;;
    "popenvpn") proto_popenvpn ;;
    "ppublico") proto_ppublico ;;
    "pprivado") proto_pprivado ;;
    "python") menuPython ;;
    "volver") mainMenu ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        menuProtocols
        ;;
    esac

}
