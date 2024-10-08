#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

limitadorv2ray() {
    local userdb="${mainPath}/RegV2ray"
    local blockips_file="$mainPath/v2ray/blockips"
    [[ ! -f $blockips_file ]] && touch $blockips_file
    local regBlock="$mainPath/v2ray/regblock"
    [[ ! -f $regBlock ]] && touch $regBlock

    local regIp="([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)"
    local regPort="\]:([0-9]+)"

    local logPath="/var/log/v2ray/access.log"

    showCabezera "LIMITADOR DE  CONEXIONES"

    msg -amarillo "USUARIO | LIMITE | CONEXION | STATUS"

    while IFS='|' read -r uuid email user limite dateExp; do
        email=$(echo "$email" | tr -d '[:space:]')
        # Usa awk para procesar el archivo y extraer las IPs únicas, luego almacénalas en el array
        readarray -t unique_ips < <(grep "${email}" $logPath | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq)

        # Cuenta las IPs únicas
        unique_ip_count=${#unique_ips[@]}

        # Unir los elementos del array en una sola cadena separada por comas
        unique_ips_joined=$(
            IFS=,
            echo "${unique_ips[*]}"
        )

        msgne -blanco "${user} | ${limite} | ${unique_ip_count} | "

        if [[ $unique_ip_count -gt $limite ]]; then

            for ip in "${unique_ips[@]}"; do
                sudo ip route add blackhole "${ip}" >/dev/null 2>&1

                # guardamos los datos del bloqueo
                echo "${ip}" >>$blockips_file
                echo "${uuid} | ${email} | ${user} | ${limite} | ${ip}" >>$regBlock
            done

            msg -rojo "[DESCONECTADO]"
        else
            msg -verde "[OK]"
        fi

    done <"${userdb}"

    echo "" > $logPath
    msg -bar

}

limitadorv2ray


# ip route show | grep blackhole