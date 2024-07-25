#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager"

detalleUsuariosSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Detalles de usuarios SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Encabezados de la tabla
    echo -e "${AMARILLO}Usuario\tFecha de Expiración (Días Restantes)\tLímite de Conexiones${NC}" > /tmp/user_details.txt

    # Obtener todos los usuarios y sus detalles de una sola vez
    users=$(cut -d: -f1 /etc/passwd)
    limits=$(grep "maxlogins" /etc/security/limits.conf)

    for username in $users; do
        # Obtener la fecha de expiración
        expiration_date=$(sudo chage -l "$username" | grep "Account expires" | awk -F": " '{print $2}')
        
        # Calcular los días restantes
        if [ "$expiration_date" != "never" ]; then
            expiration_days=$(( ($(date -d "$expiration_date" +%s) - $(date +%s)) / 86400 ))
            expiration_info="$expiration_date[$expiration_days]"
        else
            expiration_info="Nunca"
        fi

        # Obtener el límite de conexiones
        connection_limit=$(echo "$limits" | grep "$username" | awk '{print $4}')
        
        if [ -z "$connection_limit" ]; then
            connection_limit="Sin límite"
        fi
        
        # Agregar los detalles del usuario al archivo temporal
        echo -e "${BLANCO}$username\t$expiration_info\t$connection_limit${NC}" >> /tmp/user_details.txt
    done

    # Mostrar la tabla formateada
    column -t -s $'\t' /tmp/user_details.txt
    rm /tmp/user_details.txt

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}