#!/bin/bash

local MENU="SSH"

SSH_PATH="$functionsPath/ssh"

#ARCHIVOS NECESARIOS
source $SSH_PATH/crearCuenta.sh
source $SSH_PATH/cuentaTemporal.sh
source $SSH_PATH/detalleUsuarios.sh
source $SSH_PATH/removerUsuario.sh
source $SSH_PATH/bloquearCuenta.sh
source $SSH_PATH/editarCuenta.sh
source $SSH_PATH/usuariosConectados.sh
source $SSH_PATH/eliminarVencidos.sh
source $SSH_PATH/backup.sh
source $SSH_PATH/eliminarTodos.sh

menuSSH() {

    unlockall2() {
        for user in $(cat /etc/passwd | awk -F : '$3 > 900 {print $1}' | grep -v "rick" | grep -vi "nobody"); do
            userpid=$(ps -u $user | awk {'print $1'})

            usermod -U $user &>/dev/null
        done
    }

    while true; do

        local num=1

        clear
        msg -bar
        msgCentrado -amarillo "SSH MANAGER"
        msg -bar

        # CREAR CUENTA
        opcionMenu -blanco $num "Crear cuenta"
        option[$num]="crear"
        let num++

        # CREAR CUENTA TEMPORAL
        opcionMenu -blanco $num "Crear cuenta temporal"
        option[$num]="crearTemporal"
        let num++

        # REMOVER USUARIO
        opcionMenu -blanco $num "Remover usuario"
        option[$num]="remover"
        let num++

        # BLOQUEAR USUARIO
        opcionMenu -blanco $num "Bloquear / Desbloquear usuario"
        option[$num]="bloquear"
        let num++

        # EDITAR USUARIO
        opcionMenu -blanco $num "Editar cuenta"
        option[$num]="editar"
        let num++

        # DETALLES
        opcionMenu -blanco $num "Detalle de todos los usuarios"
        option[$num]="detalles"
        let num++

        # USUARIOS CONECTADOS
        opcionMenu -blanco $num "Usuarios conectados"
        option[$num]="conectados"
        let num++

        # ELIMINAR USUARIOS VENCIDOS
        opcionMenu -blanco $num "Eliminar usuarios vencidos"
        option[$num]="eliminarVencidos"
        let num++

        # BACKUP
        opcionMenu -blanco $num "Backup de usuarios"
        option[$num]="backup"
        let num++

        # BANNER
        opcionMenu -blanco $num "Agregar / Eliminar banner"
        option[$num]="banner"
        let num++

        # ELIMINAR TODOS LOS USUARIOS
        opcionMenu -blanco $num "Eliminar todos los usuarios"
        option[$num]="eliminarTodos"
        let num++

        # SALIR
        opcionMenu -rojo 0 "Regresar al menú anterior"
        option[0]="volver"

        msg -bar
        selection=$(selectionFun $num)
        case ${option[$selection]} in
        "crear") crearCuentaSSH ;;
        "crearTemporal") crearCuentaTemporalSSH ;;
        "remover") removerUsuarioSSH ;;
        "bloquear") bloquearDesbloquearUsuarioSSH ;;
        "editar") editarCuentaSSH ;;
        "detalles") detalleUsuariosSSH ;;
        "conectados") usuariosConectadosSSH ;;
        "eliminarVencidos") eliminarUsuariosVencidosSSH ;;
        "backup") backupUsuariosSSH ;;
        "banner") gestionarBannerSSH ;;
        "eliminarTodos") eliminarTodosUsuariosSSH ;;
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
        esac
    done
}
