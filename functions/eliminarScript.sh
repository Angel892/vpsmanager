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

        alias1="/usr/bin/adm"
        alias2="/usr/bin/ADM"

        if [ -e "$alias1" ]; then
            sudo rm $alias1
        fi

        if [ -e "$alias2" ]; then
            sudo rm $alias2
        fi

        echo -e "${SECUNDARIO}Todos los archivos y configuraciones han sido eliminados.${NC}"
        exit 0
    else
        echo -e "${INFO}Operación cancelada.${NC}"
        read -p "Presione Enter para continuar..."
    fi
}
