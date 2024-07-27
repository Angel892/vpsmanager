#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

PROTOCOLS_PATH="/etc/vpsmanager/functions/protocols"

source $PROTOCOLS_PATH/apache.sh
source $PROTOCOLS_PATH/nginx.sh
source $PROTOCOLS_PATH/dotnet.sh
source $PROTOCOLS_PATH/mysql.sh
source $PROTOCOLS_PATH/nodejs.sh

# Función para verificar el estado de Apache
estado_apache() {
    if systemctl is-active --quiet apache2; then
        mostrarActivo
    else
        mostrarInActivo
    fi
}


menuProtocols() {

    while true; do
        local num=1

        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Administrar Protocolos${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"

        # APACHE
        echo -e "${SECUNDARIO}$num. Apache${NC} $(estado_apache)"
        option[$num]="apache"
        let num++

        # NGINX
        nginxStatus=$(checkStatus "nginx")
        echo -e "${SECUNDARIO}$num. Nginx${NC} $nginxStatus"
        option[$num]="nginx"
        let num++

        # DOTNET
        echo -e "${SECUNDARIO}$num. Dotnet${NC}"
        option[$num]="dotnet"
        let num++

        # MYSQL
        echo -e "${SECUNDARIO}$num. Mysql${NC}"
        option[$num]="mysql"
        let num++

        # NODE JS
        echo -e "${SECUNDARIO}$num. Node js${NC}"
        option[$num]="nodejs"
        let num++

        echo ""
        echo -e "${ROJO}-------------------------${NC}"
        echo ""

        # BADVPN
        badvpnStatus=$(checkStatus "badvpn")
        echo -e "${SECUNDARIO}$num. BADVPN${NC} $badvpnStatus"
        option[$num]="badvpn"
        let num++

        # DROPBEAR
        echo -e "${SECUNDARIO}$num. DROPBEAR${NC} $(estado_nginx)"
        option[$num]="dropbear"
        let num++

        # SSL
        echo -e "${SECUNDARIO}$num. SSL${NC}"
        option[$num]="ssl"
        let num++

        # SQUID
        echo -e "${SECUNDARIO}$num. SQUID${NC}"
        option[$num]="squid"
        let num++

        # OPENVPN
        echo -e "${SECUNDARIO}$num. OPENVPN${NC}"
        option[$num]="openvpn"
        let num++

        # SHADOWSOCK NORMAL
        echo -e "${SECUNDARIO}$num. SHADOWSOCK NORMAL${NC}"
        option[$num]="shadowSock"
        let num++

        # SHADOWSHOW LIV
        echo -e "${SECUNDARIO}$num. SHADOWSOCK LIV +OBFS${NC}"
        option[$num]="shadowSockLiv"
        let num++

        # SLOWDNS
        echo -e "${SECUNDARIO}$num. SLOWDNS${NC}"
        option[$num]="slowdns"
        let num++

        # GETTUNEL
        echo -e "${SECUNDARIO}$num. GETTUNEL${NC}"
        option[$num]="gettunel"
        let num++

        # TCP OVER
        echo -e "${SECUNDARIO}$num. TCP-OVER${NC}"
        option[$num]="tcpover"
        let num++

        # SSLH
        echo -e "${SECUNDARIO}$num. SSLH${NC}"
        option[$num]="sslh"
        let num++

        # UDP REQUEST
        echo -e "${SECUNDARIO}$num. UDP-REQUEST${NC}"
        option[$num]="udprequest"
        let num++

        # PSIPHONR
        echo -e "${SECUNDARIO}$num. SERVIDOR PSIPHONE${NC}"
        option[$num]="psiphone"
        let num++

        echo ""
        echo -e "${ROJO}--------PROXY´S--------${NC}"
        echo ""

        # WEB SOCKET
        echo -e "${SECUNDARIO}$num. WEBSOKET STATUS EDITABLE${NC}"
        option[$num]="websocket"
        let num++

        # PROXY VPN
        echo -e "${SECUNDARIO}$num. PROXY OPENVPN${NC}"
        option[$num]="proxyOpenVpn"
        let num++

        # PROXY PUBLICO
        echo -e "${SECUNDARIO}$num. PROXY PUBLICO${NC}"
        option[$num]="proxyPublico"
        let num++

        # PROXY PRIVADO
        echo -e "${SECUNDARIO}$num. PROXY PRIVADO${NC}"
        option[$num]="proxyPrivado"
        let num++

        # VOLVER AL MENU ANTERIOR
        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        option[0]="volver"

        echo -e "${PRINCIPAL}=========================${NC}"
        selection=$(selectionFun $num)
        case ${option[$selection]} in
        "apache") menuApache ;;
        "nginx") menuNginx ;;
        "dotnet") menuDotnet ;;
        "mysql") menuMysql ;;
        "nodejs") menuNodeJS ;;
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac

    done
}
