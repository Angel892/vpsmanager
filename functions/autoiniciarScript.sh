#!/bin/bash

autoiniciarScript() {
    clear
    showCabezera "Autoiniciar Script"

    if [[ -e /etc/bash.bashrc-bakup ]]; then
        mv -f /etc/bash.bashrc-bakup /etc/bash.bashrc
        cat /etc/bash.bashrc | grep -v "/etc/vpsmanager/adm.sh" >/tmp/bash
        mv -f /tmp/bash /etc/bash.bashrc
        msg -verde "Auto inicio removido con éxito."
    elif [[ -e /etc/bash.bashrc ]]; then
        cat /etc/bash.bashrc | grep -v "/etc/vpsmanager/adm.sh" >/etc/bash.bashrc.2
        echo '/etc/vpsmanager/adm.sh' >>/etc/bash.bashrc.2
        cp /etc/bash.bashrc /etc/bash.bashrc-bakup
        mv -f /etc/bash.bashrc.2 /etc/bash.bashrc
        msg -verde "Auto inicio agregado con éxito."
    fi

    msg -bar

    read -p "Presione Enter para continuar..."
    mainMenu
}
