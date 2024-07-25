#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh


autoiniciarScript() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Autoiniciar Script${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    local crontab_entry="@reboot /etc/vpsmanager/adm.sh"

    # Verificar si ya existe una entrada en crontab
    if crontab -l | grep -q "$crontab_entry"; then
        echo -e "${VERDE}El script ya está configurado para autoiniciarse al entrar en la VPS.${NC}"
        echo -e "${AMARILLO}¿Desea eliminar esta configuración? (s/n):${NC}"
        read -p "Opción: " opcion
        if [[ "$opcion" =~ ^[sS]$ ]]; then
            (crontab -l | grep -v "$crontab_entry") | crontab -
            echo -e "${ROJO}Autoinicio del script desactivado.${NC}"
        else
            echo -e "${AMARILLO}Operación cancelada.${NC}"
        fi
    else
        echo -e "${ROJO}El script no está configurado para autoiniciarse.${NC}"
        echo -e "${AMARILLO}¿Desea activar esta configuración? (s/n):${NC}"
        read -p "Opción: " opcion
        if [[ "$opcion" =~ ^[sS]$ ]]; then
            (crontab -l 2>/dev/null; echo "$crontab_entry") | crontab -
            echo -e "${VERDE}Autoinicio del script activado.${NC}"
        else
            echo -e "${AMARILLO}Operación cancelada.${NC}"
        fi
    fi

    read -p "Presione Enter para continuar..."
}