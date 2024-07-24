#!/bin/bash

actualizar_script() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m  Actualizando el Script\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    cd /etc/vpsmanager

    # Elimina el script antiguo (opcional)
    sudo rm /etc/vpsmanager/adm.sh

    # Obtener el ID del último commit
    OWNER="Angel892"
    REPO="vpsmanager"
    BRANCH="master"

    # Hacer una solicitud a la API de GitHub para obtener el último commit en la rama especificada
    LATEST_COMMIT=$(curl -s https://api.github.com/repos/$OWNER/$REPO/commits/$BRANCH | jq -r '.sha')

    sudo wget -O /etc/vpsmanager/adm.sh https://raw.githubusercontent.com/$OWNER/$REPO/$LATEST_COMMIT/adm.sh
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló la actualización del script.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi
    sudo chmod +x /etc/vpsmanager/adm.sh
    echo -e "\e[1;32mEl script se ha actualizado correctamente.\e[0m"
    read -p "Presione Enter para continuar..."
    exec /etc/vpsmanager/adm.sh
}
