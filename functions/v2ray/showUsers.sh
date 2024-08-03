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

    # Crear un archivo temporal para almacenar los datos alineados
    local temp_file=$(mktemp)

    # Agregar la cabecera al archivo temporal
    echo -e "${AMARILLO}UUID\tEMAIL\tUSER\tDIAS" >"$temp_file"

    while IFS='|' read -r uuid email user dateExp; do
        if [[ -n $dateExp ]]; then
            local DataSec=$(date +%s --date="$dateExp")
            local EXPTIME=$([[ "$VPSsec" -gt "$DataSec" ]] && echo -e "\e[91m[EXPIRADO]\e[97m" || echo -e "\e[92m[$(((DataSec - VPSsec) / 86400))]\e[97m")
        else
            local EXPTIME="\e[91m[ S/R ]\e[97m"
        fi

        echo -e "${VERDE}$uuid\t${BLANCO}$email\t$user\t$dateExp$EXPTIME" >>"$temp_file"
        ((i++))
    done <"$HOST"

    # Usar 'column' para alinear los datos y luego imprimir
    column -t -s $'\t' "$temp_file"

    # Contar el número de líneas en el archivo original
    local linesss=$(wc -l <"$HOST")
    echo -e "\n \e[1;97mNumero de Registrados: $linesss"

    # Limpiar el archivo temporal
    rm "$temp_file"

    msgSuccess
}
