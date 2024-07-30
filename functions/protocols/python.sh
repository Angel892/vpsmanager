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

        msgCentrado -amarillo "DESINSTALANDO PYTHON"
        fun_bar "sudo apt-get remove --purge python3 -y"

        msg -bar
        msgCentrado -verde "PYTHON DESINSTALADO CON ÉXITO"
        msg -bar
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
