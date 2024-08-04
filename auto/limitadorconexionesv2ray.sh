#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

limitadorv2ray() {
    local userdb="${mainPath}/RegV2ray"

    while IFS='|' read -r uuid email user limite dateExp; do
        email=$(echo "$email" | tr -d '[:space:]')
        # Usa awk para procesar el archivo y extraer las IPs únicas, luego almacénalas en el array
        readarray -t unique_ips < <(grep "${email}" /var/log/v2ray/access.log | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq)

        # Cuenta las IPs únicas
        unique_ip_count=${#unique_ips[@]}

        if [[ $unique_ip_count -gt $limite ]]; then

            msgne -verde "${email} | ${limite} | ${unique_ip_count}"

        fi
        
    done <"${userdb}"

}

limitadorv2ray
