#!/bin/bash

##-->> FUNCION PUERTOS ACTIVOS
mostrarPuertosActivos() {
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\033[1;93m           INFORMACION DE PUERTOS ACTIVOS"
    msg -bar
    local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
    local NOREPEAT
    local reQ
    local Port
    while read port; do
        reQ=$(echo ${port} | awk '{print $1}')
        Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
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
        sshl | sslh)
            [[ -z $SSLH ]] && local SSLH="\033[1;31m SSLH: \033[1;32m"
            SSLH+="$Port "
            ;;
        python | python3)
            [[ -z $PY3 ]] && local PY3="\033[1;31m PYTHON|WEBSOCKET|SSR: \033[1;32m"
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
        psiphond)
            [[ -z $PSI ]] && local PSI="\033[1;31m PSIPHOND: \033[1;32m"
            PSI+="$Port "
            ;;
        esac
    done <<<"${portasVAR}"
    #UDP
    local portasVAR=$(lsof -V -i -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND")
    local NOREPEAT
    local reQ
    local Port
    while read port; do
        reQ=$(echo ${port} | awk '{print $1}')
        Port=$(echo ${port} | awk '{print $9}' | awk -F ":" '{print $2}')
        [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
        NOREPEAT+="$Port\n"
        case ${reQ} in
        openvpn)
            [[ -z $OVPN ]] && local OVPN="\033[0;36m OPENVPN-UDP: \033[1;32m"
            OVPN+="$Port "
            ;;
        udpServer)
            [[ -z $UDPSER ]] && local UDPSER="\033[0;36m UDP-SERVER \033[1;32m"
            UDPSER+="$Port "
            ;;
        esac
    done <<<"${portasVAR}"
    [[ ! -z $SSH ]] && echo -e $SSH
    [[ ! -z $SSL ]] && echo -e $SSL
    [[ ! -z $SSLH ]] && echo -e $SSLH
    [[ ! -z $DPB ]] && echo -e $DPB
    [[ ! -z $SQD ]] && echo -e $SQD
    [[ ! -z $PY3 ]] && echo -e $PY3
    [[ ! -z $SSV ]] && echo -e $SSV
    [[ ! -z $V2R ]] && echo -e $V2R
    [[ ! -z $APC ]] && echo -e $APC
    [[ ! -z $OVPN ]] && echo -e $OVPN
    [[ ! -z $BAD ]] && echo -e $BAD
    [[ ! -z $PSI ]] && echo -e $PSI
    port=$(cat /etc/systemd/system/UDPserver.service 2>/dev/null | grep 'exclude' 2>/dev/null)
    port2=$(echo $port | awk '{print $4}' | cut -d '=' -f2 2>/dev/null | sed 's/,/ /g' 2>/dev/null)
    [[ ! -z $UDPSER ]] && echo -e "$UDPSER<--> $port2 "
    msg -bar
    read -t 120 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    mainMenu
}
