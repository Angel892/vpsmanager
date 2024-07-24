#!/bin/bash

instalar_protocolos() {
    while true; do
        clear
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;34m    Instalar Protocolos\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;32m1. Instalar Apache\e[0m"
        echo -e "\e[1;32m2. Instalar Nginx\e[0m"
        echo -e "\e[1;31m3. Regresar al menú principal\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1)
            echo -e "\e[1;33mInstalando Apache...\e[0m"
            sudo apt-get update
            sudo apt-get install -y apache2
            echo -e "\e[1;32mApache instalado.\e[0m"
            read -p "Presione Enter para continuar..."
            ;;
        2)
            echo -e "\e[1;33mInstalando Nginx...\e[0m"
            sudo apt-get update
            sudo apt-get install -y nginx
            echo -e "\e[1;32mNginx instalado.\e[0m"
            read -p "Presione Enter para continuar..."
            ;;
        3) break ;;
        *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
        esac
    done
}
