#!/bin/bash

actualizar_script() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m  Actualizando el Script\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    cd /etc/vpsmanager

    # Obtener el ID del último commit
    OWNER="Angel892"
    REPO="vpsmanager"
    BRANCH="master"

    # Hacer una solicitud a la API de GitHub para obtener el último commit en la rama especificada
    LATEST_COMMIT=$(curl -s https://api.github.com/repos/$OWNER/$REPO/commits/$BRANCH | jq -r '.[0].sha')

    # Descargar el repositorio completo
    sudo rm -rf /tmp/vpsmanager
    sudo git clone https://github.com/$OWNER/$REPO.git /tmp/vpsmanager
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló la clonación del repositorio.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi

    # Copiar los archivos al directorio de destino
    sudo cp -r /tmp/vpsmanager/* /etc/vpsmanager/
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló la copia de los archivos.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi

    # Asignar permisos de ejecución al script principal y los archivos de funciones
    sudo chmod +x /etc/vpsmanager/adm.sh
    sudo chmod +x /etc/vpsmanager/funciones/*.sh
    echo -e "\e[1;32mEl script se ha actualizado correctamente.\e[0m"
    read -p "Presione Enter para continuar..."
    exec /etc/vpsmanager/adm.sh
}