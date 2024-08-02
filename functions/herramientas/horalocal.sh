#---HORARIOS LOCALES
hora_local() {
    timemx() {
        rm -rf /etc/localtime
        ln -s /usr/share/zoneinfo/America/Merida /etc/localtime
        echo -e "\e[1;92m          >> FECHA LOCAL MX APLICADA! <<"
        echo -e "\e[93m           $(date)"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    timearg() {
        rm -rf /etc/localtime
        ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
        echo -e "\e[1;92m          >> FECHA LOCAL ARG APLICADA! <<"
        echo -e "\e[93m           $(date)"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    timeco() {
        rm -rf /etc/localtime
        ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime
        echo -e "\e[1;92m          >> FECHA LOCAL CO APLICADA! <<"
        echo -e "\e[93m           $(date)"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    timeperu() {
        rm -rf /etc/localtime
        ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
        echo -e "\e[1;92m          >> FECHA LOCAL PE APLICADA! <<"
        echo -e "\e[93m           $(date)"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    timegt() {

        rm -rf /etc/localtime
        ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
        echo -e "\e[1;92m          >> FECHA LOCAL GT APLICADA! <<"
        echo -e "\e[93m           $(date)"
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    }
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\e[1;93m           AJUSTES DE HORARIOS LOCALES  "
    msg -bar

    echo -e "\e[1;93m  [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR HORA LOCAL MX"
    echo -e "\e[1;93m  [\e[1;32m2\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR HORA LOCAL ARG"
    echo -e "\e[1;93m  [\e[1;32m3\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR HORA LOCAL CO"
    echo -e "\e[1;93m  [\e[1;32m4\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR HORA LOCAL PE"
    echo -e "\e[1;93m  [\e[1;32m5\e[1;93m]\033[1;31m > \e[1;97mCAMBIAR HORA LOCAL GT"
    msg -bar
    echo -e "    \e[97m\033[1;41m ENTER SIN RESPUESTA REGRESA A MENU ANTERIOR \033[0;97m"
    msg -bar
    echo -ne "    └⊳ Seleccione una Opcion: \033[1;32m" && read opx
    tput cuu1 && tput dl1

    case $opx in
    1)
        timemx
        ;;
    2)
        timearg
        ;;
    3)
        timeco
        ;;
    4)
        timeperu
        ;;
    5)
        timegt
        ;;
    *)
        ;;
    esac

}
