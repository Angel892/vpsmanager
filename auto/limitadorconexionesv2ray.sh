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

        # Unir los elementos del array en una sola cadena separada por comas
        unique_ips_joined=$(
            IFS=,
            echo "${unique_ips[*]}"
        )

        if [[ $unique_ip_count -gt $limite ]]; then

            for ip in "${unique_ips[@]}"; do
                ss --tcp | grep -E "${ip}" | awk '{if($1=="ESTAB") print $4,$5;}' | sort | uniq -c | sort -nr | head | while read -r count src dest; do

                    srcIp=$(echo "$src" | grep -oE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
                    srcPort=$(echo "$src" | grep -oE ':([0-9]+)' | tr -d ':')

                    destIp=$(echo "$dest" | grep -oE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
                    destPort=$(echo "$dest" | grep -oE ':([0-9]+)' | tr -d ':')

                    echo -e "${srcIp} | ${srcPort} | ${destIp} | ${destIp}"

                done
            done

            msgne -amarillo "${email} | ${limite} | ${unique_ip_count} | ${unique_ips_joined}"
            echo -e ""

        fi

    done <"${userdb}"

}

limitadorv2ray
