#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


# Función para mostrar puertos activos y asignaciones
mostrarPuertosActivos() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Puertos Activos${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    local portasVAR=$(lsof -i -P -n | grep LISTEN)
    local NOREPEAT=""
    local reQ
    local Port
    echo -e "${AMARILLO}Protocolo\tPuerto\tServicio${NC}" >/tmp/port_details.txt

    while read -r port; do
        reQ=$(echo ${port} | awk '{print $1}')
        Port=$(echo ${port} | awk '{print $9}' | awk -F ":" '{print $2}')
        [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
        NOREPEAT+="$Port\n"

        case ${reQ} in
        squid | squid3)
            [[ -z $SQD ]] && local SQD="\033[1;31m SQUID: \033[1;32m"
            SQD+="$Port "
            ;;
        apache | apache2)
            [[ -z $APC ]] && local APC="\033[1;31m APACHE: \033[1;32m"
            APC+="$Port "
            ;;
        ssh | sshd)
            [[ -z $SSH ]] && local SSH="\033[1;31m SSH: \033[1;32m"
            SSH+="$Port "
            ;;
        dropbear)
            [[ -z $DPB ]] && local DPB="\033[1;31m DROPBEAR: \033[1;32m"
            DPB+="$Port "
            ;;
        ssserver | ss-server)
            [[ -z $SSV ]] && local SSV="\033[1;31m SHADOWSOCKS: \033[1;32m"
            SSV+="$Port "
            ;;
        openvpn)
            [[ -z $OVPN ]] && local OVPN="\033[1;31m OPENVPN-TCP: \033[1;32m"
            OVPN+="$Port "
            ;;
        stunnel4 | stunnel)
            [[ -z $SSL ]] && local SSL="\033[1;31m SSL: \033[1;32m"
            SSL+="$Port "
            ;;
        python | python3)
            [[ -z $PY3 ]] && local PY3="\033[1;31m SOCKS/PYTHON: \033[1;32m"
            PY3+="$Port "
            ;;
        v2ray)
            [[ -z $V2R ]] && local V2R="\033[1;31m V2RAY: \033[1;32m"
            V2R+="$Port "
            ;;
        badvpn-ud)
            [[ -z $BAD ]] && local BAD="\033[1;31m BADVPN: \033[1;32m"
            BAD+="$Port "
            ;;
        esac
    done <<<"${portasVAR}"

    # Mostrar la tabla formateada
    [[ ! -z $SSH ]] && echo -e $SSH >>/tmp/port_details.txt
    [[ ! -z $SSL ]] && echo -e $SSL >>/tmp/port_details.txt
    [[ ! -z $DPB ]] && echo -e $DPB >>/tmp/port_details.txt
    [[ ! -z $SQD ]] && echo -e $SQD >>/tmp/port_details.txt
    [[ ! -z $PY3 ]] && echo -e $PY3 >>/tmp/port_details.txt
    [[ ! -z $SSV ]] && echo -e $SSV >>/tmp/port_details.txt
    [[ ! -z $V2R ]] && echo -e $V2R >>/tmp/port_details.txt
    [[ ! -z $APC ]] && echo -e $APC >>/tmp/port_details.txt
    [[ ! -z $OVPN ]] && echo -e $OVPN >>/tmp/port_details.txt
    [[ ! -z $BAD ]] && echo -e $BAD >>/tmp/port_details.txt

    column -t -s $'\t' /tmp/port_details.txt
    rm /tmp/port_details.txt

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}
