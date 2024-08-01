#!/bin/bash

intallv2ray() {
    showCabezera ">>> SE INSTALARA V2RAY <<<"

    source <(curl -sL https://github.com/Angel892/vpsmanager/raw/master/install/v2ray/v2ray.sh)
    v2ray update
    mailfix=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 10)
    curl https://get.acme.sh | sh -s email=$mailfix@gmail.com
    #service v2ray restart
    msg -amarillo "Intalado con EXITO!"
    USRdatabase="$mainPath/RegV2ray"
    [[ ! -e ${USRdatabase} ]] && touch ${USRdatabase}
    sort ${USRdatabase} | uniq >${USRdatabase}tmp
    mv -f ${USRdatabase}tmp ${USRdatabase}
    msgSuccess
}
