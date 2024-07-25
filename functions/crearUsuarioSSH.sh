#!/bin/bash

# Enable debugging
set -x

crear_usuario_ssh() {
    while true; do
        clear
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;34m     Crear Usuario SSH\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        read -p "Ingrese el nombre del nuevo usuario: " username
        sudo adduser $username
        sudo usermod -aG sudo $username
        echo -e "\e[1;32mUsuario SSH creado.\e[0m"
        read -p "¿Desea crear otro usuario? (s/n): " opcion
        if [[ $opcion != [sS] ]]; then
            break
        fi
    done
}
