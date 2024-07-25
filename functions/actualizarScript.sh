#!/bin/bash

actualizar_script() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m  Actualizando el Script\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    
    cd /etc/vpsmanager

    # Realizar git pull para actualizar el repositorio
    sudo git pull
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló la actualización del script.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi

    # Asignar permisos de ejecución al script principal y a los scripts de funciones
    sudo find /etc/vpsmanager/ -type f -name "*.sh" -exec chmod +x {} \;
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: No se pudieron asignar los permisos de ejecución.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "\e[1;32mEl script se ha actualizado correctamente.\e[0m"
    read -p "Presione Enter para continuar..."
    exec /etc/vpsmanager/adm.sh
}