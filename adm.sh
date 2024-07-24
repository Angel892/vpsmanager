#!/bin/bash

# Incluir los archivos de funciones
source /etc/vpsmanager/funciones/actualizar.sh
source /etc/vpsmanager/funciones/instalar_protocolos.sh
source /etc/vpsmanager/funciones/crear_usuario_ssh.sh
source /etc/vpsmanager/funciones/monitorear_recursos.sh
source /etc/vpsmanager/funciones/eliminar.sh

mostrar_menu() {
    while true; do
        clear
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;34m   Administrador de VPS\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;32m1. Instalar Protocolos\e[0m"
        echo -e "\e[1;32m2. Crear Usuario SSH\e[0m"
        echo -e "\e[1;32m3. Monitorear Recursos\e[0m"
        echo -e "\e[1;32m4. Actualizar Script\e[0m"
        echo -e "\e[1;32m5. Eliminar Script\e[0m"
        echo -e "\e[1;31m6. Salir\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) instalar_protocolos ;;
        2) crear_usuario_ssh ;;
        3) monitorear_recursos ;;
        4) actualizar_script ;;
        5) eliminar_script ;;
        6)
            echo -e "\e[1;33mSaliendo...\e[0m"
            exit 0
            ;;
        *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
        esac
    done
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mostrar_menu
