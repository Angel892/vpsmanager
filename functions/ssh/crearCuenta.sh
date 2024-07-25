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
        elif [[ ${#password} -lt 2 ]]; then
            echo -e "${ROJO}Error: La contraseña debe tener al menos 8 caracteres.${NC}"
        else
            break
        fi
    done

    while true; do
        read -p "Ingrese la duración de la cuenta (en días): " duration
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

    # Establecer la fecha de expiración de la cuenta
    expiration_date=$(date -d "+${duration} days" +%Y-%m-%d)
    sudo chage -E "$expiration_date" "$username"

    # Establecer el límite de conexiones
    echo "$username hard maxlogins $limit" | sudo tee -a /etc/security/limits.conf

    # Marcar el usuario como creado por el administrador con todos los detalles
    echo "$username:$password:$expiration_date:$limit" | sudo tee -a /etc/vpsmanager/users.txt

    clear

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