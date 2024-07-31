server_psiphones() {

    install_psiphone() {

        clear && clear
        if ps aux | grep 'psiphond' | grep -v grep >/dev/null; then
            echo "El proceso psiphond ya está activo."
            exit 1
        fi

        msg -bar
        msg -tit
        msg -bar
        msg -amarillo "            INSTALADOR DE SERVR-PSIPHONE"
        msg -bar
        echo -e "\033[1;97m Ingrese los puertos segun su necesidad\033[1;97m\n"

        rm -rf /root/psi
        kill $(ps aux | grep 'psiphond' | awk '{print $2}') 1>/dev/null 2>/dev/null
        killall psiphond 1>/dev/null 2>/dev/null
        mkdir -p /root/psi
        cd /root/psi
        ship=$(wget -qO- ifconfig.me)
        wget -O /root/psi/psiphond https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core-binaries/master/psiphond/psiphond &>/dev/null
        chmod +rwx /root/psi/psiphond
        echo -ne "\033[1;97m Escribe el puerto para Psiphon SSH:\033[32m " && read -p " " -e -i "3001" sh
        echo -ne "\033[1;97m Escribe el puerto para Psiphon OSSH:\033[32m " && read -p " " -e -i "3002" osh
        echo -ne "\033[1;97m Escribe el puerto para Psiphon FRONTED-MEEK:\033[32m " && read -p " " -e -i "443" fm
        echo -ne "\033[1;97m Escribe el puerto para Psiphon WEB:\033[32m " && read -p " " -e -i "3000" wb
        #echo -ne "\033[1;97m Escribe el puerto para Psiphon UNFRONTED-MEEK:\033[32m " && read umo
        #./psiphond --ipaddress $ship --protocol SSH:$sh --protocol OSSH:$osh --protocol FRONTED-MEEK-OSSH:$fm --protocol UNFRONTED-MEEK-OSSH:$umo generate
        ./psiphond --ipaddress $ship --web $wb --protocol SSH:$sh --protocol OSSH:$osh --protocol FRONTED-MEEK-OSSH:$fm generate

        chmod 666 psiphond.config
        chmod 666 psiphond-traffic-rules.config
        chmod 666 psiphond-osl.config
        chmod 666 psiphond-tactics.config
        chmod 666 server-entry.dat
        cat server-entry.dat >/root/psi.txt
        screen -dmS psiserver ./psiphond run
        cd /root
        psi=$(cat /root/psi.txt)
        echo -e "\033[1;33m LA CONFIGURACION DE TU SERVIDOR ES:\033[0m"
        msg -bar
        echo -e "\033[1;32m $psi \033[0m"
        msg -bar
        echo -e "\033[1;33m PROTOCOLOS HABILITADOS:\033[0m"
        echo -e "\033[1;33m → SSH:\033[1;32m $sh \033[0m"
        echo -e "\033[1;33m → OSSH:\033[1;32m $osh \033[0m"
        echo -e "\033[1;33m → FRONTED-MEEK-OSSH:\033[1;32m $fm \033[0m"
        #echo -e "\033[1;33m → UNFRONTED-MEEK-OSSH:\033[1;32m $umo \033[0m"
        echo -e "\033[1;33m → WEB:\033[1;32m $wb \033[0m"
        msg -bar
        echo -e "\033[1;33m DIRECTORIO DE ARCHIVOS:\033[1;32m /root/psi \033[0m"
        msg -bar
        [[ "$(ps x | grep psiserver | grep -v grep | awk '{print $1}')" ]] && msg -verde "    >> SERVIDOR-PSIPHONE INSTALADO CON EXITO <<" || msg -amarillo "                  ERROR VERIFIQUE"
        msg -bar
        read -t 120 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        return;
    }
    desactivar_psiphone() {
        clear && clear
        msg -bar
        echo -e "\033[1;31m            DESISNTALANDO PUERTOS UDP-SERVER "
        msg -bar
        rm -rf /root/psi
        kill $(ps aux | grep 'psiphond' | awk '{print $2}') 1>/dev/null 2>/dev/null
        killall psiphond 1>/dev/null 2>/dev/null
        [[ "$(ps x | grep psiserver | grep -v grep | awk '{print $1}')" ]] && echo -e "\033[1;32m        >> UDP-SERVER DESINSTALADO CON EXICO << "
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        return;
    }
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msg -amarillo "            INSTALADOR DE PSIPHONE-SERVER"
    msg -bar
    if [[ ! -e /bin/psiphond ]]; then
        curl -o /bin/psiphond https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core-binaries/master/psiphond/psiphond &>/dev/null
        chmod 777 /bin/psiphond
    fi
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR SERVER-PSIPHONE  \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m DETENER SERVER-PSIPHONE \e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;97mDigite solo el numero segun su respuesta:\e[32m "
    read opcao
    case $opcao in
    1)
        msg -bar
        install_psiphone
        ;;
    2)
        msg -bar
        desactivar_psiphone
        ;;
    0)
        menuProtocols;
        return
        ;;
    *)
        echo -e "$ Porfavor use numeros del [0-2]"
        msg -bar
        ;;
    esac

    server_psiphones
    return

    #exit 0

}
