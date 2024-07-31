#!/bin/bash

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
source $SSH_PATH/renovarCuentas.sh
source $SSH_PATH/limitador.sh

menuSSH() {

    mostrar_usuarios() {
        #for u in $(awk -F : '$3 > 900 { print $1 }' /etc/passwd | grep -v "nobody" | grep -vi polkitd | grep -vi system-); do
        #    echo "$u"
        #done

        for u in $(cat $mainPath/cuentassh | cut -d'|' -f1); do
            echo "$u"
        done
    }

    unlockall2() {
        for user in $(cat /etc/passwd | awk -F : '$3 > 900 {print $1}' | grep -v "rick" | grep -vi "nobody"); do
            userpid=$(ps -u $user | awk {'print $1'})

            usermod -U $user &>/dev/null
        done
    }

    

    rm_user() {
        userdel --force "$1" &>/dev/null
    }

    local num=1

    showCabezera "SSH MANAGER"

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

    # EDITAR USUARIO
    opcionMenu -blanco $num "Renovar cuenta"
    option[$num]="renovar"
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

    # LIMITADOR DE CUENTAS

    VERY="$(ps aux | grep "${mainPath}/helpers/limitador.sh" | grep -v grep)"
    [[ -z ${VERY} ]] && verificar="\e[1;93m[\033[1;31m DESACTIVADO \e[1;93m]" || verificar="\e[1;93m[\033[1;32m ACTIVO \e[1;93m]"
    opcionMenu -blanco $num "Limitador de cuentas" false 2 && echo -e "${verificar}"
    option[$num]="limitador"
    let num++

    msg -bar

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
    "renovar") renovarCuentaSSH ;;
    "limitador") limitadorMenu ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuSSH
}
