#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


eliminarUsuariosVencidosSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Eliminar Usuarios SSH Vencidos${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    if [ ! -f /etc/vpsmanager/users.txt ]; then
        echo -e "${ROJO}No hay usuarios registrados.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    users=$(cat /etc/vpsmanager/users.txt)
    current_date=$(date +%Y-%m-%d)

    if [ -z "$users" ]; then
        echo -e "${ROJO}No hay usuarios registrados.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    expired_users=0
    to_delete=()

    while IFS=: read -r username password expiration_date limit; do
        if [ "$expiration_date" != "never" ]; then
            expiration_seconds=$(date -d "$expiration_date" +%s)
            current_seconds=$(date -d "$current_date" +%s)
            if [ $current_seconds -gt $expiration_seconds ]; then
                to_delete+=("$username")
                expired_users=$((expired_users + 1))
            fi
        fi
    done <<< "$users"

    if [ $expired_users -eq 0 ]; then
        echo -e "${AMARILLO}No se encontraron usuarios vencidos para eliminar.${NC}"
    else
        echo -e "${ROJO}Usuarios vencidos a eliminar:${NC}"
        for username in "${to_delete[@]}"; do
            echo -e "${ROJO}- $username${NC}"
        done

        read -p "¿Está seguro que desea eliminar estos usuarios? (s/n): " confirm
        if [[ $confirm =~ ^[sS][iI]|[sS]$ ]]; then
            for username in "${to_delete[@]}"; do
                sudo deluser --remove-home "$username"
                if [ $? -eq 0 ]; then
                    sudo sed -i "/^$username:/d" /etc/vpsmanager/users.txt
                    echo -e "${VERDE}Usuario SSH '$username' eliminado.${NC}"
                else
                    echo -e "${ROJO}Error al eliminar el usuario '$username'.${NC}"
                fi
            done
            echo -e "${VERDE}$expired_users usuarios vencidos eliminados.${NC}"
        else
            echo -e "${AMARILLO}Operación cancelada.${NC}"
        fi
    fi

    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}