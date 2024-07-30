menuPython() {

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
    "instalar") crearCuentaSSH ;;
    "detener") crearCuentaTemporalSSH ;;
    "volver") return ;;
    *) 
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" 
        sleep 2
        menuPython
    ;;
    esac
}
