#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

MENU="SSH"

SSH_PATH="/etc/vpsmanager/functions/ssh"

#ARCHIVOS NECESARIOS
source $SSH_PATH/crearCuenta.sh
source $SSH_PATH/detalleUsuarios.sh
source $SSH_PATH/removerUsuario.sh
source $SSH_PATH/bloquearCuenta.sh

menuSSH() {
    while true; do
        clear
        echo -e "${PRINCIPAL}=========================${NC}"
        echo -e "${PRINCIPAL}    $MENU smanager${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"

        echo -e "${SECUNDARIO}1. Crear cuenta $MENU${NC}"
        echo -e "${SECUNDARIO}2. Crear cuenta temporal $MENU${NC}"
        echo -e "${SECUNDARIO}3. Remover usuario $MENU${NC}"
        echo -e "${SECUNDARIO}4. Bloquear / Desbloquear usuario $MENU${NC}"
        echo -e "${SECUNDARIO}5. Editar cuenta $MENU${NC}"
        echo -e "${SECUNDARIO}6. Renovar cuenta $MENU${NC}"
        echo -e "${SECUNDARIO}7. Detalle de todos los usuarios $MENU${NC}"
        echo -e "${SECUNDARIO}8. Usuarios conectados $MENU${NC}"
        echo -e "${SECUNDARIO}9. Eliminar usuarios vencidos $MENU${NC}"
        echo -e "${SECUNDARIO}10. Backup de usuarios $MENU${NC}"
        echo -e "${SECUNDARIO}11. Agregar / Eliminar banner $MENU${NC}"
        echo -e "${SECUNDARIO}12. Eliminar todos los usuarios $MENU${NC}"

        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1) crearCuentaSSH;;
        2) crearCuentaTemporalSSH;;
        3) removerUsuarioSSH;;
        4) bloquearDesbloquearUsuarioSSH;;
        5) editarCuentaSSH;;
        6) renovarCuentaSSH;;
        7) detalleUsuariosSSH;;
        8) usuariosConectadosSSH;;
        9) eliminarUsuariosVencidosSSH;;
        10) backupUsuariosSSH;;
        11) gestionarBannerSSH;;
        12) eliminarTodosUsuariosSSH;;
        0) break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
