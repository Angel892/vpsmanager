#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


crear_usuario_ssh() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}     Crear Usuario SSH${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Ingrese el nombre del nuevo usuario: " username
        sudo adduser $username
        sudo usermod -aG sudo $username
        echo -e "${SECUNDARIO}Usuario SSH creado.${NC}"
        read -p "¿Desea crear otro usuario? (s/n): " opcion
        if [[ $opcion != [sS] ]]; then
            break
        fi
    done
}
