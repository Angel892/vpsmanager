#!/bin/bash

HERRAMIENTAS_PATH="$functionsPath/herramientas"

#ARCHIVOS NECESARIOS
source $HERRAMIENTAS_PATH/ajustesInternos.sh
source $HERRAMIENTAS_PATH/bbr.sh
source $HERRAMIENTAS_PATH/dnsunlock.sh
source $HERRAMIENTAS_PATH/failban.sh
source $HERRAMIENTAS_PATH/fixbaseuser.sh
source $HERRAMIENTAS_PATH/ftpapache.sh
source $HERRAMIENTAS_PATH/horalocal.sh
source $HERRAMIENTAS_PATH/passquid.sh
source $HERRAMIENTAS_PATH/speed.sh

menuSettings() {

    showCabezera "MENU DE HERRAMIENTAS"

    local num=1

    # FIX BASE DE USER
    opcionMenu -blanco $num "FIX BASE DE USER"
    option[$num]="streaming"
    let num++

    # FTP X APACHE
    opcionMenu -blanco $num "FTP X APACHE"
    option[$num]="ftpapache"
    let num++

    # BBR/PLUS
    opcionMenu -blanco $num "ACTIVAR (BBR/PLUS)"
    option[$num]="bbr"
    let num++

    msgCentradoBarra "SEGURIDAD"

    # FAIL2BAN
    opcionMenu -blanco $num "FAIL2BAN PROTECION"
    option[$num]="bbr"
    let num++

    # FAIL2BAN
    opcionMenu -blanco $num "PASS PROXY SQUID"
    option[$num]="passquid"
    let num++

    msgCentradoBarra "AJUSTES DEL VPS"

    # AJUSTES INTERNOS
    opcionMenu -blanco $num "AJUSTES INTERNOS"
    option[$num]="passquid"
    let num++

    # DNS UNLOCK'S
    opcionMenu -blanco $num "AGREGAR DNS UNLOCK'S"
    option[$num]="dnsunlock"
    let num++

    # SPEED
    opcionMenu -blanco $num "SPEED TEST VPSss"
    option[$num]="speed"
    let num++

    msgCentradoBarra "EXTRAS"

    # HABILITAR STREAMING (NETFLIX, DISNEY+, MAX, ETC)
    opcionMenu -blanco $num "HABILITAR STREAMING (NETFLIX, DISNEY+, MAX, ETC)"
    option[$num]="streaming"
    let num++

    # HORA LOCAL
    opcionMenu -blanco $num "HORARIO LOCAL"
    option[$num]="streaming"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "streaming") intallv2ray ;;
    "fixbaseuser") recuperar_base ;;
    "ftpapache") ftp_apache ;;
    "bbr") bbr_fun ;;
    "fai2ban") fai2ban_fun ;;
    "passquid") pass_squid ;;
    "ajustein") ajuste_in ;;
    "horalocal") hora_local ;;
    "dnsunlock") dns_unlock ;;
    "speed") speed_test ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuSettings
}
