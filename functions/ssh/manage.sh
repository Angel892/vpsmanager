#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#colores
source $HELPERS_PATH/colors.sh
#funciones globales
source $HELPERS_PATH/global.sh

local MENU="SSH"

SSH_PATH="/etc/vpsmanager/functions/ssh"

#ARCHIVOS NECESARIOS
source $SSH_PATH/crearCuenta.sh
source $SSH_PATH/detalleUsuarios.sh
source $SSH_PATH/removerUsuario.sh
source $SSH_PATH/bloquearCuenta.sh
source $SSH_PATH/editarCuenta.sh
source $SSH_PATH/usuariosConectados.sh
source $SSH_PATH/eliminarVencidos.sh
source $SSH_PATH/backup.sh
source $SSH_PATH/eliminarTodos.sh

menuSSH() {
    while true; do

        local num=1

        clear
        msg -bar
        msgCentrado -ama "SSH MANAGER"
        msg -bar

        # CREAR CUENTA
        echo -e "${SECUNDARIO}$num. Crear cuenta${NC}"
        option[$num]="crear"
        let num++

        # CREAR CUENTA TEMPORAL
        echo -e "${SECUNDARIO}$num. Crear cuenta temporal${NC}"
        option[$num]="crearTemporal"
        let num++

        # REMOVER USUARIO
        echo -e "${SECUNDARIO}$num. Remover usuario${NC}"
        option[$num]="remover"
        let num++

        # BLOQUEAR USUARIO
        echo -e "${SECUNDARIO}$num. Bloquear / Desbloquear usuario${NC}"
        option[$num]="bloquear"
        let num++

        # EDITAR USUARIO
        echo -e "${SECUNDARIO}$num. Editar cuenta${NC}"
        option[$num]="editar"
        let num++

        # DETALLES
        echo -e "${SECUNDARIO}$num. Detalle de todos los usuarios${NC}"
        option[$num]="detalles"
        let num++

        # USUARIOS CONECTADOS
        echo -e "${SECUNDARIO}$num. Usuarios conectados${NC}"
        option[$num]="conectados"
        let num++

        # ELIMINAR USUARIOS VENCIDOS
        echo -e "${SECUNDARIO}$num. Eliminar usuarios vencidos${NC}"
        option[$num]="eliminarVencidos"
        let num++

        # BACKUP
        echo -e "${SECUNDARIO}$num. Backup de usuarios${NC}"
        option[$num]="backup"
        let num++

        # BANNER
        echo -e "${SECUNDARIO}$num. Agregar / Eliminar banner${NC}"
        option[$num]="banner"
        let num++

        # ELIMINAR TODOS LOS USUARIOS
        echo -e "${SECUNDARIO}$num. Eliminar todos los usuarios${NC}"
        option[$num]="eliminarTodos"
        let num++

        echo -e "${SALIR}0. Regresar al menú anterior${NC}"
        option[0]="volver"

        msg -bar
        selection=$(selectionFun $num)
        case ${option[$selection]} in
        "crear") crearCuentaSSH;;
        "crearTemporal") crearCuentaTemporalSSH;;
        "remover") removerUsuarioSSH;;
        "bloquear") bloquearDesbloquearUsuarioSSH;;
        "editar") editarCuentaSSH;;
        "detalles") detalleUsuariosSSH;;
        "conectados") usuariosConectadosSSH;;
        "eliminarVencidos") eliminarUsuariosVencidosSSH;;
        "backup") backupUsuariosSSH;;
        "banner") gestionarBannerSSH;;
        "eliminarTodos") eliminarTodosUsuariosSSH;;
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
