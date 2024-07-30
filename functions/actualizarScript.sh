#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"



actualizar_script() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Actualizando el Script${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    
    cd /etc/vpsmanager

    # Restablecer cualquier cambio local y obtener las actualizaciones más recientes
    sudo git fetch --all
    if [ $? -ne 0 ]; then
        echo -e "${SALIR}Error: Falló la obtención de las actualizaciones del repositorio.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    sudo git reset --hard origin/master
    if [ $? -ne 0 ]; then
        echo -e "${SALIR}Error: Falló el restablecimiento del repositorio.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    # Asignar permisos de ejecución al script principal y a los scripts de funciones
    sudo find /etc/vpsmanager/ -type f -name "*.sh" -exec chmod +x {} \;
    if [ $? -ne 0 ]; then
        echo -e "${SALIR}Error: No se pudieron asignar los permisos de ejecución.${NC}"
        read -p "Presione Enter para continuar..."
        return
    fi

    echo -e "${SECUNDARIO}El script se ha actualizado correctamente.${NC}"
    read -p "Presione Enter para continuar..."
    exec /etc/vpsmanager/adm.sh
}