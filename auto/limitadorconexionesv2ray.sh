#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

limitadorv2ray() {
    local userdb="${mainPath}/RegV2ray"

    while IFS='|' read -r uuid email user limite dateExp; do

        # Usa awk para procesar el archivo y extraer las IPs únicas, luego almacénalas en el array
        #readarray -t unique_ips < <(grep "${email}" /var/log/v2ray/access.log | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}' | sort | uniq)

        # Cuenta las IPs únicas
        #unique_ip_count=${#unique_ips[@]}

        #echo -e "${VERDE}${email} ${unique_ip_count}"

        echo "Procesando usuario: $email"

        # Depuración: Verificar la salida de grep
        grep_output=$(grep "${email}" /var/log/v2ray/access.log)
        echo "Salida de grep para ${email}:"
        echo "$grep_output"

        # Depuración: Verificar la salida de awk
        awk_output=$(echo "$grep_output" | awk '{match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):/, ip); if (ip[1] != "") print ip[1]}')
        echo "Salida de awk para ${email}:"
        echo "$awk_output"

        # Usa awk para procesar el archivo y extraer las IPs únicas, luego almacénalas en el array
        readarray -t unique_ips < <(echo "$awk_output" | sort | uniq)

        # Depuración: Imprime las IPs encontradas
        echo "IPs encontradas para ${email}:"
        for ip in "${unique_ips[@]}"; do
            echo "$ip"
        done

        # Cuenta las IPs únicas
        unique_ip_count=${#unique_ips[@]}

        # Imprime el email y el número de IPs únicas
        echo -e "${VERDE}${email}: ${unique_ip_count} IPs únicas"
    done <"${userdb}"

}

limitadorv2ray
