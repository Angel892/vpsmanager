#!/bin/bash

# Funciones para las opciones del menú
instalar_protocolos() {
    echo "========================="
    echo "    Instalar Protocolos"
    echo "========================="
    echo "1. Instalar Apache"
    echo "2. Instalar Nginx"
    echo "3. Regresar al menú principal"
    read -p "Seleccione una opción: " opcion
    case $opcion in
    1)
        echo "Instalando Apache..."
        sudo apt-get update
        sudo apt-get install -y apache2
        echo "Apache instalado."
        ;;
    2)
        echo "Instalando Nginx..."
        sudo apt-get update
        sudo apt-get install -y nginx
        echo "Nginx instalado."
        ;;
    3) mostrar_menu ;;
    *) echo "Opción inválida, por favor intente de nuevo." ;;
    esac
}

crear_usuario_ssh() {
    echo "========================="
    echo "     Crear Usuario SSH"
    echo "========================="
    read -p "Ingrese el nombre del nuevo usuario: " username
    sudo adduser $username
    sudo usermod -aG sudo $username
    echo "Usuario SSH creado."
}

monitorear_recursos() {
    echo "========================="
    echo "    Monitorear Recursos"
    echo "========================="
    echo "1. CPU"
    echo "2. Memoria"
    echo "3. Disco"
    echo "4. Regresar al menú principal"
    read -p "Seleccione una opción: " opcion
    case $opcion in
    1)
        echo "Uso de CPU:"
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
        ;;
    2)
        echo "Uso de Memoria:"
        free -m | awk 'NR==2{printf "Uso de Memoria: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
        ;;
    3)
        echo "Uso de Disco:"
        df -h | awk '$NF=="/"{printf "Uso de Disco: %d/%dGB (%s)\n", $3,$2,$5}'
        ;;
    4) mostrar_menu ;;
    *) echo "Opción inválida, por favor intente de nuevo." ;;
    esac
}

mostrar_menu() {
    echo "========================="
    echo "   Administrador de VPS"
    echo "========================="
    echo "1. Instalar Protocolos"
    echo "2. Crear Usuario SSH"
    echo "3. Monitorear Recursos"
    echo "4. Salir"
    echo "========================="
    read -p "Seleccione una opción: " opcion
    case $opcion in
    1) instalar_protocolos ;;
    2) crear_usuario_ssh ;;
    3) monitorear_recursos ;;
    4)
        echo "Saliendo..."
        exit 0
        ;;
    *) echo "Opción inválida, por favor intente de nuevo." ;;
    esac
}

# Bucle para mostrar el menú hasta que el usuario decida salir
while true; do
    mostrar_menu
done
