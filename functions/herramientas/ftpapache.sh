#---ARCHIVOS ONLINE
ftp_apache() {
    fun_ip() {
        MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
        MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
        [[ "$MEU_IP" != "$MEU_IP2" ]] && echo "$MEU_IP2" || echo "$MEU_IP"
    }
    IP="$(fun_ip)"

    list_archivos() {

        [[ $(find /var/www/html -name index.html | grep -w "index.html" | head -1) ]] &>/dev/null || {
            echo -e "\e[1;31m              SIN REGITROS A UN "
            msg -bar
            return
        }
        [[ -z $(ls /var/www/html) ]] && echo -e "" || {
            for my_arqs in $(ls /var/www/html); do
                [[ "$my_arqs" = "index.html" ]] && continue
                [[ "$my_arqs" = "index.php" ]] && continue
                [[ -d "$my_arqs" ]] && continue
                echo -e "\033[1;31m[$my_arqs] \033[1;36mhttp://$IP:81/$my_arqs\033[0m"
            done
            msg -bar
        }
    }
    borar_archivos() {
        [[ $(find /var/www/html -name index.html | grep -w "index.html" | head -1) ]] &>/dev/null || {
            echo -e "\e[1;31m              SIN REGITROS A UN "
            msg -bar
            return
        }
        i="1"

        [[ -z $(ls /var/www/html) ]] && echo -e "" || {
            for my_arqs in $(ls /var/www/html); do
                [[ "$my_arqs" = "index.html" ]] && continue
                [[ "$my_arqs" = "index.php" ]] && continue
                [[ -d "$my_arqs" ]] && continue
                select_arc[$i]="$my_arqs"
                echo -e "${cor[2]}[$i] > ${cor[3]}$my_arqs - \033[1;36mhttp://$IP:81/$my_arqs\033[0m"
                let i++
            done
            msg -bar
            echo -e "${cor[5]}Seleccione el archivo que desea borrar"
            msg -bar
            i=$(($i - 1))
            #  while [[ -z ${select_arc[$slct]} ]]; do
            read -p " [1-$i]: " slct
            tput cuu1 && tput dl1
            #  done
            arquivo_move="${select_arc[$slct]}"
            [[ -d /var/www/html ]] && [[ -e /var/www/html/$arquivo_move ]] && rm -rf /var/www/html/$arquivo_move >/dev/null 2>&1
            [[ -e /var/www/$arquivo_move ]] && rm -rf /var/www/$arquivo_move >/dev/null 2>&1
            echo -e "\e[1;32m  >> Completado con Exito!"
            msg -bar
        }
    }
    subir_archivo() {
        i="1"
        [[ -z $(ls $HOME) ]] && echo -e "" || {
            for my_arqs in $(ls $HOME); do
                [[ -d "$my_arqs" ]] && continue
                select_arc[$i]="$my_arqs"
                echo -e "${cor[2]} [$i] > ${cor[3]}$my_arqs"
                let i++
            done
            i=$(($i - 1))
            msg -bar
            echo -e "${cor[5]}Seleccione el archivo"
            msg -bar
            # while [[ -z ${select_arc[$slct]} ]]; do
            read -p " [1-$i]: " slct
            tput cuu1 && tput dl1
            #done
            arquivo_move="${select_arc[$slct]}"
            [ ! -d /var ] && mkdir /var
            [ ! -d /var/www ] && mkdir /var/www
            [ ! -d /var/www/html ] && mkdir /var/www/html
            [ ! -e /var/www/html/index.html ] && touch /var/www/html/index.html
            [ ! -e /var/www/index.html ] && touch /var/www/index.html
            chmod -R 755 /var/www
            cp $HOME/$arquivo_move /var/www/$arquivo_move
            cp $HOME/$arquivo_move /var/www/html/$arquivo_move
            echo -e "\033[1;36m http://$IP:81/$arquivo_move\033[0m"
            msg -bar
            echo -e "\e[1;32m  >> Completado con Exito!"
            msg -bar
        }
    }

    showCabezera "GESTOR FTP VIA APACHE DIRECTO"

    local num=1
    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "COLOCAR ARCHIVO OLINE"
    option[$num]="agregar"
    let num++

    # DETENER DROPBEAR
    opcionMenu -blanco $num "QUITAR ARCHIVO ONLINE"
    option[$num]="remover"
    let num++

    # DETENER DROPBEAR
    opcionMenu -blanco $num "VER ARCHIVOS ONLINE"
    option[$num]="listar"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in

    "agregar")
        subir_archivo
        ;;
    "remover")
        borar_archivos
        ;;
    "listar")
        list_archivos
        ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;

    esac

    ftp_apache

}
