proto_dropbear() {
    activar_dropbear() {

        mportas() {
            unset portas
            portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
            while read port; do
                var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
                [[ "$(echo -e $portas | grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
            done <<<"$portas_var"
            i=1
            echo -e "$portas"
        }
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        msgCentrado -amarillo "INSTALADOR DROPBEAR | SCRIPT LATAM"
        msg -bar
        echo -e "\033[1;97m Puede activar varios puertos en orden secuencial\n Ejemplo: \033[1;32m 442 443 444\033[1;37m"
        msg -bar
        echo -ne "\033[1;97m Digite  Puertos:\033[1;32m" && read -p " " -e -i "444 445" DPORT
        tput cuu1 && tput dl1
        TTOTAL2=($DPORT)
        for ((i = 0; i < ${#TTOTAL2[@]}; i++)); do
            [[ $(mportas | grep "${TTOTAL2[$i]}") = "" ]] && {
                echo -e "\033[1;33m Puerto Elegido:\033[1;32m ${TTOTAL2[$i]} OK"
                PORT2="$PORT2 ${TTOTAL2[$i]}"
            } || {
                echo -e "\033[1;33m Puerto Elegido:\033[1;31m ${TTOTAL2[$i]} FAIL"
            }
        done
        [[ -z $PORT2 ]] && {
            echo -e "\033[1;31m Ningun Puerto Valido Fue Elegido\033[0m"
            return 1
        }

        msg -bar
        echo -e "\033[1;97m Revisando Actualizaciones"
        fun_bar "apt update; apt upgrade -y > /dev/null 2>&1"
        echo -e "\033[1;97m Instalando Dropbear"
        fun_bar "apt-get install dropbear -y > /dev/null 2>&1"
        apt-get install dropbear -y >/dev/null 2>&1
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
        sleep 3s
        echo -e "\033[1;92m        >> DROPBEAR INSTALADO CON EXITO <<"
        msg -bar

    }

    desactivar_dropbear() {
        clear && clear
        msg -bar
        echo -e "\033[1;91m              DESINSTALANDO DROPBEAR"
        msg -bar
        service dropbear stop >/dev/null 2>&1
        fun_bar "apt-get remove dropbear -y"
        killall dropbear >/dev/null 2>&1
        rm -rf /etc/dropbear/* >/dev/null 2>&1
        msg -bar
        echo -e "\033[1;32m             DROPBEAR DESINSTALADO EXITO"
        msg -bar
        [[ -e /etc/default/dropbear ]] && rm /etc/default/dropbear
    }

    while true; do

        clear && clear
        msg -bar
        msg -tit
        msg -bar
        msgCentrado -amarillo "INSTALADOR DROPBEAR | SCRIPT LATAM"
        msg -bar

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
            msg -bar
            activar_dropbear
            msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
            ;;
        "detener")
            msg -bar
            desactivar_dropbear
            msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
            ;;
        "volver") break ;;
        *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;

        esac
    done
}
