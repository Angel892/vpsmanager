#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

crearCuentaSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}    Crear nueva cuenta SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    while true; do
        read -p "Ingrese el nombre del nuevo usuario: " username
        if id "$username" &>/dev/null; then
            echo -e "${ROJO}Error: El usuario '$username' ya existe.${NC}"
        else
            break
        fi
    done

    read -s -p "Ingrese la contraseña para el nuevo usuario: " password
    echo

    while true; do
        read -p "Ingrese la duración de la cuenta (en días): " duration
        if ! [[ "$duration" =~ ^[0-9]+$ ]]; then
            echo -e "${ROJO}Error: La duración debe ser un número válido.${NC}"
        else
            break
        fi
    done

    while true; do
        read -p "Ingrese el límite de conexiones para el usuario: " limit
        if ! [[ "$limit" =~ ^[0-9]+$ ]]; then
            echo -e "${ROJO}Error: El límite debe ser un número válido.${NC}"
        else
            break
        fi
    done

    # Obtener la IP del servidor
    server_ip=$(hostname -I | awk '{print $1}')

    # Crear el usuario sin contraseña
    sudo adduser --disabled-password --gecos "" "$username"

    # Asignar la contraseña al usuario de forma no interactiva
    echo "$username:$password" | sudo chpasswd

    # Establecer la fecha de expiración de la cuenta
    sudo chage -E "$(date -d "+${duration} days" +%Y-%m-%d)" "$username"

    # Establecer el límite de conexiones
    echo "$username hard maxlogins $limit" | sudo tee -a /etc/security/limits.conf

    echo -e "${VERDE}Cuenta SSH creada con éxito.${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}Detalles de la cuenta${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${VERDE}IP del servidor: ${NC}$server_ip"
    echo -e "${VERDE}Usuario: ${NC}$username"
    echo -e "${VERDE}Contraseña: ${NC}$password"
    echo -e "${VERDE}Duración: ${NC}$duration días"
    echo -e "${VERDE}Límite de conexiones: ${NC}$limit"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}