#!/bin/bash

eliminar_script() {
    clear
    echo -e "\e[1;31m=========================\e[0m"
    echo -e "\e[1;31m  Eliminando el Script\e[0m"
    echo -e "\e[1;31m=========================\e[0m"
    read -p "¿Está seguro de que desea eliminar todos los scripts y archivos relacionados? (s/n): " confirmar
    if [[ $confirmar == [sS] ]]; then
        # Eliminar el directorio /etc/vpsmanager
        sudo rm -rf /etc/vpsmanager
        
        # Eliminar alias
        sed -i '/alias adm=/d' ~/.bashrc
        sed -i '/alias adm=/d' ~/.bash_profile
        sed -i '/alias adm=/d' ~/.zshrc
        
        # Aplicar cambios en el archivo de configuración del shell
        source ~/.bashrc
        source ~/.bash_profile
        source ~/.zshrc
        
        echo -e "\e[1;32mTodos los archivos y configuraciones han sido eliminados.\e[0m"
        exit 0
    else
        echo -e "\e[1;33mOperación cancelada.\e[0m"
        read -p "Presione Enter para continuar..."
    fi
}
