#!/bin/bash

# Función principal para manejar BadVPN
proto_badvpn() {

    # Función para activar BadVPN
    install() {
        showCabezera "Instalador de BadVPN (UDP)"

        msg -blanco "Digite los puertos a activar de forma secuencial"
        msg -verde "Ejemplo: 7300 7200 7100 | Puerto recomendado: 7300"
        read -p "Digite los puertos: " -e -i "7200 7300" portasx
        local BADVPNLOGPATH="/etc/vpsmanager/PortM/Badvpn.log"
        validarArchivo $BADVPNLOGPATH
        echo "$portasx" >$BADVPNLOGPATH
        msg -bar
        totalporta=($portasx)
        unset PORT
        for ((i = 0; i < ${#totalporta[@]}; i++)); do
            [[ $(mportas | grep "${totalporta[$i]}") = "" ]] && {
                echo -e "${BLANCO}Puerto escogido: ${VERDE}${totalporta[$i]} OK${NC}"
                PORT+="${totalporta[$i]}\n"
                screen -dmS badvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:${totalporta[$i]} --max-clients 1000 --max-connections-for-client 10
            } || {
                echo -e "${BLANCO}Puerto escogido: ${ROJO}${totalporta[$i]} FAIL${NC}"
            }
        done
        [[ -z $PORT ]] && {
            msgError "No se ha elegido ninguna puerto valido, reintente"
            return 1
        }

        msg -bar
        [[ "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && msgSuccess || msgError
    }

    # Función para desactivar BadVPN
    uninstall() {
        showCabezera "Desinstalando puertos BadVPN"
        kill -9 $(ps x | grep badvpn | grep -v grep | awk '{print $1'}) >/dev/null 2>&1
        killall badvpn-udpgw >/dev/null 2>&1
        screen -wipe >/dev/null 2>&1
        rm -rf /etc/vpsmanager/PortM/Badvpn.log >/dev/null 2>&1
        [[ ! "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && msgSuccess || msgError

    }

    showCabezera "Instalador de BadVPN (UDP)"

    if [[ ! -e /bin/badvpn-udpgw ]]; then
        wget -O /bin/badvpn-udpgw https://github.com/Angel892/vpsmanager/raw/master/LINKS_LIBRERIAS/badvpn-udpgw &>/dev/null
        chmod 777 /bin/badvpn-udpgw
    fi

    local num=1

    # INSTALAR
    opcionMenu -blanco $num "Instalar badvpn"
    option[$num]="install"
    let num++

    # DESINSTALAR
    opcionMenu -blanco $num "Desinstalar badvpn"
    option[$num]="uninstall"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "install") install ;;
    "uninstall") uninstall ;;
    "volver") menuProtocols ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    proto_badvpn
}
