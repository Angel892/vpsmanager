#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

limitadorv2ray() {
    local userdb="${mainPath}/RegV2ray"

    while IFS='|' read -r uuid email user limite dateExp; do

        # Inicializa un array para almacenar las IPs únicas
        unique_ips=()

        # Usa awk para procesar el archivo y extraer las IPs únicas, luego almacénalas en el array
        ips_output=$(grep "$email" /var/log/v2ray/access.log | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq)

        mapfile -t unique_ips <<< "$ips_output"

        # Cuenta las IPs únicas
        unique_ip_count=${#unique_ips[@]}

        echo -e "${VERDE}${email} ${unique_ip_count}"
    done <"${userdb}"

}

limitadorv2ray
