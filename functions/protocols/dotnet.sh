#!/bin/bash

menuDotnet() {
    install() {
        showCabezera "Instalacion DOTNET"

        local ubuntuVersion=$(lsb_release -r | awk '{print $2}' | cut -d. -f1)

        if [ "$ubuntuVersion" -lt 21 ]; then
            msgInstall -blanco "Version del sistema: $ubuntuVersion - añadiendo paquetes de microsoft"

            wget https://packages.microsoft.com/config/ubuntu/$ubuntuVersion/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            rm packages-microsoft-prod.deb
        fi

        msgInstall -blanco "Instalando SDK"
        apt-get install -y dotnet-sdk-8.0
        # barra_intall "apt-get install dotnet-sdk-8.0 -y"

        msgInstall -blanco "Instalando RUNTIME"
        apt-get install -y aspnetcore-runtime-8.0
        # barra_intall "apt-get install aspnetcore-runtime-8.0 -y"

        msgSuccess
    }

    uninstall() {
        showCabezera "DESINSTALACION dotnet"

        msgInstall -blanco "Removiendo dependencias"
        apt-get remove --purge -y dotnet-sdk-8.0
        # barra_intallb "apt-get remove --purge -y dotnet-sdk-8.0"

        # Desinstalar .NET Runtime
        msgInstall -blanco "Desinstalando runtime"
        apt-get remove --purge -y aspnetcore-runtime-8.0
        # barra_intallb "apt-get remove --purge -y aspnetcore-runtime-8.0"

        msgInstall -blanco "Limpiando dependencias sin usar"
        sudo apt-get autoremove -y && sudo apt-get autoclean -y
        # barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        msgSuccess
    }

    installef() {
        showCabezera "Instalacion dotnet ef"

        msgInstall -blanco "Instalando dotnet ef"
        dotnet tool install --global dotnet-ef
        # barra_intall "dotnet tool install --global dotnet-ef"

        msgSuccess
    }

    uninstallef() {
        showCabezera "DESINSTALACION dotnet ef"

        msgInstall -blanco "Removiendo dependencias"
        dotnet tool uninstall --global dotnet-ef
        # barra_intallb "dotnet tool uninstall --global dotnet-ef"

        msgInstall -blanco "Limpiando dependencias sin usar"
        sudo apt-get autoremove -y && sudo apt-get autoclean -y
        # barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"

        msgSuccess
    }

    local num=1

    showCabezera "MENU DOTNET"

    # INSTALAR DOTNET
    opcionMenu -blanco $num "Instalar dotnet"
    option[$num]="install"
    let num++

    # INSTALAR DOTNET EF
    opcionMenu -blanco $num "Instalar dotnet ef"
    option[$num]="installef"
    let num++

    # DESINSTALAR DOTNET
    opcionMenu -blanco $num "Desinstalar dotnet"
    option[$num]="uninstall"
    let num++

    # DESINSTALAR DOTNET EF
    opcionMenu -blanco $num "Desinstalar dotnet ef"
    option[$num]="uninstallef"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "install") install ;;
    "installef") installef ;;
    "uninstall") uninstall ;;
    "uninstallef") uninstallef ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuDotnet
}
