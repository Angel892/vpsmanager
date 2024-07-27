#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"


#funciones globales


autoiniciarScript() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}  Autoiniciar Script${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    if [[ -e /etc/bash.bashrc-bakup ]]; then
        mv -f /etc/bash.bashrc-bakup /etc/bash.bashrc
        cat /etc/bash.bashrc | grep -v "/etc/vpsmanager/adm.sh" >/tmp/bash
        mv -f /tmp/bash /etc/bash.bashrc
        echo -e "${VERDE}Auto inicio removido con éxito.${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
    elif [[ -e /etc/bash.bashrc ]]; then
        cat /etc/bash.bashrc | grep -v "/etc/vpsmanager/adm.sh" >/etc/bash.bashrc.2
        echo '/etc/vpsmanager/adm.sh' >>/etc/bash.bashrc.2
        cp /etc/bash.bashrc /etc/bash.bashrc-bakup
        mv -f /etc/bash.bashrc.2 /etc/bash.bashrc
        echo -e "${VERDE}Auto inicio agregado con éxito.${NC}"
        echo -e "${PRINCIPAL}=========================${NC}"
    fi

    read -p "Presione Enter para continuar..."
}
