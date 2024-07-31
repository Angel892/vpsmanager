#--- GETTUNEL
proto_pgettunel() {
    activar_gettunel() {

        validarArchivo "$mainPath/filespy/pwd.pwd"
        meu_ip() {
            MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
            MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
            [[ "$MEU_IP" != "$MEU_IP2" ]] && echo "$MEU_IP2" || echo "$MEU_IP"
        }
        IP=(meu_ip)

        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;33m     INSTALADOR DE GETTUNEL | SCRIPT LXServer \033[1;37m"
        msg -bar
        porta_socket=
        while [[ -z $porta_socket || ! -z $(mportas | grep -w $porta_socket) ]]; do
            echo -ne "\033[1;97m Digite el Puerto para GETUNNEL\033[1;92m" && read -p " " -e -i "8085" porta_socket
        done
        msg -bar
        echo -ne "\033[1;97m Digite una contraseña:\n \033[1;31m" && read -p " " -e -i "SCRIP-LXServer" passg
        echo "$passg" >$mainPath/filespy/pwd.pwd
        msg -bar
        while read service; do
            [[ -z $service ]] && break
            echo "127.0.0.1:$(echo $service | cut -d' ' -f2)=$(echo $service | cut -d' ' -f1)"
        done <<<"$(mportas)"
        screen -dmS getpy python $mainPath/filespy/PGet.py -b "0.0.0.0:porta_socket" -p "$mainPath/filespy/pwd.pwd"
        [[ "$(ps x | grep PGet.py | grep -v grep | awk '{print $1}')" ]] && msg -verde "      >> GETTUNEL INSTALADO CON EXITO <<" || msg -amarillo "               ERROR VERIFIQUE"
        msg -bar
    }

    desactivar_gettunel() {
        clear && clear
        msg -bar
        echo -e "\033[1;31m                DESINSTALAR GETTUNEL  "
        msg -bar
        echo -e "\033[1;97m Procesando ...."
        fun_bar "kill -9 $(ps x | grep PGet.py | grep -v grep | awk '{print $1'}) >/dev/null 2>&1"
        msg -bar
        [[ ! "$(ps x | grep PGet.py | grep -v grep | awk '{print $1}')" ]] && echo -e "\033[1;32m      >> GETTUNEL DESINSTALADO CON EXITO << "
        msg -bar
    }

    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\033[1;33m       INSTALADOR DE GETTUNEL | SCRIPT LXServer \033[1;37m"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR GETTUNEL  \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m DETENER GETTUNEL \e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    case $opcao in
    1)
        msg -bar
        activar_gettunel
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    2)
        msg -bar
        desactivar_gettunel
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    0)
        return
        ;;
    esac

    proto_pgettunel
}
