#!/bin/bash

menuNodeJS() {

    install() {
        showCabezera "INSTALACION NODE JS"

        # Instalar Node.js
        msgInstall -blanco "Instalando node js"
        barra_intall "apt-get install nodejs -y"

        # Instalar npm
        msgInstall -blanco "Instalando npm"
        barra_intall "apt-get install npm -y"

        msgSuccess
    }

    uninstall() {
        showCabezera "DESINSTALACION NODE JS"

        # Eliminar Node.js y npm
        msgInstall -blanco "Removiendo dependencias"
        barra_intallb " sudo apt-get remove --purge -y nodejs npm"

        # Limpiar dependencias no necesarias
        msgInstall -blanco "Limpiando dependencias sin usar"
        barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        msgSuccess
    }

    local num=1

    showCabezera "MENU NODE JS"

    # INSTALAR
    opcionMenu -blanco $num "Instalar node js"
    option[$num]="install"
    let num++

    # DESINSTALAR
    opcionMenu -blanco $num "Desinstalar node js"
    option[$num]="uninstall"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "install") install ;;
    "uninstall") uninstall ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuNodeJS
}
