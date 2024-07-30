menuPython() {

    instalar() {
        clear && clear
        msg -bar
        msgCentrado -blanco "INSTALACION DE PYTHON"
        msg -bar

        msgCentrado -amarillo "ACTUALIZANDO PAQUETES"
        fun_bar "sudo apt update"

        msgCentrado -amarillo "INSTALANDO PYTHON"
        fun_bar "sudo apt install python3 -y"

    }

    detener() {
        clear && clear
        msg -bar
        msgCentrado -blanco "DESINSTALACION PYTHON"
        msg -bar

        # Elimina todos los paquetes relacionados con Python 3
        msgCentrado -amarillo "DESINSTALANDO PYTHON"
        fun_bar "sudo apt-get purge -y python3 python3-*"

        # Limpia paquetes y dependencias innecesarias
        msgCentrado -amarillo "LIMPIANDO DEPENDENDIAS"
        fun_bar "sudo apt-get autoremove -y"
        fun_bar "sudo apt-get autoclean"
    }

    local num=1

    clear
    msg -bar
    msgCentrado -amarillo "MENU PYTHON"
    msg -bar

    # INSTALAR
    opcionMenu -blanco $num "Instalar python"
    option[$num]="instalar"
    let num++

    # DETENER
    opcionMenu -blanco $num "Desinstalar python"
    option[$num]="detener"
    let num++

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "instalar") instalar ;;
    "detener") detener ;;
    "volver") return ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        menuPython
        ;;
    esac
}
