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

# Función para verificar el estado de Nginx
estado_nginx() {
    if systemctl is-active --quiet nginx; then
        mostrarActivo
    else
        mostrarInActivo
    fi
}

menuProtocols() {

    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Administrar Protocolos${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${SECUNDARIO}1. Apache${NC} $(estado_apache)"
        echo -e "${SECUNDARIO}2. Nginx${NC} $(estado_nginx)"
        echo -e "${SECUNDARIO}3. Dotnet${NC} "
        echo -e "${SECUNDARIO}4. Mysql${NC}"
        echo -e "${SECUNDARIO}5. Node js${NC}"

        echo "";
        echo "${ROJO}-------------------------${NC}"
        echo ""

        echo -e "${SECUNDARIO}6. BADVPN${NC} $(estado_apache)"
        echo -e "${SECUNDARIO}7. DROPBEAR${NC} $(estado_nginx)"
        echo -e "${SECUNDARIO}8. SSL${NC} "
        echo -e "${SECUNDARIO}9. SQUID${NC}"
        echo -e "${SECUNDARIO}10. OPENVPN${NC}"
        echo -e "${SECUNDARIO}10. SHADOWSOCK NORMAL${NC}"
        echo -e "${SECUNDARIO}10. SHADOWSOCK LIV +OBFS${NC}"
        echo -e "${SECUNDARIO}10. SLOWDNS${NC}"
        echo -e "${SECUNDARIO}10. GETTUNEL${NC}"
        echo -e "${SECUNDARIO}10. TCP-OVER${NC}"
        echo -e "${SECUNDARIO}10. SSLH${NC}"
        echo -e "${SECUNDARIO}10. UDP-REQUEST${NC}"
        echo -e "${SECUNDARIO}10. SERVIDOR PSIPHONE${NC}"

        echo "";
        echo "${ROJO}--------PROXY´S--------${NC}"
        echo ""

        echo -e "${SECUNDARIO}10. WEBSOKET STATUS EDITABLE${NC}"
        echo -e "${SECUNDARIO}10. PROXY OPENVPN${NC}"
        echo -e "${SECUNDARIO}10. PROXY PUBLICO${NC}"
        echo -e "${SECUNDARIO}10. PROXY PRIVADO${NC}"

        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) menuApache ;;
        2) menuNginx ;;
        3) menuDotnet ;;
        4) menuMysql ;;
        5) menuNodeJS ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac

    done
}
