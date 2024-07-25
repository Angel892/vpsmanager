#!/bin/bash

eliminar_script() {
    clear
    echo -e "\e[1;31m=========================\e[0m"
    echo -e "\e[1;31m  Eliminando el Script\e[0m"
    echo -e "\e[1;31m=========================\e[0m"
    read -p "¿Está seguro de que desea eliminar todos los scripts y archivos relacionados? (s/n): " confirmar
    if [[ $confirmar == [sS] ]]; then
        # Verificar si el directorio /etc/vpsmanager existe
        if [ -d "/etc/vpsmanager" ]; then
            sudo rm -rf /etc/vpsmanager
            echo -e "\e[1;32mDirectorio /etc/vpsmanager eliminado.\e[0m"
        else
            echo -e "\e[1;33mEl directorio /etc/vpsmanager no existe.\e[0m"
        fi
        
        # Eliminar alias si existen
        if grep -q 'alias adm=' ~/.bashrc; then
            sed -i '/alias adm=/d' ~/.bashrc
            echo -e "\e[1;32mAlias eliminado de ~/.bashrc.\e[0m"
        fi

        if grep -q 'alias adm=' ~/.bash_profile; then
            sed -i '/alias adm=/d' ~/.bash_profile
            echo -e "\e[1;32mAlias eliminado de ~/.bash_profile.\e[0m"
        fi

        if grep -q 'alias adm=' ~/.zshrc; then
            sed -i '/alias adm=/d' ~/.zshrc
            echo -e "\e[1;32mAlias eliminado de ~/.zshrc.\e[0m"
        fi
        
        # Aplicar cambios en el archivo de configuración del shell
        if [ -f ~/.bashrc ]; then
            source ~/.bashrc
        fi

        if [ -f ~/.bash_profile ]; then
            source ~/.bash_profile
        fi

        if [ -f ~/.zshrc ]; then
            source ~/.zshrc
        fi
        
        echo -e "\e[1;32mTodos los archivos y configuraciones han sido eliminados.\e[0m"
        exit 0
    else
        echo -e "\e[1;33mOperación cancelada.\e[0m"
        read -p "Presione Enter para continuar..."
    fi
}
