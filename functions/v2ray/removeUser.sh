delusr() {
    invaliduuid() {
        msg -bar
        msgCentrado -rojo "UUID INVALIDO"
        msg -bar
        msg -ne "Enter Para Continuar" && read enter
    }
    
    showCabezera "ELIMINAR USUARIO | UUID V2RAY"
    msgCentrado -blanco "USUARIOS REGISTRADOS"

    echo -e "\e[1;33m$(cat $mainPath/RegV2ray | cut -d '|' -f3,1)"
    msg -bar
    echo -ne "\e[91m >> Digita el usuario a eliminar:\n \033[1;92m " && read userv
    uuidel=$(cat $mainPath/RegV2ray | grep -w "$userv" | cut -d'|' -f1 | tr -d " \t\n\r")
    [[ $(sed -n '/'${uuidel}'/=' /etc/v2ray/config.json | head -1) ]] || invaliduuid
    lineP=$(sed -n '/'${uuidel}'/=' /etc/v2ray/config.json)
    linePre=$(sed -n '/'${uuidel}'/=' $mainPath/RegV2ray)
    sed -i "${linePre}d" $mainPath/RegV2ray
    numl1=2
    let resta=$lineP-$numl1
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    sed -i "${resta}d" /etc/v2ray/config.json
    v2ray restart >/dev/null 2>&1
    msg -bar
    msgCentrado -verde "USUARIO ELIMINADO CON EXITO"
    msgSuccess
}
