#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

mainPath="/etc/vpsmanager";

# COLORES
source $HELPERS_PATH/colors.sh

#Eliminar linea anterior
eliminarl=$(
    tput cuu1
    tput el
)

#eliminarl=$(
#    tput cuu1
#    tput dl1
#)

barra="════════════════════════════════════════════════════"

mostrarActivo() {
    echo -e "${VERDE}[ ACTIVO ]${NC}"
}

mostrarInActivo() {
    echo -e "${ROJO}[ OFF ]${NC}"
}

validarArchivo() {
    local filePath="$1"
    local dirPath=$(dirname "$filePath")

    if [ ! -d "$dirPath" ]; then
        # Si el directorio no existe, se crea
        mkdir -p "$dirPath"
    fi

    if [ ! -e "$filePath" ]; then
        # Si el archivo no existe, se crea
        touch "$filePath"
    fi
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
        # Muestra el prompt de selección
        read -p $'\033[1;97m  └⊳ Seleccione una opción:\033[1;32m ' selection
        # Verifica si la opción es válida
        if [[ -z $selection ]]; then
            # Si la entrada está vacía, muestra un mensaje de error y repite el bucle
            echo -ne "${eliminarl}\033[1;31mSelección no válida.\033[0m" >&2
            sleep 1
            echo -e "${eliminarl}" >&2
        elif [[ $options =~ (^|[^\d])$selection($|[^\d]) ]]; then
            echo $selection
            break
        else
            # Si la opción no es válida, muestra el mensaje de error y repite el bucle
            echo -ne "${eliminarl}\033[1;31mSelección no válida: $selection\033[0m" >&2
            sleep 1
            echo -e "${eliminarl}" >&2
        fi
    done
}

msg() { ##-->> COLORES, TITULO, BARRAS

    case $1 in
    -ne) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -rojo) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -gris) cor="${NEGRITA}${GRIS}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    "-bar2" | "-bar") cor="${NEGRITA}${ROJO}════════════════════════════════════════════════════" && echo -e "${SINCOLOR}${cor}${SINCOLOR}" ;;
    # Centrar texto
    -tit) msgCentrado -noStyle "\e[48;5;214m\e[38;5;0m 💻 S C R I P T | L X M A N A G E R 💻 " ;;
    esac
}

msgCentrado() {
    texto="$2"
    texto_len=${#texto}
    barra_len=${#barra}
    espacios=$(((barra_len - texto_len) / 2))

    printf "%${espacios}s" "" # Add spaces to center the text

    case $1 in
    -ne) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verm2) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -azul) cor="${NEGRITA}${BLANCO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -gris) cor="${NEGRITA}${GRIS}${SINCOLOR}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -noStyle) echo -e "${2}${SINCOLOR}" ;;
    esac
}

msgCentradoBarra() {
    texto="$2"
    texto_len=${#texto}
    barra_len=${#barra}
    espacios=$(((barra_len - texto_len - 2) / 2)) # -2 for spaces around the text

    case $1 in
    -ne) cor="${NEGRITA}${ROJO}${NEGRITO}" ;;
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" ;;
    -verm2) cor="${NEGRITA}${ROJO}${NEGRITO}" ;;
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}" ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" ;;
    -gris) cor="${NEGRITA}${GRIS}${SINCOLOR}" ;;
    esac

    # Print the full bar with centered text
    printf "${cor}%s %s %s${SINCOLOR}\n" "${barra:0:espacios}" "${texto}" "${barra:0:espacios}"
}

validarDirectorio() {
    directorio=$1
    # Verificar si el directorio ya existe
    if [ ! -d "$directorio" ]; then
        # Crear el directorio de destino, junto con los padres necesarios
        sudo mkdir -p "$directorio"
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo crear el directorio $directorio."
            exit 1
        fi
        echo "Directorio $directorio creado."
    else
        # Eliminar el directorio
        sudo rm -r "$directorio"
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo eliminar el directorio $directorio."
            exit 1
        fi
        echo "Directorio $directorio existente, Eliminándolo."

        # Crear el directorio de destino, junto con los padres necesarios
        sudo mkdir -p "$directorio"
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo crear el directorio $directorio."
            exit 1
        fi
        echo "Directorio $directorio creado."
    fi
}

# Function to print menu options
opcionMenu() {
    local option=$1
    local numOption=$2
    local textOption=$(echo "$3" | tr '[:lower:]' '[:upper:]')

    #echo -e "${textOption}"

    local isNewLine=${4:-true} # Por defecto es true si no se proporciona un tercer parámetro

    local spacing=${5:-3}

    local checkStatus=${6:-""}

    local typeChek=${7:-""}

    if [[ $checkStatus == "" ]]; then

        case $option in
        -rojo) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${ROJO}%-20s${NC}" "$numOption" "$textOption" ;;
        -blanco) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${BLANCO}%-20s${NC}" "$numOption" "$textOption" ;;
        -amarillo) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${AMARILLO}%-20s${NC}" "$numOption" "$textOption" ;;
        -verde) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${VERDE}%-20s${NC}" "$numOption" "$textOption" ;;
        -azul) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${AZUL}%-20s${NC}" "$numOption" "$textOption" ;;
        -gris) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${GRIS}%-20s${NC}" "$numOption" "$textOption" ;;
        -salir) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> \033[1;41m  ❗️${BLANCO} %s ❗️  ${NC}\n" "$numOption" "$textOption" ;;
        esac

    else

        local currentStatus

        if [[ $typeChek == "f" ]]; then
            currentStatus=$(checkStatusF $checkStatus)
        else
            currentStatus=$(checkStatusF $checkStatus)
        fi

        local width=${#barra}
        local textLength=${#textOption}
        local statusLength=${#currentStatus}

        local dashCount=$((width - textLength - statusLength - 20)) # Ajusta 10 para los caracteres adicionales

        # Función para generar guiones
        generate_dashes() {
            local count=$1
            local dashes=""
            for ((i = 0; i < count; i++)); do
                dashes+="-"
            done
            echo "$dashes"
        }

        local dashes=$(generate_dashes $dashCount)

        case $option in
        -rojo) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${ROJO}%-20s${NC}" "$numOption" "$textOption" ;;
        -blanco) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${BLANCO}%-20s${NC}" "$numOption" "$textOption" ;;
        -amarillo) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${AMARILLO}%-20s${NC}" "$numOption" "$textOption" ;;
        -verde) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${VERDE}%-20s${NC}" "$numOption" "$textOption" ;;
        -azul) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${AZUL}%-20s${NC}" "$numOption" "$textOption" ;;
        -gris) printf " ${NEGRITA}${AMARILLO}[${VERDE}%d${AMARILLO}] ${ROJO}> ${GRIS}%-20s${NC}" "$numOption" "$textOption" ;;
        esac

        # Agrega el estado actual si está definido
        if [[ -n $currentStatus ]]; then
            printf "%s" "  $currentStatus"
        fi

    fi

    if ($isNewLine == true); then
        echo
    else
        printf "%${spacing}s" ""
    fi
}

vpsIP() {
  if [[ -e /tmp/IP ]]; then
    echo "$(cat /tmp/IP)"
  else
    MEU_IP=$(wget -qO- ifconfig.me)
    echo "$MEU_IP" >/tmp/IP
  fi
}


msgCentradoRead() {
    texto="$2"
    texto_len=${#texto}
    barra_len=${#barra}
    espacios=$(((barra_len - texto_len) / 2))

    printf "%${espacios}s" "" # Add spaces to center the text

    case $1 in
    -ne) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -ne "${cor}${2}${SINCOLOR}" ;;
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" && read -p "${cor}${2}${SINCOLOR}" ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" && read -p "${cor}${2}${SINCOLOR}" ;;
    -verm2) cor="${NEGRITA}${ROJO}${NEGRITO}" && read -p "${cor}${2}${SINCOLOR}" ;;
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}" && read -p "${cor}${2}${SINCOLOR}" ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" && read -p "${cor}${2}${SINCOLOR}" ;;
    -gris) cor="${NEGRITA}${GRIS}${SINCOLOR}" && read -p "${cor}${2}${SINCOLOR}" ;;
    -noStyle) read -p "${2}${SINCOLOR}" ;;
    esac
}