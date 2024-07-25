#!/bin/bash

monitorear_recursos() {
    while true; do
        clear
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;34m    Monitorear Recursos\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        echo -e "\e[1;32m1. Uso de CPU\e[0m"
        echo -e "\e[1;32m2. Uso de Memoria\e[0m"
        echo -e "\e[1;32m3. Uso de Disco\e[0m"
        echo -e "\e[1;31m0. Regresar al menú principal\e[0m"
        echo -e "\e[1;34m=========================\e[0m"
        read -p "Seleccione una opción: " opcion
        case $opcion in
        1)
            echo -e "\e[1;33mUso de CPU:\e[0m"
            top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
            read -p "Presione Enter para continuar..."
            ;;
        2)
            echo -e "\e[1;33mUso de Memoria:\e[0m"
            free -m | awk 'NR==2{printf "Uso de Memoria: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
            read -p "Presione Enter para continuar..."
            ;;
        3)
            echo -e "\e[1;33mUso de Disco:\e[0m"
            df -h | awk '$NF=="/"{printf "Uso de Disco: %d/%dGB (%s)\n", $3,$2,$5}'
            read -p "Presione Enter para continuar..."
            ;;
        0) break ;;
        *) echo -e "\e[1;31mOpción inválida, por favor intente de nuevo.\e[0m" ;;
        esac
    done
}
