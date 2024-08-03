#!/bin/bash

menuFirewall() {
    showCabezera "PANEL DE FIREWALL LATAM"
    msgCentradoBarra -amarillo "BLOQUEAR"

    local num=1
    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "TORRENT Y PALABRAS CLAVE"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "PUERTOS SPAM"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "TORRENT PALABRAS CLAVE Y PUERTOS SPAM"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "PUERTO PERSONALIZADO"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "PALABRAS CLAVE PERSONALIZADAS"
    option[$num]="instalar"
    let num++

    msgCentradoBarra -amarillo "DESBLOQUEAR"

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "TORRENT Y PALABRAS CLAVE"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "PUERTOS SPAM"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "TORRENT PALABRAS CLAVE Y PUERTOS SPAM"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "PUERTO PERSONALIZADO"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "PALABRAS CLAVE PERSONALIZADAS"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "TODAS LAS PALABRAS CLAVE PERSONALIZADAS"
    option[$num]="instalar"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "REINICIAR TOTAS LAS IPTABLES"
    option[$num]="instalar"
    let num++

    msg -bar

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "VER LA LISTA ACTUAL DE PROHIBIDOS"
    option[$num]="instalar"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar

    selection=$(selectionFun $num)
    case ${option[$selection]} in
    1)
        Ban_BT
        ;;
    2)
        Ban_SPAM
        ;;
    3)
        Ban_ALL
        ;;
    4)
        Ban_PORT
        ;;
    5)
        Ban_KEY_WORDS
        ;;
    6)
        UnBan_BT
        ;;
    7)
        UnBan_SPAM
        ;;
    8)
        UnBan_ALL
        ;;
    9)
        UnBan_PORT
        ;;
    10)
        UnBan_KEY_WORDS
        ;;
    11)
        UnBan_KEY_WORDS_ALL
        ;;
    12)
        resetiptables
        ;;
    13)
        View_ALL
        ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;
    esac

    menuFirewall

}
