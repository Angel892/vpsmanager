#!/bin/bash

source /etc/vpsmanager/helpers/global.sh

limitadorv2ray() {
    local userdb="${mainPath}/RegV2ray"

    while IFS='|' read -r uuid email user limite dateExp; do
        echo -e "${VERDE}${email}"
    done <"${userdb}"

}
