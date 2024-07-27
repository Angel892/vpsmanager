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
