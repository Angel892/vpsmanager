#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

crearCuentaTemporalSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}    Crear nueva cuenta SSH TEMPORAL${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    while true; do
        read -p "Ingrese el nombre del nuevo usuario: " username
        if [ -z "$username" ]; then
            echo -e "${ROJO}Error: El nombre de usuario no puede estar vacío.${NC}"
        elif id "$username" &>/dev/null; then
            echo -e "${ROJO}Error: El usuario '$username' ya existe.${NC}"
        else
            break
        fi
    done

    while true; do
        read -s -p "Ingrese la contraseña para el nuevo usuario: " password
        echo
        if [ -z "$password" ]; then
            echo -e "${ROJO}Error: La contraseña no puede estar vacía.${NC}"
        elif [[ ${#password} -lt 8 ]]; then
            echo -e "${ROJO}Error: La contraseña debe tener al menos 8 caracteres.${NC}"
        else
            break
        fi
    done

    while true; do
        read -p "Ingrese la duración de la cuenta (en minutos): " duration
        if [ -z "$duration" ]; then
            echo -e "${ROJO}Error: La duración no puede estar vacía.${NC}"
        elif ! [[ "$duration" =~ ^[0-9]+$ ]]; then
            echo -e "${ROJO}Error: La duración debe ser un número válido.${NC}"
        else
            break
        fi
    done

    while true; do
        read -p "Ingrese el límite de conexiones para el usuario: " limit
        if [ -z "$limit" ]; then
            echo -e "${ROJO}Error: El límite de conexiones no puede estar vacío.${NC}"
        elif ! [[ "$limit" =~ ^[0-9]+$ ]]; then
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

    # Establecer la fecha de expiración de la cuenta en minutos
    expiration_date=$(date -d "+${duration} minutes" +%Y-%m-%dT%H:%M:%S)

    sudo chage -E "$(date -d "$expiration_date" +%Y-%m-%d)" "$username"

    # Programar la eliminación del usuario después de la duración especificada
    echo "sudo userdel -r $username" | sudo at now + $duration minutes

    # Establecer el límite de conexiones
    echo "$username hard maxlogins $limit" | sudo tee -a /etc/security/limits.conf

    clear

    echo -e "${VERDE}Cuenta SSH creada con éxito.${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}Detalles de la cuenta${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${VERDE}IP del servidor: ${NC}$server_ip"
    echo -e "${VERDE}Usuario: ${NC}$username"
    echo -e "${VERDE}Contraseña: ${NC}$password"
    echo -e "${VERDE}Duración: ${NC}$duration minutos"
    echo -e "${VERDE}Límite de conexiones: ${NC}$limit"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}