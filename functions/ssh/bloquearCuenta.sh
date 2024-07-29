#!/bin/bash

bloquearDesbloquearUsuarioSSH() {
    clear && clear
    msg -bar

    local USRloked="$mainPath/temp/userlock"
    validarArchivo "$USRloked"

    ##-->>GENERAR USUARIOS TOTALES
    cat $mainPath/cuentassh $mainPath/cuentahwid $mainPath/cuentatoken 2>/dev/null | cut -d '|' -f1 >$mainPath/cuentasactivas
    if [[ -e "$mainPath/cuentasactivas" ]]; then
        readarray -t mostrar_totales < <(cut -d '|' -f1 $mainPath/cuentasactivas)
    fi

    GetAllUsers

    msg -bar
    msgCentrado -amarillo "Escriba o Seleccione un Usuario"
    msg -bar
    unset selection

    while [[ ${selection} = "" ]]; do
        echo -ne "\033[1;97m No. \e[1;32m" && read selection
        tput cuu1 && tput dl1
    done
    if [[ ! $(echo "${selection}" | egrep '[^0-9]') ]]; then
        usuario_del="${mostrar_totales[$selection]}"
    else
        usuario_del="$selection"
    fi
    [[ -z $usuario_del ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        return 1
    }
    [[ ! $(echo ${mostrar_totales[@]} | grep -w "$usuario_del") ]] && {
        msg -rojo "Error, Usuario Invalido"
        msg -bar
        return 1
    }
    msg -ne " " && echo -ne "\e[1;36m$usuario_del "
    block_userfun "$usuario_del" && msg -rojo "[ Bloqueado ]" || msg -verd "[ Desbloqueado ]"
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    controlador_ssh
}
