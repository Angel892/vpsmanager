#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

monitorear_recursos() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    Monitorear Recursos${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${SECUNDARIO}1. Uso de CPU${NC}"
        echo -e "${SECUNDARIO}2. Uso de Memoria${NC}"
        echo -e "${SECUNDARIO}3. Uso de Disco${NC}"
        echo -e "${SALIR}0. Regresar al menú principal${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1)
            echo -e "${INFO}Uso de CPU:${NC}"
            top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
            read -p "Presione Enter para continuar..."
            ;;
        2)
            echo -e "${INFO}Uso de Memoria:${NC}"
            free -m | awk 'NR==2{printf "Uso de Memoria: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
            read -p "Presione Enter para continuar..."
            ;;
        3)
            echo -e "${INFO}Uso de Disco:${NC}"
            df -h | awk '$NF=="/"{printf "Uso de Disco: %d/%dGB (%s)\n", $3,$2,$5}'
            read -p "Presione Enter para continuar..."
            ;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
