#!/bin/bash

#--- FUNCION INFORMACION DE SISTEMA
monitorear_recursos() {
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msg -amarillo "                DETALLES DEL SISTEMA"
    null="\033[1;31m"
    msg -bar
    if [ ! /proc/cpuinfo ]; then
        msg -rojo "Sistema No Soportado" && msg -bar
        return 1
    fi
    if [ ! /etc/issue.net ]; then
        msg -rojo "Sistema No Soportado" && msg -bar
        return 1
    fi
    if [ ! /proc/meminfo ]; then
        msg -rojo "Sistema No Soportado" && msg -bar
        return 1
    fi
    totalram=$(free | grep Mem | awk '{print $2}')
    usedram=$(free | grep Mem | awk '{print $3}')
    freeram=$(free | grep Mem | awk '{print $4}')
    swapram=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
    system=$(cat /etc/issue.net)
    clock=$(lscpu | grep "CPU MHz" | awk '{print $3}')
    based=$(cat /etc/*release | grep ID_LIKE | awk -F "=" '{print $2}')
    processor=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F ":" '{print $2}')
    cpus=$(cat /proc/cpuinfo | grep processor | wc -l)
    [[ "$system" ]] && msg -amarillo "Sistema Operativo: ${null}$system" || msg -amarillo "Sistema: ${null}???"
    [[ "$based" ]] && msg -amarillo "Base de SO: ${null}$based" || msg -amarillo "Base: ${null}???"
    [[ "$processor" ]] && msg -amarillo "Procesador: ${null}$processor x$cpus" || msg -amarillo "Procesador: ${null}???"
    [[ "$clock" ]] && msg -amarillo "Frecuencia de Operacion: ${null}$clock MHz" || msg -amarillo "Frecuencia de Operacion: ${null}???"
    msg -amarillo "Uso del Procesador: ${null}$(ps aux | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf " " "%.2f" "%%", sum}')"
    msg -amarillo "Memoria Virtual Total: ${null}$(($totalram / 1024))"
    msg -amarillo "Memoria Virtual En Uso: ${null}$(($usedram / 1024))"
    msg -amarillo "Memoria Virtual Libre: ${null}$(($freeram / 1024))"
    msg -amarillo "Memoria Virtual Swap: ${null}$(($swapram / 1024))MB"
    msg -amarillo "Tiempo Online: ${null}$(uptime)"
    msg -amarillo "Nombre De La Maquina: ${null}$(hostname)"
    msg -amarillo "IP De La  Maquina: ${null}$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')"
    msg -amarillo "Version de Kernel: ${null}$(uname -r)"
    msg -amarillo "Arquitectura: ${null}$(uname -m)"
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
}
