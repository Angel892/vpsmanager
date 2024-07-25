#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"
# Enable debugging
#set -x

#colores
source $HELPERS_PATH/colors.sh

MAIN_PATH="/etc/vpsmanager/functions";

# Incluir los archivos de funciones
source $MAIN_PATH/actualizarScript.sh
source $MAIN_PATH/ssh/manage.sh
source $MAIN_PATH/eliminarScript.sh
source $MAIN_PATH/protocols/manage.sh
source $MAIN_PATH/monitorearRecursos.sh
source $MAIN_PATH/autoiniciarScript.sh
source $MAIN_PATH/puertosActivos.sh

mostrar_menu() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}   Administrador de VPS${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${SECUNDARIO}1. SSH / OPEN VPN${NC}"
        echo -e "${SECUNDARIO}2. Administrar Protocolos${NC}"
        echo -e "${SECUNDARIO}3. Monitorear Recursos${NC}"
        echo -e "${SECUNDARIO}4. Actualizar Script${NC}"
        echo -e "${SECUNDARIO}5. Eliminar Script${NC}"
        echo -e "${SECUNDARIO}6. Autoiniciar Script${NC}"
        echo -e "${SECUNDARIO}7. Puertos activos${NC}"
        echo -e "${SALIR}0. Salir${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) menuSSH;;
        2) menuProtocols ;;
        3) monitorear_recursos ;;
        4) actualizar_script ;;
        5) eliminar_script ;;
        6) autoiniciarScript ;;
        7) puertosActivos ;;
        0)
            echo -e "${INFO}Saliendo...${NC}"
            exit 0
            ;;
        *) 
            echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" 
            ;;
        esac

        read -p "Seleccione una opción: " opcion
    done
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mostrar_menu
