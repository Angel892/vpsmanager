#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


gestionarBannerSSH() {
    read -p "1. Agregar banner\n2. Eliminar banner\nSeleccione una opción: " opcion
    if [ $opcion -eq 1 ]; then
        read -p "Ingrese el mensaje del banner: " banner
        echo $banner | sudo tee /etc/issue.net
        echo "Banner /etc/issue.net" | sudo tee -a /etc/ssh/sshd_config
        sudo systemctl restart sshd
        echo -e "${VERDE}Banner agregado.${NC}"
    elif [ $opcion -eq 2 ]; then
        sudo sed -i '/Banner \/etc\/issue.net/d' /etc/ssh/sshd_config
        sudo rm /etc/issue.net
        sudo systemctl restart sshd
        echo -e "${VERDE}Banner eliminado.${NC}"
    else
        echo -e "${ROJO}Opción inválida.${NC}"
    fi
    read -p "Presione Enter para continuar..."
}