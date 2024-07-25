#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh

MAIN_PATH="/etc/vpsmanager/functions";

# Incluir los archivos de funciones
source $MAIN_PATH/actualizarScript.sh
source $MAIN_PATH/crearUsuarioSSH.sh
source $MAIN_PATH/eliminarScript.sh
source $MAIN_PATH/protocols/protocols.sh
source $MAIN_PATH/monitorearRecursos.sh

mostrar_menu() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}   Administrador de VPS${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${SECUNDARIO}1. Administrar Protocolos${NC}"
        echo -e "${SECUNDARIO}2. Crear Usuario SSH${NC}"
        echo -e "${SECUNDARIO}3. Monitorear Recursos${NC}"
        echo -e "${SECUNDARIO}4. Actualizar Script${NC}"
        echo -e "${SECUNDARIO}5. Eliminar Script${NC}"
        echo -e "${SALIR}0. Salir${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) menu_protocols ;;
        2) crear_usuario_ssh ;;
        3) monitorear_recursos ;;
        4) actualizar_script ;;
        5) eliminar_script ;;
        0)
            echo -e "${INFO}Saliendo...${NC}"
            exit 0
            ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}

# Bucle para mostrar el menú hasta que el usuario decida salir
mostrar_menu
