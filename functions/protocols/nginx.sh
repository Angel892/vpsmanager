#!/bin/bash

install_nginx() {
    echo -e "\e[1;33mInstalando Nginx...\e[0m"
    sudo apt-get update
    sudo apt-get install -y nginx
    echo -e "\e[1;32mNginx instalado.\e[0m"
    read -p "Presione Enter para continuar..."
}
