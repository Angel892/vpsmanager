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
    PS3="Seleccione el número del usuario que desea eliminar: "

    select username in $users; do
        if [ -n "$username" ]; then
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
            break
        else
            echo -e "${ROJO}Selección inválida. Por favor intente de nuevo.${NC}"
        fi
    done

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}