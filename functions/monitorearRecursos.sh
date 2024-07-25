#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

monitorear_recursos() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}    Monitorear Recursos${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    
    # Uso de CPU
    echo -e "${INFO}Uso de CPU:${NC}"
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    cpu_cores=$(grep -c ^processor /proc/cpuinfo)
    echo -e "\033[1;31m PROCESADOR: \033[1;37mNUCLEOS: \033[1;32m$cpu_cores         \033[1;37mUSO DE CPU: \033[1;32m$cpu_usage"

    # Uso de Memoria
    echo -e "${INFO}Uso de Memoria:${NC}"
    mem_total=$(free -h | grep -i mem | awk {'print $2'})
    mem_used=$(free -h | grep -i mem | awk {'print $3'})
    mem_free=$(free -h | grep -i mem | awk {'print $4'})
    mem_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
    echo -e "\033[1;31m LA MEMORIA RAM SE ENCUENTRA AL: \033[1;32m$mem_usage"
    echo -e "\033[1;31m DETALLE RAM: \033[1;37mTOTAL: \033[1;32m$mem_total  \033[1;37mUSADO: \033[1;32m$mem_used  \033[1;37mLIBRE: \033[1;32m$mem_free"

    # Uso de Disco
    echo -e "${INFO}Uso de Disco:${NC}"
    disk_usage=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')
    echo -e "\033[1;31m USO DE DISCO: \033[1;32m$disk_usage"

    # Información del Sistema
    os_system() {
        system=$(cat /etc/issue | head -n 1)
        echo $system
    }
    ip=$(hostname -I | awk '{print $1}')
    echo -ne " SO: " && echo -ne "\033[1;37m$(os_system)  "
    echo ""
    echo -ne " IP: " && echo -e "\033[1;37m$ip"
    
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}