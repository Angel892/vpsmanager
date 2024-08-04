#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

limitadorv2ray() {
    local userdb="${mainPath}/RegV2ray"

    while IFS='|' read -r uuid email user limite dateExp; do

        echo -e "Holaa"

        echo -e "grep '${email}' /var/log/v2ray/access.log | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq"

        output=$(grep "${email}" /var/log/v2ray/access.log | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq)

        echo -e "${output}"

        # Usa awk para procesar el archivo y extraer las IPs únicas, luego almacénalas en el array
        readarray -t unique_ips < <(grep "${email}" /var/log/v2ray/access.log | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq)

        # Cuenta las IPs únicas
        unique_ip_count=${#unique_ips[@]}

        echo -e "${VERDE}${email} ${unique_ip_count}"
    done <"${userdb}"

}

limitadorv2ray
