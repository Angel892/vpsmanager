#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

mainPath="/etc/vpsmanager"

# COLORES
source $HELPERS_PATH/colors.sh

source $HELPERS_PATH/rebootnb.sh

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
        mkdir -p "$dirPath" 2>/dev/null
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

checkStatusVersion() {
    toCheck=$("$1" --version 2>/dev/null)
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

msgne() { ##-->> COLORES, TITULO, BARRAS

    case $1 in
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" && echo -ne "${cor}${2}" ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" && echo -ne "${cor}${2}" ;;
    -rojo) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -ne "${cor}${2}" ;;
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}" && echo -ne "${cor}${2}" ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" && echo -ne "${cor}${2}" ;;
    -gris) cor="${NEGRITA}${GRIS}${NEGRITO}" && echo -ne "${cor}${2}" ;;
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
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}[!] ${ROJO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -rojo) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
    -azul) cor="${NEGRITA}${AZUL}${NEGRITO}" && echo -e "${cor}${2}${SINCOLOR}" ;;
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

# Function to generate a string with a given number of spaces
generate_spaces() {
    local count=$1
    local spaces=""
    for ((i = 0; i < count; i++)); do
        spaces+=" "
    done
    echo "$spaces"
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
        -rojo) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${ROJO}${textOption}${NC}" ;;
        -blanco) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${BLANCO}${textOption}${NC}" ;;
        -amarillo) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${AMARILLO}${textOption}${NC}" ;;
        -verde) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${VERDE}${textOption}${NC}" ;;
        -azul) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${AZUL}${textOption}${NC}" ;;
        -gris) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${GRIS}${textOption}${NC}" ;;
        -salir) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> \033[1;41m  ❗️${BLANCO} ${textOption} ❗️  ${NC}\n" ;;
        esac

    else

        local currentStatus

        if [[ $typeChek == "f" ]]; then
            currentStatus=$(checkStatusF $checkStatus)
        elif [[ $typeChek == "v" ]]; then
            currentStatus=$(checkStatusVersion $checkStatus)
        else
            currentStatus=$(checkStatus $checkStatus)
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
        -rojo) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${ROJO}${textOption}${NC}" ;;
        -blanco) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${BLANCO}${textOption}${NC}" ;;
        -amarillo) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${AMARILLO}${textOption}${NC}" ;;
        -verde) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${VERDE}${textOption}${NC}" ;;
        -azul) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${AZUL}${textOption}${NC}" ;;
        -gris) echo -ne " ${NEGRITA}${AMARILLO}[${VERDE}${numOption}${AMARILLO}] ${ROJO}> ${GRIS}${textOption}${NC}" ;;
        esac

        # Agrega el estado actual si está definido
        if [[ -n $currentStatus ]]; then
            echo -ne "  $currentStatus"
        fi

    fi

    if ($isNewLine == true); then
        echo
    else
        local spaces=$(generate_spaces $spacing)
        echo -ne "$spaces"
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
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" && printf "${cor}${2}${SINCOLOR}" && read -r ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" && printf "${cor}${2}${SINCOLOR}" && read -r ;;
    -verm2) cor="${NEGRITA}${ROJO}${NEGRITO}" && printf "${cor}${2}${SINCOLOR}" && read -r ;;
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}" && printf "${cor}${2}${SINCOLOR}" && read -r ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" && printf "${cor}${2}${SINCOLOR}" && read -r ;;
    -gris) cor="${NEGRITA}${GRIS}${SINCOLOR}" && printf "${cor}${2}${SINCOLOR}" && read -r ;;
    -noStyle) printf "${2}${SINCOLOR}" && read -r ;;
    esac
}

minCaracteres=1
maxCaracteres=15
duracionMaxima=999
limiteMaximo=999

errorFun() {
    local valor=${2:-""}
    case $1 in
    "nullo")
        msg -rojo "Respuesta nulla"
        sleep 3s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    "minimo")
        msg -rojo "Respuesta muy corta ($minCaracteres - $maxCaracteres caracteres)"
        sleep 2s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    "maximo")
        msg -rojo "Respuesta muy larga ($minCaracteres - $maxCaracteres caracteres)"
        sleep 2s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    "soloNumeros")
        msg -rojo "Respuesta invalida, solo se permiten numeros"
        sleep 2s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    "duracionMaxima")
        msg -rojo "Duracion maxima: $duracionMaxima dias"
        sleep 2s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    "limiteMaximo")
        msg -rojo "Limite maximo de $limiteMaximo"
        sleep 2s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    "existente")
        msg -rojo "$valor Ya Existe"
        sleep 2s
        tput cuu1
        tput dl1
        tput cuu1
        tput dl1
        ;;
    esac
}

GetAllUsers() {

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
    if [[ -e "$mainPath/cuentasactivast" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
    fi

    ##-->>LECTOR DE CUENTAS
    if [[ -e "$mainPath/cuentassh" ]]; then
        readarray -t usuarios_ativos1 < <(cut -d '|' -f1 $mainPath/cuentassh)
    fi
    if [[ -e "$mainPath/cuentahwid" ]]; then
        readarray -t usuarios_ativos2 < <(cut -d '|' -f1 $mainPath/cuentahwid)
    fi
    if [[ -e "$mainPath/cuentatoken" ]]; then
        readarray -t usuarios_ativos3 < <(cut -d '|' -f1 $mainPath/cuentatoken)
    fi

    if [[ -z ${mostrar_totales[@]} ]]; then
        msg -tit
        msg -bar
        msgCentrado -rojo "Ningun usuario registrado"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -tit
        msg -bar
        msgCentrado -amarillo "Usuarios Activos del Servidor"
        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
        fi
        local i=0
        for us in $(echo ${usuarios_ativos1[@]}); do
            opcionMenu -blanco $i "$us"
            let i++
        done
        #HWID
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
        fi
        for us in $(echo ${usuarios_ativos2[@]}); do
            nomhwid="$(cat $mainPath/cuentahwid | grep -w "${us}" | cut -d'|' -f5)"
            opcionMenu -blanco $i "$nomhwid"
            let i++
        done
        #TOKEN
        if [[ -z ${usuarios_ativos3[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN \e[0m\e[38;5;239m═══════════════"
        fi
        for us in $(echo ${usuarios_ativos3[@]}); do
            nomtoken="$(cat $mainPath/cuentatoken | grep -w "${us}" | cut -d'|' -f5)"
            opcionMenu -blanco $i "$nomtoken"
            let i++
        done
    fi

}

GetNormalUsers() {

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
    if [[ -e "$mainPath/cuentasactivast" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
    fi

    ##-->>LECTOR DE CUENTAS
    if [[ -e "$mainPath/cuentassh" ]]; then
        readarray -t usuarios_ativos1 < <(cut -d '|' -f1 $mainPath/cuentassh)
    fi

    if [[ -z ${mostrar_totales[@]} ]]; then
        msg -tit
        msg -bar
        msgCentrado -rojo "Ningun usuario registrado"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -tit
        msg -bar
        msgCentrado -amarillo "Usuarios Activos del Servidor"
        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
        fi
        local i=0
        for us in $(echo ${usuarios_ativos1[@]}); do
            opcionMenu -blanco $i "$us"
            let i++
        done
    fi

}

GetEditUsers() {

    local USRloked="$mainPath/temp/userlock"
    validarArchivo "$USRloked"

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
    if [[ -e "$mainPath/cuentasactivast" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
    fi

    ##-->>LECTOR DE CUENTAS
    if [[ -e "$mainPath/cuentassh" ]]; then
        readarray -t usuarios_ativos1 < <(cut -d '|' -f1 $mainPath/cuentassh)
    fi
    if [[ -e "$mainPath/cuentahwid" ]]; then
        readarray -t usuarios_ativos2 < <(cut -d '|' -f1 $mainPath/cuentahwid)
    fi
    if [[ -e "$mainPath/cuentatoken" ]]; then
        readarray -t usuarios_ativos3 < <(cut -d '|' -f1 $mainPath/cuentatoken)
    fi

    if [[ -z ${mostrar_totales[@]} ]]; then
        msg -tit
        msg -bar
        msgCentrado -rojo "Ningun usuario registrado"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -tit
        msg -bar
        msgCentrado -amarillo "Usuarios Activos del Servidor"
        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
        fi
        local i=0
        for us in $(echo ${usuarios_ativos1[@]}); do

            VPSsec=$(date +%s)
            DateExp="$(cat $mainPath/cuentassh | grep -w "${us}" | cut -d'|' -f3)"
            DataSec=$(date +%s --date="$DateExp")
            if [[ "$VPSsec" -gt "$DataSec" ]]; then
                EXPTIME="${ROJO}[Exp]"
            else
                EXPTIME="${VERDE}[$(($(($DataSec - $VPSsec)) / 86400))]"
            fi

            opcionMenu -blanco $i "$us" false 0 && echo -e "${EXPTIME}"

            let i++
        done
        #HWID
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
        fi
        for us in $(echo ${usuarios_ativos2[@]}); do
            VPSsec=$(date +%s)
            DateExp="$(cat $mainPath/cuentahwid | grep -w "${us}" | cut -d'|' -f3)"
            DataSec=$(date +%s --date="$DateExp")
            if [[ "$VPSsec" -gt "$DataSec" ]]; then
                EXPTIME="${red}[Exp]"
            else
                EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
            fi

            nomhwid="$(cat $mainPath/cuentahwid | grep -w "${us}" | cut -d'|' -f5)"

            opcionMenu -blanco $i "$nomhwid" false 0 && echo -e "${EXPTIME}"
            let i++
        done
        #TOKEN
        if [[ -z ${usuarios_ativos3[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN \e[0m\e[38;5;239m═══════════════"
        fi
        for us in $(echo ${usuarios_ativos3[@]}); do

            VPSsec=$(date +%s)
            DateExp="$(cat $mainPath/cuentatoken | grep -w "${us}" | cut -d'|' -f3)"
            DataSec=$(date +%s --date="$DateExp")
            if [[ "$VPSsec" -gt "$DataSec" ]]; then
                EXPTIME="${red}[Exp]"
            else
                EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
            fi

            nomtoken="$(cat $mainPath/cuentatoken | grep -w "${us}" | cut -d'|' -f5)"

            opcionMenu -blanco $i "$nomtoken" false 0 && echo -e "${EXPTIME}"

            let i++
        done
    fi

}

GetAllUsersBlock() {

    local USRloked="$mainPath/temp/userlock"
    validarArchivo "$USRloked"

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivast
    if [[ -e "$mainPath/cuentasactivast" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivast)
    fi

    ##-->>LECTOR DE CUENTAS
    if [[ -e "$mainPath/cuentassh" ]]; then
        readarray -t usuarios_ativos1 < <(cut -d '|' -f1 $mainPath/cuentassh)
    fi
    if [[ -e "$mainPath/cuentahwid" ]]; then
        readarray -t usuarios_ativos2 < <(cut -d '|' -f1 $mainPath/cuentahwid)
    fi
    if [[ -e "$mainPath/cuentatoken" ]]; then
        readarray -t usuarios_ativos3 < <(cut -d '|' -f1 $mainPath/cuentatoken)
    fi

    if [[ -z ${mostrar_totales[@]} ]]; then
        msg -tit
        msg -bar
        msgCentrado -rojo "Ningun usuario registrado"
        msg -bar

        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    else
        msg -tit
        msg -bar
        msgCentrado -amarillo "Usuarios Activos del Servidor"
        #SSH
        if [[ -z ${usuarios_ativos1[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS NORMALES  \e[0m\e[38;5;239m════════════════"
        fi
        local i=0
        for us in $(echo ${usuarios_ativos1[@]}); do
            if [[ $(cat ${USRloked} | grep -w "${us}") ]]; then
                opcionMenu -blanco $i "$us" false 0 && echo -e "\033[1;31m[ Lock ]"
            else
                opcionMenu -blanco $i "$us" false 0 && echo -e "\033[1;32m[ Unlock ]"
            fi
            let i++
        done
        #HWID
        if [[ -z ${usuarios_ativos2[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON HWID  \e[0m\e[38;5;239m════════════════"
        fi
        for us in $(echo ${usuarios_ativos2[@]}); do
            nomhwid="$(cat $mainPath/cuentahwid | grep -w "${us}" | cut -d'|' -f5)"
            if [[ $(cat ${USRloked} | grep -w "${us}") ]]; then
                opcionMenu -blanco $i "$nomhwid" false 0 && echo -e "\033[1;31m[ Lock ]"
            else
                opcionMenu -blanco $i "$nomhwid" false 0 && echo -e "\033[1;32m[ Unlock ]"
            fi
            let i++
        done
        #TOKEN
        if [[ -z ${usuarios_ativos3[@]} ]]; then
            echo "" >/dev/null 2>&1
        else
            echo -e "\033[38;5;239m════════════════\e[100m\e[97m  CUENTAS CON TOKEN \e[0m\e[38;5;239m═══════════════"
        fi
        for us in $(echo ${usuarios_ativos3[@]}); do
            nomtoken="$(cat $mainPath/cuentatoken | grep -w "${us}" | cut -d'|' -f5)"
            if [[ $(cat ${USRloked} | grep -w "${us}") ]]; then
                opcionMenu -blanco $i "$nomtoken" false 0 && echo -e "\033[1;31m[ Lock ]"
            else
                opcionMenu -blanco $i "$nomtoken" false 0 && echo -e "\033[1;32m[ Unlock ]"
            fi
            let i++
        done
    fi

}

#--- FUNCION BARRAS DE INSTALACION
fun_bar() {
    comando="$1"
    _=$(
        $comando >/dev/null 2>&1
    ) &
    >/dev/null
    pid=$!

    echo -ne "  \033[1;33m["

    while kill -0 $pid 2>/dev/null; do
        for ((i = 0; i < 20; i++)); do
            if ! kill -0 $pid 2>/dev/null; then
                break
            fi
            echo -ne "\033[1;31m#"

            if [ "$i" -ge 19 ]; then
                echo -ne "\033[1;33m]"
                echo
                tput cuu1 && tput dl1
                echo -ne "  \033[1;33m["
            fi

            sleep 0.08
        done
    done
    if dpkg --get-selections | grep -qw "$paquete"; then
        ESTATUS="\033[1;33m       \033[92mINSTALADO"
    else
        ESTATUS="\033[91m  FALLO DE INSTALACION"
    fi

    echo -ne " - \033[1;32m100%\033[0m\n"
    echo -e ""
}

# ------- BARRA DE INSTALL PAQUETES
barra_intall() {
    comando="$1"

    _=$(
        $comando >/dev/null 2>&1
    ) &
    >/dev/null
    pid=$!
    echo -ne "  \033[1;33m["

    while kill -0 $pid 2>/dev/null; do
        for ((i = 0; i < 20; i++)); do
            if ! kill -0 $pid 2>/dev/null; then
                break
            fi
            echo -ne "\033[1;31m>"

            if [ "$i" -ge 19 ]; then
                echo -ne "\033[1;33m]"
                echo
                tput cuu1 && tput dl1
                echo -ne "  \033[1;33m["
            fi

            sleep 0.08
        done
    done

    if dpkg --get-selections | grep -qw "$paquete"; then
        ESTATUS="\033[1;33m       \033[92mINSTALADO"
    else
        ESTATUS="\033[91m  FALLO DE INSTALACION"
    fi

    echo -ne "\033[1;33m] $ESTATUS \033[0m\n"

    echo -e ""
}

# ------- BARRA DE INTALL BASICO
barra_intallb() {
    comando="$1"
    _=$(
        $comando >/dev/null 2>&1
    ) &
    pid=$!
    echo -ne "  \033[1;33m["

    while [[ -d /proc/$pid ]]; do
        for ((i = 0; i < 40; i++)); do
            if [[ ! -d /proc/$pid ]]; then
                break
            fi
            echo -ne "\033[1;31m>"

            if [ "$i" -ge 39 ]; then
                echo -ne "\033[1;33m]"
                echo
                tput cuu1 && tput dl1
                echo -ne "  \033[1;33m["
            fi

            sleep 0.1
        done
    done

    echo -ne "\033[1;33m] - \033[1;32m OK \033[0m\n"
}

msgInstall() {
    local messageText=$(echo "$2" | tr '[:lower:]' '[:upper:]')

    case $1 in
    -amarillo) cor="${NEGRITA}${AMARILLO}${NEGRITO}" && echo -e "${cor}    ◽️ ${messageText}${SINCOLOR}" ;;
    -verm) cor="${NEGRITA}${AMARILLO}${NEGRITO}[!] ${ROJO}" && echo -e "${cor}    ◽️ ${messageText}${SINCOLOR}" ;;
    -rojo) cor="${NEGRITA}${ROJO}${NEGRITO}" && echo -e "${cor}    ◽️ ${messageText}${SINCOLOR}" ;;
    -blanco) cor="${NEGRITA}${BLANCO}${NEGRITO}" && echo -e "${cor}    ◽️ ${messageText}${SINCOLOR}" ;;
    -verde) cor="${NEGRITA}${VERDE}${NEGRITO}" && echo -e "${cor}    ◽️ ${messageText}${SINCOLOR}" ;;
    -gris) cor="${NEGRITA}${GRIS}${SINCOLOR}" && echo -e "${cor}    ◽️ ${messageText}${SINCOLOR}" ;;
    "-bar2" | "-bar") cor="${NEGRITA}${ROJO}════════════════════════════════════════════════════" && echo -e "${SINCOLOR}${cor}${SINCOLOR}" ;;
    esac

    #echo -e "\033[1;97m    ◽️ $messageText"
}

showCabezera() {
    local messageText=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    clear && clear
    msg -bar

    msg -tit
    msg -bar
    msgCentrado -amarillo "${messageText}"
    msg -bar
}

msgSuccess() {
    msg -bar
    msgCentrado -verde "PROCESO REALIZADO CON EXITO"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}

msgError() {
    msg -bar
    msgCentrado -rojo "ALGO FALLO EN EL PROCESO"
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}

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
