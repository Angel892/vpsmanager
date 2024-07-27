#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

# COLORES
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
    
    while true; do
        # Mostrar el prompt de selección
        read -p $'\033[1;97m  └⊳ Seleccione una opción:\033[1;32m ' selection
        
        # Verificar si la entrada está en las opciones permitidas
        if [[ $options =~ (^|[^\d])$selection($|[^\d]) ]]; then
            echo $selection
            return 0
        else
            # Mover el cursor una línea hacia arriba y limpiar la línea
            tput cuu1 && tput el
            echo -e "\033[1;31mPor favor, ingrese una opción válida.\033[0m"

            sleep 1

            # Mover el cursor una línea hacia arriba y limpiar la línea de nuevo para evitar duplicados
            tput cuu1 && tput el
        fi
    done
}

msg() { ##-->> COLORES, TITULO, BARRAS

    case $1 in
    -ne) cor="${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -ama) cor="${AMARILLO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${AMARILLO}${NEGRITO}[!] ${ROJO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm2) cor="${ROJO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -azu) cor="${BLANCO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verd) cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -bra) cor="${GRIS}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    "-bar2" | "-bar") cor="${ROJO}════════════════════════════════════════════════════" && echo -e "${SINCOLOR}${cor}${SINCOLOR}" ;;
    # Centrar texto
    -tit) echo -e " \e[48;5;214m\e[38;5;0m   💻 S C R I P T | L X M A N A G E R 💻 " ;;
    esac
}

msgCentrado() {
    barra="════════════════════════════════════════════════════"
    texto="$2"
    texto_len=${#texto}
    barra_len=${#barra}
    espacios=$(((barra_len - texto_len) / 2))

    printf "%${espacios}s" "" # Add spaces to center the text

    case $1 in
    -ne) cor="${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -ama) cor="${AMARILLO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${AMARILLO}${NEGRITO}[!] ${ROJO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm2) cor="${ROJO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -azu) cor="${BLANCO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verd) cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -bra) cor="${GRIS}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    esac
}

msgCentradoBarra() {
    barra="════════════════════════════════════════════════════"
    texto="$2"
    texto_len=${#texto}
    barra_len=${#barra}
    espacios=$(((barra_len - texto_len - 2) / 2)) # -2 for spaces around the text

    case $1 in
    -ne) cor="${ROJO}${NEGRITO}" ;;
    -ama) cor="${AMARILLO}${NEGRITO}" ;;
    -verm) cor="${AMARILLO}${NEGRITO}[!] ${ROJO}" ;;
    -verm2) cor="${ROJO}${NEGRITO}" ;;
    -azu) cor="${BLANCO}${NEGRITO}" ;;
    -verd) cor="${VERDE}${NEGRITO}" ;;
    -bra) cor="${GRIS}${SINCOLOR}" ;;
    esac

    # Print the full bar with centered text
    printf "${cor}%s %s %s${SINCOLOR}\n" "${barra:0:espacios}" "${texto}" "${barra:0:espacios}"
}
