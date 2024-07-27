#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

mostrarActivo() {
    echo -e "${VERDE}[ ON ]${NC}"
}

mostrarInActivo() {
    echo -e "${ROJO}[ OFF ]${NC}"
}

checkStatus() {
    toCheck=$(ps x | grep "$1" | grep -v "grep" | awk -F "pts" '{print $1}')
    [[ -z ${toCheck} ]] && mostrarInActivo || mostrarActivo
}

checkStatusF() {
    toCheck=$(ps -ef | grep "$1" | grep -v "grep" | awk -F "pts" '{print $1}')
    [[ -z ${toCheck} ]] && mostrarInActivo || mostrarActivo
}

#--- MENU DE SELECCION
selectionFun() {
    local selection
    local options="$(seq 0 $1 | paste -sd "," -)"
    read -p $'\033[1;97m  └⊳ Seleccione una opción:\033[1;32m ' selection
    if [[ $options =~ (^|[^\d])$selection($|[^\d]) ]]; then
        echo $selection
    else
        echo "Selección no válida: $selection" >&2
        exit 1
    fi
}

msg() { ##-->> COLORES, TITULO, BARRAS
    ##-->> COLORES
    COLOR[0]='\033[1;37m' #GRIS='\033[1;37m'
    COLOR[1]='\e[31m'     #ROJO='\e[31m'
    COLOR[2]='\e[32m'     #VERDE='\e[32m'
    COLOR[3]='\e[33m'     #AMARILLO='\e[33m'
    COLOR[4]='\e[34m'     #AZUL='\e[34m'
    COLOR[5]='\e[91m'     #ROJO-NEON='\e[91m'
    COLOR[6]='\033[1;97m' #BALNCO='\033[1;97m'
    NEGRITO='\e[1m'
    SINCOLOR='\e[0m'
    case $1 in
    -ne) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -ama) cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm2) cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -azu) cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -bra) cor="${COLOR[0]}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    "-bar2" | "-bar") cor="${COLOR[1]}════════════════════════════════════════════════════" && echo -e "${SINCOLOR}${cor}${SINCOLOR}" ;;
    # Centrar texto
    -tit) echo -e " \e[48;5;214m\e[38;5;0m   💻 S C R I P T | L X M A N A G E R 💻 " ;;
    esac
}

msgCentrado() {
    barra="════════════════════════════════════════════════════";
    texto="$2"
    texto_len=${#texto}
    barra_len=${#barra}
    espacios=$(( (barra_len - texto_len) / 2 ))
    ##-->> COLORES
    COLOR[0]='\033[1;37m' #GRIS='\033[1;37m'
    COLOR[1]='\e[31m'     #ROJO='\e[31m'
    COLOR[2]='\e[32m'     #VERDE='\e[32m'
    COLOR[3]='\e[33m'     #AMARILLO='\e[33m'
    COLOR[4]='\e[34m'     #AZUL='\e[34m'
    COLOR[5]='\e[91m'     #ROJO-NEON='\e[91m'
    COLOR[6]='\033[1;97m' #BALNCO='\033[1;97m'
    NEGRITO='\e[1m'
    SINCOLOR='\e[0m'

    printf "%${espacios}s" "" # Add spaces to center the text

    case $1 in
    -ne) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -ama) cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm2) cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -azu) cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -bra) cor="${COLOR[0]}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    esac
}
