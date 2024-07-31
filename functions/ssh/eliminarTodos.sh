#!/bin/bash

eliminarTodosUsuariosSSH() {
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\033[1;31m       BORRAR TODOS LOS USUARIOS REGISTRADOS"
    msg -bar
    read -p "   ►► Enter para Continuar  o CTRL + C Cancelar ◄◄"
    echo ""
    for user in $(cat /etc/passwd | awk -F : '$3 > 900 {print $1}' | grep -v "rick" | grep -vi "nobody"); do
        userdel --force $user
        echo -e "\033[1;32mUSUARIO:\033[1;33m $user \033[1;31mEliminado"
    done
    rm -rf $mainPath/cuentassh &>/dev/null
    rm -rf $mainPath/cuentahwid &>/dev/null
    rm -rf $mainPath/cuentatoken &>/dev/null
    service sshd restart &>/dev/null
    service ssh restart &>/dev/null
    service dropbear start &>/dev/null
    service stunnel4 start &>/dev/null
    service squid restart &>/dev/null
    rm -rf $mainPath/temp/userlock &>/dev/null
    rm -rf $mainPath/temp/Limiter.log &>/dev/null
    unlockall2
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    menuSSH
}
