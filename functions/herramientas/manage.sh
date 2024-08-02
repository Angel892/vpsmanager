#!/bin/bash

HERRAMIENTAS_PATH="$functionsPath/herramientas"

#ARCHIVOS NECESARIOS
source $HERRAMIENTAS_PATH/fixbaseuser.sh

#---FUNCION HERRAMIENTAS
#herramientas_fun() {
#    clear && clear
#    tput cuu1 && tput dl1
#    msg -bar2
#    msg -tit
#    msg -bar2
#    msg -ama "                MENU DE HERRAMIENTAS"
#    msg -bar2
#    var_sks1=$(ps x | grep "checkuser" | grep -v grep >/dev/null && echo -e "\033[1;32m ON BASICO" || echo -e "\033[1;31mOFF BASICO")
#    var_sks2=$(ps x | grep "4gcheck" | grep -v grep >/dev/null && echo -e "\033[1;32mON PLUS" || echo -e "\033[1;31mOFF PLUS ")
#    chonlines=$(netstat -tln | grep -q :8888 >/dev/null && echo -e "\033[1;32m ON " || echo -e "\033[1;31mOFF")
#
#    local Numb=1
#    echo -e "\033[1;93m--------------------- EXTRAS -----------------------"


#    echo -e "\033[1;93m-------------------- SEGURIDAD ---------------------"

#    echo -e "\033[1;93m------------------ AJUSTES DEL VPS -----------------"
#    echo -ne " \e[1;93m[\e[1;32m$Numb\e[1;93m]\033[1;31m >\033[1;97m AJUSTES INTERNOS      "
#    script[$Numb]="ajustein"
#    let Numb++
#    echo -e "\e[1;93m[\e[1;32m$Numb\e[1;93m]\033[1;31m >\033[1;97m HORARIO LOCAL      "
#    script[$Numb]="horalocal"
#    let Numb++
#    echo -ne " \e[1;93m[\e[1;32m$Numb\e[1;93m]\033[1;31m >\033[1;97m AGREGAR DNS UNLOCK'S  "
#    script[$Numb]="dnsunlock"
#    let Numb++
#    echo -e "\e[1;93m[\e[1;32m$Numb\e[1;93m]\033[1;31m >\033[1;97m SPEED TEST VPS      "
#    script[$Numb]="speed"
#    echo -e "\033[1;93m----------------------------------------------------"
#    let Numb++
#    echo -e " \e[1;93m[\e[1;32m$Numb\e[1;93m]\033[1;31m >\033[1;96m  - - - >> DETALLES DE SISTEMA << - - - - - "
#    script[$Numb]="systeminf"
#    msg -bar
#    echo -e "    \e[97m\033[1;41m ENTER SIN RESPUESTA REGRESA A MENU ANTERIOR \033[0;97m"
#    script[0]="voltar"
#    msg -bar2
#    selection=$(selection_fun $Numb)
#    [[ -e "${SCPfrm}/${script[$selection]}" ]] && {
#        ${SCPfrm}/${script[$selection]}
#    } || {
#        case ${script[$selection]} in
#        "speed") speed_test ;;
#        "limpar") limpar_caches ;;
#        "systeminf") systen_info ;;
#        "horalocal") hora_local ;;
#        "ajustein") ajuste_in ;;
#        "dnsunlock") dns_unlock ;;
#        "bbr") bbr_fun ;;
#        "passsquid") pass_squid ;;
#        "fai2ban") fai2ban_fun ;;
#        "ftpapache") ftp_apache ;;
#        "notibot") noti_bot ;;
#        "tokengeneral") token_ge ;;
#        "fixbaseuser") recuperar_base ;;
#        "chekcusers") chekc_users ;;
#        "checkonlines") chekc_online ;;
#        *) menu ;;
#        esac
#    }
#    exit 0
#}

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

    msgCentradoBarra "EXTRAS"

    # HABILITAR STREAMING (NETFLIX, DISNEY+, MAX, ETC)
    opcionMenu -blanco $num "HABILITAR STREAMING (NETFLIX, DISNEY+, MAX, ETC)"
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
    "ajustein") intallv2ray ;;
    "streaming") intallv2ray ;;
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
