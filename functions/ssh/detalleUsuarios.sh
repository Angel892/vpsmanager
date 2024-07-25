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
    echo -e "Usuario\tFecha de Expiración\tLímite de Conexiones" > /tmp/user_details.txt

    # Recorrer cada usuario en /etc/passwd
    while IFS=: read -r username _ _ _ _ _ home _; do
        # Obtener la fecha de expiración
        expiration_date=$(sudo chage -l "$username" | grep "Account expires" | awk -F": " '{print $2}')
        # Obtener el límite de conexiones
        connection_limit=$(sudo grep "$username" /etc/security/limits.conf | grep "maxlogins" | awk '{print $4}')
        
        if [ -z "$connection_limit" ]; then
            connection_limit="Sin límite"
        fi
        
        # Agregar los detalles del usuario al archivo temporal
        echo -e "$username\t$expiration_date\t$connection_limit" >> /tmp/user_details.txt
    done < /etc/passwd

    # Mostrar la tabla formateada
    column -t -s $'\t' /tmp/user_details.txt
    rm /tmp/user_details.txt

    read -p "Presione Enter para continuar..."
}
