#!/bin/bash

menuProtocols() {

    local HELPERS_PATH="/etc/vpsmanager/helpers"

    #funciones globales

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
        echo -e "${SECUNDARIO}$num. Apache${NC} $currentStatus"
        option[$num]="apache"
        let num++

        # NGINX
        currentStatus=$(checkStatusF "nginx")
        echo -e "${SECUNDARIO}$num. Nginx${NC} $currentStatus"
        option[$num]="nginx"
        let num++

        # DOTNET
        currentStatus=$(checkStatusF "dotnet")
        echo -e "${SECUNDARIO}$num. Dotnet${NC} $currentStatus"
        option[$num]="dotnet"
        let num++

        # MYSQL
        currentStatus=$(checkStatusF "mysql")
        echo -e "${SECUNDARIO}$num. Mysql${NC} $currentStatus"
        option[$num]="mysql"
        let num++

        # NODE JS
        currentStatus=$(checkStatusF "node")
        echo -e "${SECUNDARIO}$num. Node js${NC} $currentStatus"
        option[$num]="nodejs"
        let num++

        msgCentradoBarra -verd "PROTOCOLOS NET"

        # BADVPN
        currentStatus=$(checkStatus "badvpn")
        echo -e "${SECUNDARIO}$num. BADVPN${NC} $currentStatus"
        option[$num]="badvpn"
        let num++

        # DROPBEAR
        currentStatus=$(checkStatus "dropbear")
        echo -e "${SECUNDARIO}$num. DROPBEAR${NC} $currentStatus"
        option[$num]="dropbear"
        let num++

        # SSL
        currentStatus=$(checkStatus "stunnel4")
        echo -e "${SECUNDARIO}$num. SSL${NC} $currentStatus"
        option[$num]="ssl"
        let num++

        # SQUID
        currentStatus=$(checkStatus "squid")
        echo -e "${SECUNDARIO}$num. SQUID${NC} $currentStatus"
        option[$num]="squid"
        let num++

        # OPENVPN
        currentStatus=$(checkStatus "openvpn")
        echo -e "${SECUNDARIO}$num. OPENVPN${NC} $currentStatus"
        option[$num]="openvpn"
        let num++

        # SHADOWSOCK NORMAL
        currentStatus=$(checkStatus "ssserver")
        echo -e "${SECUNDARIO}$num. SHADOWSOCK NORMAL${NC} $currentStatus"
        option[$num]="shadowSock"
        let num++

        # SHADOWSHOW LIV
        currentStatus=$(checkStatus "ss-server")
        echo -e "${SECUNDARIO}$num. SHADOWSOCK LIV +OBFS${NC} $currentStatus"
        option[$num]="shadowSockLiv"
        let num++

        # SLOWDNS
        currentStatus=$(checkStatus "slowdns")
        echo -e "${SECUNDARIO}$num. SLOWDNS${NC} $currentStatus"
        option[$num]="slowdns"
        let num++

        # GETTUNEL
        currentStatus=$(checkStatus "PGet.py")
        echo -e "${SECUNDARIO}$num. GETTUNEL${NC} $currentStatus"
        option[$num]="gettunel"
        let num++

        # TCP OVER
        currentStatus=$(checkStatus "scktcheck")
        echo -e "${SECUNDARIO}$num. TCP-OVER${NC} $currentStatus"
        option[$num]="tcpover"
        let num++

        # SSLH
        currentStatus=$(checkStatusF "/var/run/sslh/sslh.pid")
        echo -e "${SECUNDARIO}$num. SSLH${NC} $currentStatus"
        option[$num]="sslh"
        let num++

        # UDP REQUEST
        currentStatus=$(checkStatus "/usr/bin/udpServer")
        echo -e "${SECUNDARIO}$num. UDP-REQUEST${NC} $currentStatus"
        option[$num]="udprequest"
        let num++

        # PSIPHON
        currentStatus=$(checkStatus "psiserver")
        echo -e "${SECUNDARIO}$num. SERVIDOR PSIPHONE${NC} $currentStatus"
        option[$num]="psiphone"
        let num++

        msgCentradoBarra -verd "PROXY´S"

        # WEB SOCKET
        currentStatus=$(checkStatus "pydic-*")
        echo -e "${SECUNDARIO}$num. WEBSOKET STATUS EDITABLE${NC} $currentStatus"
        option[$num]="websocket"
        let num++

        # PROXY VPN
        currentStatus=$(checkStatus "POpen.py")
        echo -e "${SECUNDARIO}$num. PROXY OPENVPN${NC} $currentStatus"
        option[$num]="proxyOpenVpn"
        let num++

        # PROXY PUBLICO
        currentStatus=$(checkStatus "PPub.py")
        echo -e "${SECUNDARIO}$num. PROXY PUBLICO${NC} $currentStatus"
        option[$num]="proxyPublico"
        let num++

        # PROXY PRIVADO
        currentStatus=$(checkStatus "PPriv.py")
        echo -e "${SECUNDARIO}$num. PROXY PRIVADO${NC} $currentStatus"
        option[$num]="proxyPrivado"
        let num++

        # VOLVER AL MENU ANTERIOR
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        option[0]="volver"

        msg -bar
        selection=$(selectionFun $num)
        case ${option[$selection]} in
        "apache") menuApache ;;
        "nginx") menuNginx ;;
        "dotnet") menuDotnet ;;
        "mysql") menuMysql ;;
        "nodejs") menuNodeJS ;;
        "badvon") proto_badvpn ;;
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac

    done
}
