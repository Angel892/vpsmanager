#!/bin/bash

MAIN_PATH="/etc/vpsmanager/functions/protocols";

source $MAIN_PATH/apache.sh
source $MAIN_PATH/nginx.sh


instalar_protocolos() {
    while true; do
        clear
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;34m    Instalar Protocolos\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;32m1. Instalar Apache\e[0m"
        echo -e "\e[1;32m2. Instalar Nginx\e[0m"
        echo -e "\e[1;31m0. Regresar al menú principal\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) install_apache;;
        2) install_nginx;;
        0) break ;;
        *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
        esac
    done
}
