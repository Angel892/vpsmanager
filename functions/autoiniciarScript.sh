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

    if grep -q "/etc/vpsmanager/adm.sh" /etc/bash.bashrc; then
        echo -e "${VERDE}El script ya está configurado para autoiniciarse.${NC}"
        echo -e "${AMARILLO}¿Desea eliminar esta configuración? (s/n):${NC}"
        read -p "Opción: " opcion
        if [[ "$opcion" =~ ^[sS]$ ]]; then
            sed -i '/\/etc\/vpsmanager\/adm.sh/d' /etc/bash.bashrc
            echo -e "${ROJO}Autoinicio del script desactivado.${NC}"
        else
            echo -e "${AMARILLO}Operación cancelada.${NC}"
        fi
    else
        echo -e "${ROJO}El script no está configurado para autoiniciarse.${NC}"
        echo -e "${AMARILLO}¿Desea activar esta configuración? (s/n):${NC}"
        read -p "Opción: " opcion
        if [[ "$opcion" =~ ^[sS]$ ]]; then
            cp /etc/bash.bashrc /etc/bash.bashrc.bak
            echo '/etc/vpsmanager/adm.sh' >>/etc/bash.bashrc
            echo -e "${VERDE}Autoinicio del script activado.${NC}"
        else
            echo -e "${AMARILLO}Operación cancelada.${NC}"
        fi
    fi

    read -p "Presione Enter para continuar..."
}
