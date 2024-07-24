#!/bin/bash

# Función para actualizar el script desde GitHub
actualizar_script() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m  Actualizando el Script\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    cd /etc/vpsmanager

    # Elimina el script antiguo (opcional)
    sudo rm /etc/vpsmanager/adm.sh

    #OBTENEMOS EL ID DEL ULTIMO COMMIT

    # Reemplaza "owner" con el propietario del repositorio y "repo" con el nombre del repositorio
    OWNER="Angel892"
    REPO="vpsmanager"
    BRANCH="master"

    # Hacer una solicitud a la API de GitHub para obtener el último commit en la rama especificada
    LATEST_COMMIT=$(curl -s https://api.github.com/repos/$OWNER/$REPO/commits/$BRANCH | jq -r '.sha')

    sudo wget --no-cache --timestamping -O /etc/vpsmanager/adm.sh https://raw.githubusercontent.com/Angel892/vpsmanager/$LATEST_COMMIT/adm.sh
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló la actualización del script.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi
    sudo chmod +x /etc/vpsmanager/adm.sh
    echo -e "\e[1;32mEl script se ha actualizado correctamente.\e[0m"
    read -p "Presione Enter para continuar..."
    exec /etc/vpsmanager/adm.sh
}

# Funciones para las opciones del menú
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

monitorear_recursos() {
    while true; do
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
            read -p "Presione Enter para continuar..."
            ;;
        2)
            echo -e "\e[1;33mUso de Memoria:\e[0m"
            free -m | awk 'NR==2{printf "Uso de Memoria: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
            read -p "Presione Enter para continuar..."
            ;;
        3)
            echo -e "\e[1;33mUso de Disco:\e[0m"
            df -h | awk '$NF=="/"{printf "Uso de Disco: %d/%dGB (%s)\n", $3,$2,$5}'
            read -p "Presione Enter para continuar..."
            ;;
        4) break ;;
        *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
        esac
    done
}

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
        echo -e "\e[1;32m4. Actualizar Script\e[0m"
        echo -e "\e[1;32m4. Actualizar Script\e[0m"
        echo -e "\e[1;32m4. Actualizar Script\e[0m"
        echo -e "\e[1;31m5. Salir\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) instalar_protocolos ;;
        2) crear_usuario_ssh ;;
        3) monitorear_recursos ;;
        4) actualizar_script ;;
        5)
            echo -e "\e[1;33mSaliendo...\e[0m"
            exit 0
            ;;
        *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
        esac
    done
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mostrar_menu
