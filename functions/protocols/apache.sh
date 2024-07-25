#!/bin/bash

install_apache() {
    echo -e "\e[1;33mInstalando Apache...\e[0m"
    sudo apt-get update
    sudo apt-get install -y apache2
    echo -e "\e[1;32mApache instalado.\e[0m"
    read -p "Presione Enter para continuar..."

}
