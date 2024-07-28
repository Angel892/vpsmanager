#!/bin/bash

menuProtocols() {

    local PROTOCOLS_PATH="/etc/vpsmanager/functions/protocols"

    source $PROTOCOLS_PATH/apache.sh
    source $PROTOCOLS_PATH/nginx.sh
    source $PROTOCOLS_PATH/dotnet.sh
    source $PROTOCOLS_PATH/mysql.sh
    source $PROTOCOLS_PATH/nodejs.sh
    source $PROTOCOLS_PATH/badvpn.sh

    while true; do
        local num=1

        clear
        msg -bar
        msgCentrado -verd "ADMINISTRADOR DE PROTOCOLOS"
        msg -bar

        # APACHE
        currentStatus=$(checkStatusF "apache2")
        opcionMenu -blanco $num "Apache" true 0 "apache2" "f"
        option[$num]="apache"
        let num++

        # NGINX
        currentStatus=$(checkStatusF "nginx")
        opcionMenu -blanco $num "Nginx $currentStatus"
        option[$num]="nginx"
        let num++

        # DOTNET
        currentStatus=$(checkStatusF "dotnet")
        opcionMenu -blanco $num "Dotnet $currentStatus"
        option[$num]="dotnet"
        let num++

        # MYSQL
        currentStatus=$(checkStatusF "mysql")
        opcionMenu -blanco $num "Mysql $currentStatus"
        option[$num]="mysql"
        let num++

        # NODE JS
        currentStatus=$(checkStatusF "node")
        opcionMenu -blanco $num "Node js $currentStatus"
        option[$num]="nodejs"
        let num++

        msgCentradoBarra -verd "PROTOCOLOS NET"

        # BADVPN
        currentStatus=$(checkStatus "badvpn")
        opcionMenu -blanco $num "BADVPN $currentStatus"
        option[$num]="badvpn"
        let num++

        # DROPBEAR
        currentStatus=$(checkStatus "dropbear")
        opcionMenu -blanco $num "DROPBEAR $currentStatus"
        option[$num]="dropbear"
        let num++

        # SSL
        currentStatus=$(checkStatus "stunnel4")
        opcionMenu -blanco $num "SSL $currentStatus"
        option[$num]="ssl"
        let num++

        # SQUID
        currentStatus=$(checkStatus "squid")
        opcionMenu -blanco $num "SQUID $currentStatus"
        option[$num]="squid"
        let num++

        # OPENVPN
        currentStatus=$(checkStatus "openvpn")
        opcionMenu -blanco $num "OPENVPN $currentStatus"
        option[$num]="openvpn"
        let num++

        # SHADOWSOCK NORMAL
        currentStatus=$(checkStatus "ssserver")
        opcionMenu -blanco $num "SHADOWSOCK NORMAL $currentStatus"
        option[$num]="shadowSock"
        let num++

        # SHADOWSHOW LIV
        currentStatus=$(checkStatus "ss-server")
        opcionMenu -blanco $num "SHADOWSOCK LIV +OBFS $currentStatus"
        option[$num]="shadowSockLiv"
        let num++

        # SLOWDNS
        currentStatus=$(checkStatus "slowdns")
        opcionMenu -blanco $num "SLOWDNS $currentStatus"
        option[$num]="slowdns"
        let num++

        # GETTUNEL
        currentStatus=$(checkStatus "PGet.py")
        opcionMenu -blanco $num "GETTUNEL $currentStatus"
        option[$num]="gettunel"
        let num++

        # TCP OVER
        currentStatus=$(checkStatus "scktcheck")
        opcionMenu -blanco $num "TCP-OVER $currentStatus"
        option[$num]="tcpover"
        let num++

        # SSLH
        currentStatus=$(checkStatusF "/var/run/sslh/sslh.pid")
        opcionMenu -blanco $num "SSLH $currentStatus"
        option[$num]="sslh"
        let num++

        # UDP REQUEST
        currentStatus=$(checkStatus "/usr/bin/udpServer")
        opcionMenu -blanco $num "UDP-REQUEST $currentStatus"
        option[$num]="udprequest"
        let num++

        # PSIPHON
        currentStatus=$(checkStatus "psiserver")
        opcionMenu -blanco $num "SERVIDOR PSIPHONE $currentStatus"
        option[$num]="psiphone"
        let num++

        msgCentradoBarra -verd "PROXY´S"

        # WEB SOCKET
        currentStatus=$(checkStatus "pydic-*")
        opcionMenu -blanco $num "WEBSOKET STATUS EDITABLE $currentStatus"
        option[$num]="websocket"
        let num++

        # PROXY VPN
        currentStatus=$(checkStatus "POpen.py")
        opcionMenu -blanco $num "PROXY OPENVPN $currentStatus"
        option[$num]="proxyOpenVpn"
        let num++

        # PROXY PUBLICO
        currentStatus=$(checkStatus "PPub.py")
        opcionMenu -blanco $num "PROXY PUBLICO $currentStatus"
        option[$num]="proxyPublico"
        let num++

        # PROXY PRIVADO
        currentStatus=$(checkStatus "PPriv.py")
        opcionMenu -blanco $num "PROXY PRIVADO $currentStatus"
        option[$num]="proxyPrivado"
        let num++

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
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done

}
