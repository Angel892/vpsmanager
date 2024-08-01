#!/bin/bash

V2RAY_PATH="$functionsPath/v2ray"

#ARCHIVOS NECESARIOS

menuv2ray() {

    showCabezera "CONTROLADOR DE V2RAY (WEBSOCKET+TLS)"
    msgCentrado -blanco "Estado actual: "
    msg -bar

    local num=1

    # CREAR CUENTA
    opcionMenu -blanco $num "Instalar v2ray" false 2
    option[$num]="install"
    let num++

    # CREAR CUENTA TEMPORAL
    opcionMenu -blanco $num "Cambiar protocolo"
    option[$num]="changeProtocol"
    let num++

    # REMOVER USUARIO
    opcionMenu -blanco $num "Activar tls" false 4
    option[$num]="tls"
    let num++

    # BLOQUEAR USUARIO
    opcionMenu -blanco $num "Cambiar puerto"
    option[$num]="changePort"
    let num++

    # EDITAR USUARIO
    opcionMenu -blanco $num "Cambiar nombre de path"
    option[$num]="changePathName"
    let num++

    msgCentradoBarra -gris "Administrar cuentas"

    # EDITAR USUARIO
    opcionMenu -blanco $num "Agregar usuario uuid"
    option[$num]="addUser"
    let num++

    # DETALLES
    opcionMenu -blanco $num "Eliminar usuario uuid"
    option[$num]="removeUser"
    let num++

    # USUARIOS CONECTADOS
    opcionMenu -blanco $num "Mostrar usuarios registrados"
    option[$num]="showUser"
    let num++

    # ELIMINAR USUARIOS VENCIDOS
    opcionMenu -blanco $num "Informacion de cuentas"
    option[$num]="infoUsers"
    let num++

    # BACKUP
    opcionMenu -blanco $num "Estadisticas de consumo"
    option[$num]="estads"
    let num++

    # BANNER
    opcionMenu -blanco $num "Limpiador de expirados"
    option[$num]="removeExp"
    let num++

    # ELIMINAR TODOS LOS USUARIOS
    opcionMenu -blanco $num "Backup / base user y json"
    option[$num]="backup"
    let num++

    # ELIMINAR TODOS LOS USUARIOS
    opcionMenu -rojo $num "Desinstalar v2ray"
    option[$num]="uninstall"
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
    "desbloqueoAutomatico") desbloqueoAutomatico ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuv2ray
}
