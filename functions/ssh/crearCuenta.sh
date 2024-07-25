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

    # Crear el usuario sin contraseña
    sudo adduser --disabled-password --gecos "" "$username"

    # Asignar la contraseña al usuario de forma no interactiva
    echo "$username:$password" | sudo chpasswd

    # Establecer la fecha de expiración de la cuenta
    sudo chage -E "$(date -d "+${duration} days" +%Y-%m-%d)" "$username"

    echo -e "${VERDE}Cuenta SSH para '$username' creada correctamente con una duración de $duration días.${NC}"
    read -p "Presione Enter para continuar..."
}