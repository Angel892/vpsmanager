#!/bin/bash

#--- MONITOR HTOP
monhtop() {
    showCabezera "MONITOR DE PROCESOS HTOP"
    msgCentrado -blanco "RECUERDA SALIR CON :"
    msgCentrado -verde "CTRL + C o FIN + F10"

    [[ $(dpkg --get-selections | grep -w "htop" | head -1) ]] || apt-get install htop -y &>/dev/null
    msg -bar
    read -t 10 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    showCabezera "MONITOR DE PROCESOS HTOP"
    sudo htop
    msg -bar 
    msgCentrado -blanco "FIN DEL MONITOR"
    msg -bar
}
