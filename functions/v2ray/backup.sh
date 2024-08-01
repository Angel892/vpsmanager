backup_fun() {

    crear() {
        cp /etc/v2ray/config.json $HOME/config.json
        cp $mainPath/RegV2ray $HOME/RegV2ray
        msg -verde "Procedimiento Hecho con Exito, Guardado en:"
        echo ""
        echo -e "\033[1;31mBACKUP > [\033[1;32m$HOME/config.json\033[1;31m]"
        echo -e "\033[1;31mBACKUP > [\033[1;32m$HOME/RegV2ray\033[1;31m]"
    }

    restaurar() {
        echo -ne "\033[1;37m Ubique los files la carpeta root\n"
        msg -bar
        read -t 20 -n 1 -rsp $'\033[1;39m   Enter Para Proceder o CTRL + C para Cancelar\n'
        echo ""
        cp /root/config.json /etc/v2ray/config.json
        cp /root/RegV2ray $mainPath/RegV2ray
        echo -e "\033[1;31mRESTAURADO > [\033[1;32m/etc/v2ray/config.json \033[1;31m]"
        echo -e "\033[1;31mRESTAURADO > [\033[1;32m$mainPath/RegV2ray \033[1;31m]"
    }

    editarHost() {
        showCabezera "EDITAR HOST,SUDOMINIO,KEY,CRT"
        read -t 20 -n 1 -rsp $'\033[1;39m   Enter Para Proceder o CTRL + C para Cancelar\n'
        echo -ne "\e[91m >> Digita el sub.dominio usado anteriormente:\n \033[1;92m " && read nombrehost
        ##CER
        Ncert=$(sed -n '/'certificateFile'/=' /etc/v2ray/config.json)
        sed -i "${Ncert}d" /etc/v2ray/config.json
        sed -i ''${Ncert}'i\              \"certificateFile": "/root/.acme.sh/'${nombrehost}'_ecc/fullchain.cer",' /etc/v2ray/config.json
        ##KEY
        Nkey=$(sed -n '/'keyFile'/=' /etc/v2ray/config.json)
        sed -i "${Nkey}d" /etc/v2ray/config.json
        sed -i ''${Nkey}'i\              \"keyFile": "/root/.acme.sh/'${nombrehost}'_ecc/'${nombrehost}'.key"' /etc/v2ray/config.json
        ##HOST
        Nhost=$(sed -n '/'Host'/=' /etc/v2ray/config.json)
        sed -i "${Nhost}d" /etc/v2ray/config.json
        sed -i ''${Nhost}'i\           \"Host": "'${nombrehost}'"' /etc/v2ray/config.json
        ##DOM
        Ndom=$(sed -n '/'domain'/=' /etc/v2ray/config.json)
        sed -i "${Ndom}d" /etc/v2ray/config.json
        sed -i ''${Ndom}'i\           \"domain": "'${nombrehost}'"' /etc/v2ray/config.json
        echo -e "\033[1;31m HOST Y CRT ,KEY RESTAURADO > [\033[1;32m $nombrehost \033[1;31m]"
    }

    showCabezera "BACKUP BASE DE USUARIOS / JSON GENERAL (WEBSOCKET)"

    local num=1
    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "CREAR BACKUP"
    option[$num]="crear"
    let num++

    # DETENER DROPBEAR
    opcionMenu -blanco $num "RESTAURAR BACKUP"
    option[$num]="restaurar"
    let num++

    # DETENER DROPBEAR
    opcionMenu -blanco $num "CAMBIAR HOST/CRT"
    option[$num]="changehost"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in

    "crear")
        crear
        ;;
    "restaurar")
        restaurar
        ;;
    "changehost")
        editarHost
        ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;

    esac

    backup_fun
}
