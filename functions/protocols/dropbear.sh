proto_dropbear() {
    activar_dropbear() {

        showCabezera "INSTALADOR DROPBEAR | SCRIPT LXServer"

        msgCentrado -blanco "Puede activar varios puertos en orden secuencial"
        msgCentrado -verde "Ejemplo: 442 443 444"
        msg -bar

        msgne -blanco "Digite Puertos: "
        read -p " " -e -i "444 445" DPORT

        tput cuu1 && tput dl1
        local TTOTAL2=($DPORT)
        unset PORT2
        for ((i = 0; i < ${#TTOTAL2[@]}; i++)); do
            msgne -blanco "Puerto Elegido: "
            [[ $(mportas | grep "${TTOTAL2[$i]}") = "" ]] && {
                msg -verde "${TTOTAL2[$i]} OK"
                PORT2="$PORT2 ${TTOTAL2[$i]}"
            } || {
                msg -rojo "${TTOTAL2[$i]} FAIL"
            }
        done
        [[ -z $PORT2 ]] && {
            msgCentrado -rojo "Ningun Puerto Valido Fue Elegido"
            msgError
            return;
        }

        msg -bar

        msgInstall -blanco "Revisando Actualizaciones"
        fun_bar "apt update; apt upgrade -y"

        msgInstall -blanco "Instalando Dropbear"
        fun_bar "apt-get install dropbear -y"

        touch /etc/dropbear/banner
        msg -bar
        cat <<EOF >/etc/default/dropbear
NO_START=0
DROPBEAR_EXTRA_ARGS="VAR"
DROPBEAR_BANNER="/etc/dropbear/banner"
DROPBEAR_RECEIVE_WINDOW=65536
EOF

        for dpts in $(echo $PORT2); do
            sed -i "s/VAR/-p $dpts VAR/g" /etc/default/dropbear
        done
        sed -i "s/VAR//g" /etc/default/dropbear
        [[ ! $(cat /etc/shells | grep "/bin/false") ]] && echo -e "/bin/false" >>/etc/shells
        dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key >/dev/null 2>&1
        dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key >/dev/null 2>&1
        service ssh restart >/dev/null 2>&1
        sed -i "s/=1/=0/g" /etc/default/dropbear
        service dropbear restart
        sed -i "s/=0/=1/g" /etc/default/dropbear

        msgSuccess
    }

    desactivar_dropbear() {
        showCabezera "DESINSTALANDO DROPBEAR"

        msgInstall -blanco "DETENIENDO DROPBEAR"
        fun_bar "service dropbear stop"

        msgInstall -blanco "REMOVIENDO DROPBEAR"
        fun_bar "apt-get remove dropbear -y"

        killall dropbear >/dev/null 2>&1
        rm -rf /etc/dropbear/* >/dev/null 2>&1
        [[ -e /etc/default/dropbear ]] && rm /etc/default/dropbear

        msgSuccess
    }

    showCabezera "INSTALADOR DROPBEAR | SCRIPT LXServer"

    local num=1
    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "INSTALAR UN DROPBEAR"
    option[$num]="instalar"
    let num++

    # DETENER DROPBEAR
    opcionMenu -blanco $num "DETENER TODOS LOS DROPBEAR"
    option[$num]="detener"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in

    "instalar")
        activar_dropbear
        ;;
    "detener")
        desactivar_dropbear
        ;;
    "volver")
        menuProtocols
        return;
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;

    esac

    proto_dropbear
    return;
}
