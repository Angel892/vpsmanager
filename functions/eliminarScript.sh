#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"



eliminar_script() {
    clear
    echo -e "${SALIR}=========================${NC}"
    echo -e "${SALIR}  Eliminando el Script${NC}"
    echo -e "${SALIR}=========================${NC}"
    read -p "¿Está seguro de que desea eliminar todos los scripts y archivos relacionados? (s/n): " confirmar
    if [[ $confirmar == [sS] ]]; then
        # Verificar si el directorio /etc/vpsmanager existe
        if [ -d "/etc/vpsmanager" ]; then
            sudo rm -rf /etc/vpsmanager
            echo -e "${SECUNDARIO}Directorio /etc/vpsmanager eliminado.${NC}"
        else
            echo -e "${INFO}El directorio /etc/vpsmanager no existe.${NC}"
        fi
        
        # Eliminar alias si existen
        if grep -q 'alias adm=' ~/.bashrc; then
            sed -i '/alias adm=/d' ~/.bashrc
            echo -e "${SECUNDARIO}Alias eliminado de ~/.bashrc.${NC}"
        fi

        if grep -q 'alias adm=' ~/.bash_profile; then
            sed -i '/alias adm=/d' ~/.bash_profile
            echo -e "${SECUNDARIO}Alias eliminado de ~/.bash_profile.${NC}"
        fi

        if grep -q 'alias adm=' ~/.zshrc; then
            sed -i '/alias adm=/d' ~/.zshrc
            echo -e "${SECUNDARIO}Alias eliminado de ~/.zshrc.${NC}"
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
        
        echo -e "${SECUNDARIO}Todos los archivos y configuraciones han sido eliminados.${NC}"
        exit 0
    else
        echo -e "${INFO}Operación cancelada.${NC}"
        read -p "Presione Enter para continuar..."
    fi
}
