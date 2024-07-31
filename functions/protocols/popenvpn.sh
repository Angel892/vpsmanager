#--- PROXY OPENVPN
proto_popenvpn() {
    activar_openvpn() {

        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;33m     INSTALADOR DE PROXY OPENVPN | SCRIPT LXServer \033[1;37m"
        msg -bar
        porta_socket=
        while [[ -z $porta_socket || ! -z $(mportas | grep -w $porta_socket) ]]; do
            echo -ne "\033[1;97m Digite el Puerto para el Websoket:\033[1;92m" && read -p " " -e -i "8081" porta_socket
        done
        msg -bar
        echo -ne "\033[1;97m Introduzca el texto de estado plano o en HTML:\n \033[1;31m" && read -p " " -e -i "By SCRIP | LXServer" texto_soket
        msg -bar

        validarArchivo "$mainPath/filespy/POpen.py"
        validarArchivo "$mainPath/PortM/POpen.log"

        screen -dmS popenvpn-"$porta_socket" python $mainPath/filespy/POpen.py "$porta_socket" "$texto_soket" && echo ""$porta_socket"" >>$mainPath/PortM/POpen.log
        [[ "$(ps x | grep POpen.py | grep -v grep | awk '{print $1}')" ]] && msg -verde "     >> PROXY OPENVPN INSTALADO CON EXITO <<" || msg -amarillo "               ERROR VERIFIQUE"
        msg -bar
    }

    desactivar_popen() {
        clear && clear
        msg -bar
        echo -e "\033[1;31m            DESINSTALAR PROXY OPENVPN "
        msg -bar
        echo -e "\033[1;97m Procesando ...."
        rm -rf $mainPath/PortM/POpen.log >/dev/null 2>&1
        fun_bar "kill -9 $(ps x | grep POpen.py | grep -v grep | awk '{print $1'}) >/dev/null 2>&1"
        msg -bar
        [[ ! "$(ps x | grep POpen.py | grep -v grep | awk '{print $1}')" ]] && echo -e "\033[1;32m    >> PROXY OPENVPN DESINSTALADO CON EXITO << "
        msg -bar
    }

    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\033[1;33m     INSTALADOR DE PROXY OPENVPN | SCRIPT LXServer \033[1;37m"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR UN PROXY  \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m DETENER TODOS LOS PROXY OPENVPN \e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    case $opcao in
    1)
        msg -bar
        activar_openvpn
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    2)
        msg -bar
        desactivar_popen
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    0)
        menuProtocols
        return
        ;;
    esac

    proto_popenvpn
    return
}
