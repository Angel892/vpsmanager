#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

monitorear_recursos() {
    clear

    # Obtener información del sistema
    _core=$(grep -c ^processor /proc/cpuinfo)
    _usop=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    ram_total=$(free -h | grep -i mem | awk '{print $2}')
    ram_uso=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
    ram_libre=$(free -h | grep -i mem | awk '{print $4}')
    ram_usada=$(free -h | grep -i mem | awk '{print $3}')
    uso_disco=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')
    os_system=$(lsb_release -d | awk -F"\t" '{print $2}' | tr -d '\n')
    ip=$(hostname -I | awk '{print $1}')

    # Mostrar información
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}   Monitorización de Recursos${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${AMARILLO}Procesador: \033[1;37mNúcleos: \033[1;32m$_core         \033[1;37mUso de CPU: \033[1;32m$_usop${NC}"
    echo -e "${AMARILLO}La memoria RAM se encuentra al: \033[1;32m$ram_uso${NC}"
    echo -e "${AMARILLO}Detalle RAM: \033[1;37mTotal: \033[1;32m$ram_total  \033[1;37mUsado: \033[1;32m$ram_usada  \033[1;37mLibre: \033[1;32m$ram_libre${NC}"
    echo -e "${AMARILLO}Uso de Disco: \033[1;32m$uso_disco${NC}"
    echo -e "${AMARILLO}SO: \033[1;37m$os_system${NC}"
    echo -e "${AMARILLO}IP: \033[1;37m$ip${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    read -p "Presione Enter para continuar..."
}