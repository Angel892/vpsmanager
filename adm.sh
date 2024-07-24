#!/bin/bash

# Funciones para las opciones del menú
instalar_protocolos() {
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
        ;;
    2)
        echo -e "\e[1;33mInstalando Nginx...\e[0m"
        sudo apt-get update
        sudo apt-get install -y nginx
        echo -e "\e[1;32mNginx instalado.\e[0m"
        ;;
    3) mostrar_menu ;;
    *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
    esac
}

crear_usuario_ssh() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m     Crear Usuario SSH\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    read -p "Ingrese el nombre del nuevo usuario: " username
    sudo adduser $username
    sudo usermod -aG sudo $username
    echo -e "\e[1;32mUsuario SSH creado.\e[0m"
}

monitorear_recursos() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m    Monitorear Recursos\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;32m1. CPU\e[0m"
    echo -e "\e[1;32m2. Memoria\e[0m"
    echo -e "\e[1;32m3. Disco\e[0m"
    echo -e "\e[1;31m4. Regresar al menú principal\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    read -p "Seleccione una opción: " opcion
    case $opcion in
    1)
        echo -e "\e[1;33mUso de CPU:\e[0m"
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
        ;;
    2)
        echo -e "\e[1;33mUso de Memoria:\e[0m"
        free -m | awk 'NR==2{printf "Uso de Memoria: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
        ;;
    3)
        echo -e "\e[1;33mUso de Disco:\e[0m"
        df -h | awk '$NF=="/"{printf "Uso de Disco: %d/%dGB (%s)\n", $3,$2,$5}'
        ;;
    4) mostrar_menu ;;
    *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
    esac
}

mostrar_menu() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m   Administrador de VPS\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;32m1. Instalar Protocolos\e[0m"
    echo -e "\e[1;32m2. Crear Usuario SSH\e[0m"
    echo -e "\e[1;32m3. Monitorear Recursos\e[0m"
    echo -e "\e[1;31m4. Salir\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    read -p "Seleccione una opción: " opcion
    case $opcion in
    1) instalar_protocolos ;;
    2) crear_usuario_ssh ;;
    3) monitorear_recursos ;;
    4)
        echo -e "\e[1;33mSaliendo...\e[0m"
        exit 0
        ;;
    *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
    esac
}

# Bucle para mostrar el menú hasta que el usuario decida salir
while true; do
    mostrar_menu
done
