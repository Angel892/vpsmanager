#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MAIN_PATH="/etc/vpsmanager";

removerUsuarioSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Eliminar cuenta SSH${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    # Obtener la lista de usuarios del sistema (excluyendo usuarios del sistema)
    users=$(cut -d: -f1 /etc/passwd | grep -vE '^(root|daemon|bin|sys|sync|games|man|lp|mail|news|uucp|proxy|www-data|backup|list|irc|gnats|nobody|systemd|syslog|messagebus|_apt|lxd|uuidd|dnsmasq|landscape|pollinate|sshd|ftp|memcache|sysinfo|mysql|ntp|postfix|rpc|avahi|usbmux|rtkit|saned|colord|geoclue|pulse|speech-dispatcher|gdm|hplip|systemd-coredump|systemd-network|systemd-resolve|systemd-timesync)$')

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios SSH disponibles para eliminar.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "${AMARILLO}Usuarios disponibles:${NC}"
    
    # Crear un archivo temporal para la tabla de usuarios
    user_details="/tmp/user_details.txt"
    echo -e "N°\tUsuario" > $user_details
    count=1
    
    for username in $users; do
        echo -e "$count\t$username" >> $user_details
        count=$((count + 1))
    done

    # Mostrar la tabla de usuarios
    column -t -s $'\t' $user_details
    rm $user_details

    echo -e "${AMARILLO}Seleccione el número del usuario que desea eliminar:${NC}"
    read -p "Número: " user_num

    if ! [[ "$user_num" =~ ^[0-9]+$ ]] || [ "$user_num" -lt 1 ] || [ "$user_num" -ge $count ]; then
        echo -e "${ROJO}Selección inválida. Por favor intente de nuevo.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    username=$(echo "$users" | sed -n "${user_num}p")

    while true; do
        read -p "Está seguro que desea eliminar al usuario '$username'? (s/n): " confirm
        case $confirm in
            [sS][iI]|[sS])
                sudo deluser --remove-home "$username"
                if [ $? -eq 0 ]; then
                    echo -e "${VERDE}Usuario SSH '$username' eliminado exitosamente.${NC}"
                else
                    echo -e "${ROJO}Error: No se pudo eliminar al usuario '$username'.${NC}"
                fi
                break
                ;;
            [nN][oO]|[nN])
                echo -e "${AMARILLO}Operación cancelada.${NC}"
                break
                ;;
            *)
                echo -e "${ROJO}Error: Respuesta inválida. Por favor ingrese 's' o 'n'.${NC}"
                ;;
        esac
    done

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}