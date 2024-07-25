#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

mostrarPuertosActivos() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Puertos Activos${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Obtener los puertos activos con ss
    ss -tuln | awk 'NR>1 {print $1, $5}' | sed 's/.*://g' | sort -u >/tmp/active_ports.txt

    echo -e "${AMARILLO}Protocolo\tPuerto\tServicio${NC}" >/tmp/port_details.txt

    # Leer cada puerto activo y encontrar el servicio asociado
    while read -r line; do
        protocol=$(echo $line | awk '{print $1}')
        port=$(echo $line | awk '{print $2}')

        # Encontrar el servicio usando lsof
        service=$(sudo lsof -i :$port | awk 'NR==2 {print $1}')
        if [ -z "$service" ]; then
            service="Desconocido"
        fi

        echo -e "${BLANCO}$protocol\t$port\t${AMARILLO}$service${NC}" >>/tmp/port_details.txt
    done </tmp/active_ports.txt

    # Mostrar la tabla formateada
    column -t -s $'\t' /tmp/port_details.txt
    rm /tmp/active_ports.txt /tmp/port_details.txt

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}
