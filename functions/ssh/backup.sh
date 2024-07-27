#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales
source $HELPERS_PATH/global.sh

backupUsuariosSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}   Realizar Backup de Usuarios SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    BACKUP_DIR="/etc/vpsmanager/backup"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/backup_usuarios_ssh_$TIMESTAMP.tar.gz"

    # Crear directorio de backup si no existe
    if [ ! -d "$BACKUP_DIR" ]; then
        sudo mkdir -p "$BACKUP_DIR"
        if [ $? -ne 0 ]; then
            echo -e "${ROJO}Error: No se pudo crear el directorio de backup.${NC}"
            read -p "Presione Enter para continuar..."
            return
        fi
    fi

    # Realizar el backup
    sudo tar -czf "$BACKUP_FILE" /etc/passwd /etc/shadow /etc/group /etc/gshadow
    if [ $? -eq 0 ]; then
        echo -e "${VERDE}Backup de usuarios SSH realizado con éxito.${NC}"
        echo -e "${VERDE}Archivo de backup: ${NC}$BACKUP_FILE"
    else
        echo -e "${ROJO}Error: No se pudo realizar el backup.${NC}"
    fi

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}