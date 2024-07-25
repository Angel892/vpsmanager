#!/bin/bash

actualizar_script() {
    clear
    echo -e "\e[1;34m=========================\e[0m"
    echo -e "\e[1;34m  Actualizando el Script\e[0m"
    echo -e "\e[1;34m=========================\e[0m"
    
    cd /etc/vpsmanager

    # Restablecer cualquier cambio local y obtener las actualizaciones más recientes
    sudo git fetch --all
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló la obtención de las actualizaciones del repositorio.\e[0m"
        read -p "Presione Enter para continuar..."
        return
    fi

    sudo git reset --hard origin/master
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Falló el restablecimiento del repositorio.\e[0m"
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