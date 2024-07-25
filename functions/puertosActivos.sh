#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

puertosActivos() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Puertos Activos${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Usar netstat para listar los puertos activos
    if command -v netstat > /dev/null; then
        netstat -tuln | awk 'NR>2 {print $1, $4}' | column -t
    elif command -v ss > /dev/null; then
        ss -tuln | awk 'NR>1 {print $1, $5}' | column -t
    else
        echo -e "${ROJO}Error: No se encontró netstat ni ss.${NC}"
    fi

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}