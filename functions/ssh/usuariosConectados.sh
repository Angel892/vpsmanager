#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

usuariosConectadosSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Usuarios Conectados SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Obtener la lista de usuarios conectados y el número de conexiones
    connected_users=$(who | awk '{print $1}' | sort | uniq -c | sort -nr)

    if [ -z "$connected_users" ]; then
        echo -e "${ROJO}No hay usuarios SSH conectados actualmente.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    # Crear un archivo temporal para la tabla de usuarios conectados
    user_connections="/tmp/user_connections.txt"
    echo -e "N°\tUsuario\tConexiones" > $user_connections
    count=1

    while read -r connections username; do
        echo -e "$count\t$username\t$connections" >> $user_connections
        count=$((count + 1))
    done <<< "$connected_users"

    # Mostrar la tabla formateada
    column -t -s $'\t' $user_connections
    rm $user_connections

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}