#!/bin/bash

intallv2ray() {
    showCabezera ">>> SE INSTALARA V2RAY <<<"
    
    source <(curl -sL https://raw.githubusercontent.com/NetVPS/LATAM_Oficial/main/Ejecutables/v2ray.sh)
    v2ray update
    mailfix=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 10)
    curl https://get.acme.sh | sh -s email=$mailfix@gmail.com
    #service v2ray restart
    msg -ama "Intalado con EXITO!"
    USRdatabase="/etc/SCRIPT-LATAM/RegV2ray"
    [[ ! -e ${USRdatabase} ]] && touch ${USRdatabase}
    sort ${USRdatabase} | uniq >${USRdatabase}tmp
    mv -f ${USRdatabase}tmp ${USRdatabase}
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    control_v2ray
}
