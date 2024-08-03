mosusr_kk() {
    showCabezera "USUARIOS REGISTRADOS | UUID V2RAY"

    local HOST="$mainPath/RegV2ray"
    if [[ ! -f $HOST || ! -s $HOST ]]; then
        echo -e "----- NINGUN USER REGISTRADO -----"
        msg -ne "Enter Para Continuar" && read -r
        return
    fi

    local VPSsec=$(date +%s)
    local contador_secuencial=""
    local i=1

    # Establecer los anchos de columna
    local col_uuid=36
    local col_email=25
    local col_user=10
    local col_dias=10

    # Imprimir la cabecera de la tabla con printf para la alineación
    printf "\e[97m%-${col_uuid}s | %- ${col_email}s | %- ${col_user}s | %- ${col_dias}s\e[93m\n" "UUID" "EMAIL" "USER" "DIAS"
    msg -bar

    while IFS='|' read -r uuid email user dateExp; do
        if [[ -n $dateExp ]]; then
            local DataSec=$(date +%s --date="$dateExp")
            local EXPTIME=$([[ "$VPSsec" -gt "$DataSec" ]] && echo -e "\e[91m[EXPIRADO]\e[97m" || echo -e "\e[92m[$(((DataSec - VPSsec) / 86400))]\e[97m")
        else
            local EXPTIME="\e[91m[ S/R ]\e[97m"
        fi

        contador_secuencial+=$(printf "\e[93m%-${col_uuid}s | %- ${col_email}s | %- ${col_user}s | %- ${col_dias}s" "$uuid" "$email" "$user" "$dateExp$EXPTIME\n")

        if ((i % 30 == 0)); then
            echo -e "$contador_secuencial"
            contador_secuencial=""
        fi
        ((i++))
    done <"$HOST"

    if [[ -n $contador_secuencial ]]; then
        local linesss=$(wc -l <"$HOST")
        echo -e "$contador_secuencial \n \e[1;97mNumero de Registrados: $linesss"
    fi

    msgSuccess
}
