intallv2ray() {
    clear && clear
    msg -bar
    echo -e " \e[1;32m          >>> SE INSTALARA V2RAY <<< " | pv -qL 10
    msg -bar
    source <(curl -sL https://raw.githubusercontent.com/NetVPS/LATAM_Oficial/main/Ejecutables/v2ray.sh)
    v2ray update
    mailfix=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 10)
    curl https://get.acme.sh | sh -s email=$mailfix@gmail.com
    #service v2ray restart
    msg -ama "Intalado con EXITO!"
    USRdatabase="/etc/SCRIPT-LATAM/RegV2ray"
    [[ ! -e ${USRdatabase} ]] && touch ${USRdatabase}
    sort ${USRdatabase} | uniq >${USRdatabase}tmp
    mv -f ${USRdatabase}tmp ${USRdatabase}
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
protocolv2ray() {
    msg -ama "Escojer opcion 3 y poner el dominio de nuestra IP!"
    msg -bar
    v2ray stream
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
tls() {
    msg -ama "Activar o Desactivar TLS!"
    msg -bar
    v2ray tls
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
portv() {
    msg -ama "Cambiar Puerto v2ray!"
    msg -bar
    v2ray port
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
stats() {
    msg -ama "Estadisticas de Consumo!"
    msg -bar
    v2ray stats
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
unistallv2() {
    source <(curl -sL https://multi.netlify.app/v2ray.sh) --remove >/dev/null 2>&1
    rm -rf /etc/SCRIPT-LATAM/RegV2ray >/dev/null 2>&1
    rm -rf /etc/SCRIPT-LATAM/v2ray/* >/dev/null 2>&1
    echo -e "\033[1;92m             V2RAY DESINSTALADO CON EXITO"
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
infocuenta() {
    v2ray info
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
addusr() {
    clear
    clear
    msg -bar
    msg -tit
    msg -bar
    msg -ama "             AGREGAR USUARIO | UUID V2RAY"
    msg -bar
    ##DAIS
    valid=$(date '+%C%y-%m-%d' -d " +31 days")
    ##CORREO
    MAILITO=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 10)
    ##ADDUSERV2RAY
    UUID=$(uuidgen)
    sed -i '13i\           \{' /etc/v2ray/config.json
    sed -i '14i\           \"alterId": 0,' /etc/v2ray/config.json
    sed -i '15i\           \"id": "'$UUID'",' /etc/v2ray/config.json
    sed -i '16i\           \"email": "'$MAILITO'@gmail.com"' /etc/v2ray/config.json
    sed -i '17i\           \},' /etc/v2ray/config.json
    echo ""
    while true; do
        echo -ne "\e[91m >> Digita un Nombre: \033[1;92m"
        read -p " " nick
        nick="$(echo $nick | sed -e 's/[^a-z0-9 -]//ig')"
        if [[ -z $nick ]]; then
            err_fun 17 && continue
        elif [[ "${#nick}" -lt "2" ]]; then
            err_fun 2 && continue
        elif [[ "${#nick}" -gt "6" ]]; then
            err_fun 3 && continue
        fi
        break
    done
    echo -e "\e[91m >> Agregado UUID: \e[92m$UUID "
    while true; do
        echo -ne "\e[91m >> Duracion de UUID (Dias):\033[1;92m " && read diasuser
        if [[ -z "$diasuser" ]]; then
            err_fun 17 && continue
        elif [[ "$diasuser" != +([0-9]) ]]; then
            err_fun 8 && continue
        elif [[ "$diasuser" -gt "360" ]]; then
            err_fun 9 && continue
        fi
        break
    done
    #Lim
    [[ $(cat /etc/passwd | grep $1: | grep -vi [a-z]$1 | grep -v [0-9]$1 >/dev/null) ]] && return 1
    valid=$(date '+%C%y-%m-%d' -d " +$diasuser days") && datexp=$(date "+%F" -d " + $diasuser days")
    echo -e "\e[91m >> Expira el : \e[92m$datexp "
    ##Registro
    echo "  $UUID | $nick | $valid " >>/etc/SCRIPT-LATAM/RegV2ray
    Fecha=$(date +%d-%m-%y-%R)
    cp /etc/SCRIPT-LATAM/RegV2ray /etc/SCRIPT-LATAM/v2ray/RegV2ray-"$Fecha"
    cp /etc/SCRIPT-LATAM/RegV2ray /etc/v2ray/config.json-"$Fecha"
    v2ray restart >/dev/null 2>&1
    echo ""
    v2ray info >/etc/SCRIPT-LATAM/v2ray/confuuid.log
    lineP=$(sed -n '/'${UUID}'/=' /etc/SCRIPT-LATAM/v2ray/confuuid.log)
    numl1=4
    let suma=$lineP+$numl1
    sed -n ${suma}p /etc/SCRIPT-LATAM/v2ray/confuuid.log
    echo ""
    msg -bar
    echo -e "\e[92m             UUID AGREGEGADO CON EXITO "
    msg -bar
    read -t 120 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}

delusr() {
    clear
    clear
    invaliduuid() {
        msg -bar
        echo -e "\e[91m                    UUID INVALIDO \n$(msg -bar)"
        msg -ne "Enter Para Continuar" && read enter
        control_v2ray
    }
    msg -bar
    msg -tit
    msg -bar
    msg -ama "             ELIMINAR USUARIO | UUID V2RAY"
    msg -bar
    echo -e "\e[1;97m               USUARIOS REGISTRADOS"
    echo -e "\e[1;33m$(cat /etc/SCRIPT-LATAM/RegV2ray | cut -d '|' -f2,1)"
    msg -bar
    echo -ne "\e[91m >> Digita el usuario a eliminar:\n \033[1;92m " && read userv
    uuidel=$(cat /etc/SCRIPT-LATAM/RegV2ray | grep -w "$userv" | cut -d'|' -f1 | tr -d " \t\n\r")
    [[ $(sed -n '/'${uuidel}'/=' /etc/v2ray/config.json | head -1) ]] || invaliduuid
    lineP=$(sed -n '/'${uuidel}'/=' /etc/v2ray/config.json)
    linePre=$(sed -n '/'${uuidel}'/=' /etc/SCRIPT-LATAM/RegV2ray)
    sed -i "${linePre}d" /etc/SCRIPT-LATAM/RegV2ray
    numl1=2
    let resta=$lineP-$numl1
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    v2ray restart >/dev/null 2>&1
    msg -bar
    echo -e "\e[1;32m            USUARIO ELIMINADO CON EXITO"
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}

mosusr_kk() {
    clear
    clear
    msg -bar
    msg -tit
    msg -bar
    msg -ama "         USUARIOS REGISTRADOS | UUID V2RAY"
    msg -bar
    # usersss=$(cat /etc/SCRIPT-LATAM/RegV2ray|cut -d '|' -f1)
    # cat /etc/SCRIPT-LATAM/RegV2ray|cut -d'|' -f3
    VPSsec=$(date +%s)
    local HOST="/etc/SCRIPT-LATAM/RegV2ray"
    local HOST2="/etc/SCRIPT-LATAM/RegV2ray"
    local RETURN="$(cat $HOST | cut -d'|' -f2)"
    local IDEUUID="$(cat $HOST | cut -d'|' -f1)"
    if [[ -z $RETURN ]]; then
        echo -e "----- NINGUN USER REGISTRADO -----"
        msg -ne "Enter Para Continuar" && read enter
        control_v2ray

    else
        i=1
        echo -e "\e[97m                 UUID                | USER | DIAS\e[93m"
        msg -bar
        while read hostreturn; do
            DateExp="$(cat /etc/SCRIPT-LATAM/RegV2ray | grep -w "$hostreturn" | cut -d'|' -f3)"
            if [[ ! -z $DateExp ]]; then
                DataSec=$(date +%s --date="$DateExp")
                [[ "$VPSsec" -gt "$DataSec" ]] && EXPTIME="\e[91m[EXPIRADO]\e[97m" || EXPTIME="\e[92m[$(($(($DataSec - $VPSsec)) / 86400))]"
            else
                EXPTIME="\e[91m[ S/R ]"
            fi
            usris="$(cat /etc/SCRIPT-LATAM/RegV2ray | grep -w "$hostreturn" | cut -d'|' -f2)"
            local contador_secuencial+="\e[93m$hostreturn \e[97m|\e[93m$usris\e[97m|\e[93m $EXPTIME \n"
            if [[ $i -gt 30 ]]; then
                echo -e "$contador_secuencial"
                unset contador_secuencial
                unset i
            fi
            let i++
        done <<<"$IDEUUID"

        [[ ! -z $contador_secuencial ]] && {
            linesss=$(cat /etc/SCRIPT-LATAM/RegV2ray | wc -l)
            echo -e "$contador_secuencial \n \e[1;97mNumero de Registrados: $linesss"
        }
    fi
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}

limpiador_activador() {
    unset PIDGEN
    PIDGEN=$(ps aux | grep -v grep | grep "limv2ray")
    if [[ ! $PIDGEN ]]; then
        screen -dmS limv2ray watch -n 21600 /etc/SCRIPT-LATAM/menu.sh "exlimv2ray"
    else
        #killall screen
        screen -S limv2ray -p 0 -X quit
    fi
    unset PID_GEN
    PID_GEN=$(ps x | grep -v grep | grep "limv2ray")
    [[ ! $PID_GEN ]] && PID_GEN="\e[91m [ DESACTIVADO ] " || PID_GEN="\e[92m [ ACTIVADO ] "
    statgen="$(echo $PID_GEN)"
    clear
    clear
    msg -bar
    msg -tit
    msg -bar
    msg -ama "          ELIMINAR EXPIRADOS | UUID V2RAY"
    msg -bar
    echo -e "\e[1;97m     SE LIMPIARAN EXPIRADOS CADA 6 hrs"
    msg -bar
    echo -e "                    $statgen "
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray

}

changepath() {
    clear
    clear
    msg -bar
    msg -tit
    msg -ama "             CAMBIAR NOMBRE DEL PATH"
    msg -bar
    echo -e "\e[97m               USUARIOS REGISTRADOS"
    echo -ne "\e[91m >> Digita un nombre corto para el path:\n \033[1;92m " && read nombrepat
    NPath=$(sed -n '/'path'/=' /etc/v2ray/config.json)
    sed -i "${NPath}d" /etc/v2ray/config.json
    sed -i ''${NPath}'i\          \"path": "/'${nombrepat}'/",' /etc/v2ray/config.json
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}

backup_fun() {
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msg -ama " BACKUP BASE DE USUARIOS / JSON GENERAL (WEBSOCKET)"
    msg -bar
    menu_func "CREAR BACKUP" "RESTAURAR BACKUP" "CAMBIAR HOST/CRT"
    echo -ne ""$(msg -bar)"   \n$(msg -verd "  [0]") $(msg -verm2 "╚⊳ ")" && msg -bra "  \e[1;97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    unset selection
    while [[ ${selection} != @([0-3]) ]]; do
        echo -ne "\033[1;37mSeleccione una Opcion: " && read selection
        tput cuu1 && tput dl1
    done
    case ${selection} in
    1)
        cp /etc/v2ray/config.json $HOME/config.json
        cp /etc/SCRIPT-LATAM/RegV2ray $HOME/RegV2ray
        msg -azu "Procedimiento Hecho con Exito, Guardado en:"
        echo ""
        echo -e "\033[1;31mBACKUP > [\033[1;32m$HOME/config.json\033[1;31m]"
        echo -e "\033[1;31mBACKUP > [\033[1;32m$HOME/RegV2ray\033[1;31m]"
        ;;
    2)
        echo -ne "\033[1;37m Ubique los files la carpeta root\n"
        msg -bar
        read -t 20 -n 1 -rsp $'\033[1;39m   Enter Para Proceder o CTRL + C para Cancelar\n'
        echo ""
        cp /root/config.json /etc/v2ray/config.json
        cp /root/RegV2ray /etc/SCRIPT-LATAM/RegV2ray
        echo -e "\033[1;31mRESTAURADO > [\033[1;32m/etc/v2ray/config.json \033[1;31m]"
        echo -e "\033[1;31mRESTAURADO > [\033[1;32m/etc/SCRIPT-LATAM/RegV2ray \033[1;31m]"
        ;;
    3)
        echo -ne "\033[1;37m           EDITAR HOST,SUDOMINIO,KEY,CRT\n"
        msg -bar
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
        ;;
    0)
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        control_v2ray
        exit 0
        ;;
    esac
    echo ""
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}

pid_inst2() {
    [[ $1 = "" ]] && echo -e "\033[1;31m[OFF]" && return 0
    unset portas
    portas_var=$(lsof -V -i -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND")
    i=0
    while read port; do
        var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
        [[ "$(echo -e ${portas[@]} | grep "$var1 $var2")" ]] || {
            portas[$i]="$var1 $var2\n"
            let i++
        }
    done <<<"$portas_var"
    [[ $(echo "${portas[@]}" | grep "$1") ]] && echo -e "\033[1;32m[ Servicio Activo ]" || echo -e "\033[1;31m[ Servicio Desactivado ]"
}
