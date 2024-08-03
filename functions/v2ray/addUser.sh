addusr() {
    showCabezera "AGREGAR USUARIO | UUID V2RAY"
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
            errorFun "nullo" && continue
        elif [[ "${#nick}" -lt "2" ]]; then
            errorFun "minimo" && continue
        elif [[ "${#nick}" -gt "6" ]]; then
            errorFun "maximo" && continue
        fi
        break
    done
    echo -e "\e[91m >> Agregado UUID: \e[92m$UUID "
    while true; do
        echo -ne "\e[91m >> Duracion de UUID (Dias):\033[1;92m " && read diasuser
        if [[ -z "$diasuser" ]]; then
            errorFun "nullo" && continue
        elif [[ "$diasuser" != +([0-9]) ]]; then
            errorFun "soloNumeros" && continue
        elif [[ "$diasuser" -gt "360" ]]; then
            errorFun "maximo" && continue
        fi
        break
    done
    #Lim
    [[ $(cat /etc/passwd | grep $1: | grep -vi [a-z]$1 | grep -v [0-9]$1 >/dev/null) ]] && return 1
    valid=$(date '+%C%y-%m-%d' -d " +$diasuser days") && datexp=$(date "+%F" -d " + $diasuser days")
    echo -e "\e[91m >> Expira el : \e[92m$datexp "
    ##Registro
    echo "  $UUID | $nick | $valid " >>$mainPath/RegV2ray
    Fecha=$(date +%d-%m-%y-%R)
    cp $mainPath/RegV2ray $mainPath/v2ray/RegV2ray-"$Fecha"
    cp $mainPath/RegV2ray /etc/v2ray/config.json-"$Fecha"
    v2ray restart >/dev/null 2>&1
    echo ""
    v2ray info >$mainPath/v2ray/confuuid.log
    lineP=$(sed -n '/'${UUID}'/=' $mainPath/v2ray/confuuid.log)
    numl1=4
    let suma=$lineP+$numl1
    sed -n ${suma}p $mainPath/v2ray/confuuid.log
    echo ""
    msg -bar
    msgCentrado -verde "UUID AGREGEGADO CON EXITO"
    msgSuccess
}
