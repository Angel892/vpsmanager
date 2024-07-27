#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


# Función para verificar los puertos
mportas() {
    unset portas
    portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
    while read port; do
        var1=$(echo $port | awk '{print $1}')
        var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
        [[ "$(echo -e $portas | grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
    done <<<"$portas_var"
    i=1
    echo -e "$portas"
}

# Función para activar BadVPN
activar_badvpn() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Instalador de BadVPN (UDP)${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${INFO}Digite los puertos a activar de forma secuencial${NC}"
    echo -e "${INFO}Ejemplo: 7300 7200 7100 | Puerto recomendado: 7300${NC}"
    read -p "Digite los puertos: " -e -i "7200 7300" portasx
    echo "$portasx" >/etc/vpsmanager/PortM/Badvpn.log
    echo -e "${PRINCIPAL}=========================${NC}"
    totalporta=($portasx)
    unset PORT
    for ((i = 0; i < ${#totalporta[@]}; i++)); do
        [[ $(mportas | grep "${totalporta[$i]}") = "" ]] && {
            echo -e "${SECUNDARIO}Puerto escogido: ${VERDE}${totalporta[$i]} OK${NC}"
            PORT+="${totalporta[$i]}\n"
            screen -dmS badvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:${totalporta[$i]} --max-clients 1000 --max-connections-for-client 10
        } || {
            echo -e "${SECUNDARIO}Puerto escogido: ${ROJO}${totalporta[$i]} FAIL${NC}"
        }
    done
    [[ -z $PORT ]] && {
        echo -e "${ROJO}No se ha elegido ninguna puerto valido, reintente${NC}"
        return 1
    }

    echo -e "${PRINCIPAL}=========================${NC}"
    [[ "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && echo -e "${VERDE}        >> BADVPN INSTALADO CON ÉXITO <<${NC}" || echo -e "${ROJO}               ERROR VERIFIQUE${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}

# Función para desactivar BadVPN
desactivar_badvpn() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Desinstalando puertos BadVPN${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    kill -9 $(ps x | grep badvpn | grep -v grep | awk '{print $1'}) >/dev/null 2>&1
    killall badvpn-udpgw >/dev/null 2>&1
    screen -wipe >/dev/null 2>&1
    rm -rf /etc/vpsmanager/PortM/Badvpn.log >/dev/null 2>&1
    [[ ! "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && echo -e "${VERDE}        >> BADVPN DESINSTALADO CON ÉXITO <<${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}

# Función principal para manejar BadVPN
proto_badvpn() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Instalador de BadVPN (UDP)${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    if [[ ! -e /bin/badvpn-udpgw ]]; then
        wget -O /bin/badvpn-udpgw https://github.com/Angel892/vpsmanager/raw/master/LINKS_LIBRERIAS/badvpn-udpgw &>/dev/null
        chmod 777 /bin/badvpn-udpgw
    fi
    echo -e "${SECUNDARIO}1. Instalar un BadVPN${NC}"
    echo -e "${SECUNDARIO}2. Detener todos los BadVPN${NC}"
    echo -e "${SALIR}0. Volver${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Digite solo el número según su respuesta: " opcao
    case $opcao in
    1)
        echo -e "${PRINCIPAL}=========================${NC}"
        activar_badvpn
        ;;
    2)
        echo -e "${PRINCIPAL}=========================${NC}"
        desactivar_badvpn
        ;;
    0)
        menu
        ;;
    *)
        echo -e "${ROJO}Por favor use números del [0-2]${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        menu
        ;;
    esac
}
