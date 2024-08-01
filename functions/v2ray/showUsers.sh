mosusr_kk() {
    showCabezera "USUARIOS REGISTRADOS | UUID V2RAY"
    # usersss=$(cat $mainPath/RegV2ray|cut -d '|' -f1)
    # cat $mainPath/RegV2ray|cut -d'|' -f3
    VPSsec=$(date +%s)
    local HOST="$mainPath/RegV2ray"
    local HOST2="$mainPath/RegV2ray"
    local RETURN="$(cat $HOST | cut -d'|' -f2)"
    local IDEUUID="$(cat $HOST | cut -d'|' -f1)"
    if [[ -z $RETURN ]]; then
        echo -e "----- NINGUN USER REGISTRADO -----"
        msg -ne "Enter Para Continuar" && read enter
        return
    else
        i=1
        echo -e "\e[97m                 UUID                | USER | DIAS\e[93m"
        msg -bar
        while read hostreturn; do
            DateExp="$(cat $mainPath/RegV2ray | grep -w "$hostreturn" | cut -d'|' -f3)"
            if [[ ! -z $DateExp ]]; then
                DataSec=$(date +%s --date="$DateExp")
                [[ "$VPSsec" -gt "$DataSec" ]] && EXPTIME="\e[91m[EXPIRADO]\e[97m" || EXPTIME="\e[92m[$(($(($DataSec - $VPSsec)) / 86400))]"
            else
                EXPTIME="\e[91m[ S/R ]"
            fi
            usris="$(cat $mainPath/RegV2ray | grep -w "$hostreturn" | cut -d'|' -f2)"
            local contador_secuencial+="\e[93m$hostreturn \e[97m|\e[93m$usris\e[97m|\e[93m $EXPTIME \n"
            if [[ $i -gt 30 ]]; then
                echo -e "$contador_secuencial"
                unset contador_secuencial
                unset i
            fi
            let i++
        done <<<"$IDEUUID"

        [[ ! -z $contador_secuencial ]] && {
            linesss=$(cat $mainPath/RegV2ray | wc -l)
            echo -e "$contador_secuencial \n \e[1;97mNumero de Registrados: $linesss"
        }
    fi
    msgSuccess
}
