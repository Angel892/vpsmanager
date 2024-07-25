#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager"

detalleUsuariosSSH() {
    clear
    echo -e "${AMARILLO}=========================${NC}"
    echo -e "${AMARILLO} INFORMACION DE USUARIOS REGISTRADOS${NC}"
    echo -e "${AMARILLO}=========================${NC}"

    # Encabezados de la tabla
    echo -e "${BLANCO}USUARIO\tCONTRASEÑA\tFECHA\t\tLIMITE${NC}" > /tmp/user_details.txt

    # Recorrer cada usuario en /etc/passwd
    while IFS=: read -r username _ _ _ _ _ home _; do
        # Obtener la fecha de expiración
        expiration_date=$(sudo chage -l "$username" | grep "Account expires" | awk -F": " '{print $2}')
        
        # Calcular los días restantes
        if [ "$expiration_date" != "never" ]; then
            expiration_days=$(( ($(date -d "$expiration_date" +%s) - $(date +%s)) / 86400 ))
            expiration_info="$expiration_date [${VERDE}$expiration_days días${NC}]"
        else
            expiration_info="Nunca"
        fi

        # Obtener el límite de conexiones
        connection_limit=$(sudo grep "$username" /etc/security/limits.conf | grep "maxlogins" | awk '{print $4}')
        
        if [ -z "$connection_limit" ]; then
            connection_limit="${ROJO}Sin límite${NC}"
        fi
        
        # Obtener la contraseña del usuario (solo para mostrarla de manera segura en este ejemplo)
        # Nota: No es una práctica recomendada mostrar contraseñas
        user_password="********"
        
        # Agregar los detalles del usuario al archivo temporal
        echo -e "${BLANCO}$username\t$user_password\t$expiration_info\t$connection_limit${NC}" >> /tmp/user_details.txt
    done < /etc/passwd

    # Mostrar la tabla formateada
    column -t -s $'\t' /tmp/user_details.txt
    rm /tmp/user_details.txt

    echo -e "${AMARILLO}=========================${NC}"
    read -p "Presione Enter para continuar..."
}