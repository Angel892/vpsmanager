#!/bin/bash

eliminar_script() {
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msgCentrado -amarillo "¿ DESEA DESINSTALAR SCRIPT ?"
    msg -bar
    msgCentrado -blanco "Esto borrara todos los archivos LXManager"
    msg -bar
    while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
        read -p " [ S / N ]: " yesno
        tput cuu1 && tput dl1
    done
    if [[ ${yesno} = @(s|S|y|Y) ]]; then
        [[ -e /bin/adm ]] && sudo rm /bin/adm
        [[ -e /usr/bin/adm ]] && sudo rm /usr/bin/adm
        [[ -e /bin/ADM ]] && sudo rm /bin/ADM
        [[ -e /usr/bin/adm ]] && sudo rm /usr/bin/adm
        [[ -d /etc/vpsmanager ]] && sudo rm -rf /etc/vpsmanager &>/dev/null
        
        msgInstall "Removiendo squid"
        fun_bar "sudo apt-get --purge remove squid -y"

        msgInstall "Removiendo stunnel4"
        fun_bar "sudo apt-get --purge remove stunnel4 -y"

        msgInstall "Removiendo dropbear"
        fun_bar "sudo apt-get --purge remove dropbear -y"

        rm -rf /root/* >/dev/null 2>&1
        cd /root
        clear && clear
        exit
        exit
    fi
}
