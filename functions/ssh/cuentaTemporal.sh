#!/bin/bash

HELPERS_PATH="/etc/vpsmanager/helpers"

#funciones globales

demo_ssh() {

    rm -rf /etc/SCRIPT-LATAM/temp/demo-ssh 2>/dev/null
    mkdir /etc/SCRIPT-LATAM/temp/demo-ssh 2>/dev/null
    SCPdir="/etc/SCRIPT-LATAM"
    declare -A cor=([0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m")
    tmpusr() {
        time="$1"
        timer=$(($time * 60))
        timer2="'$timer's"
        echo "#!/bin/bash
        sleep $timer2
        kill"' $(ps -u '"$2 |awk '{print"' $1'"}') 1> /dev/null 2> /dev/null
        userdel --force $2
        rm -rf /tmp/$2
        exit" >/tmp/$2
    }

    tmpusr2() {
        time="$1"
        timer=$(($time * 60))
        timer2="'$timer's"
        echo "#!/bin/bash
        sleep $timer2
        kill=$(dropb | grep "$2" | awk '{print $2}')
        kill $kill
        userdel --force $2
        rm -rf /tmp/$2
        exit" >/tmp/$2
    }
    clear && clear
    msg -bar
    msg -tit
    msg -bar
    msg -ama "        CREAR USUARIO POR TIEMPO (Minutos)"
    msg -bar
    echo -e "\033[1;97m Los Usuarios que cres en esta opcion se eliminaran\n automaticamete pasando el tiempo designado.\033[0m"
    msg -bar
    echo -ne "\033[1;91m [1]- \033[1;93mDigite Nuevo Usuario:\033[1;32m " && read name
    if [[ -z $name ]]; then
        echo "No a digitado el Nuevo Usuario"
        exit
    fi
    if cat /etc/passwd | grep $name: | grep -vi [a-z]$name | grep -v [0-9]$name >/dev/null; then
        echo -e "\033[1;31mUsuario $name ya existe\033[0m"
        exit
    fi
    echo -ne "\033[1;91m [2]- \033[1;93mDigite Nueva Contraseña:\033[1;32m " && read pass
    echo -ne "\033[1;91m [3]- \033[1;93mDigite Tiempo (Minutos):\033[1;32m " && read tmp
    if [ "$tmp" = "" ]; then
        tmp="30"
        echo -e "\033[1;32mFue Definido 30 minutos Por Defecto!\033[0m"
        msg -bar
        sleep 2s
    fi
    useradd -m -s /bin/false $name
    (
        echo $pass
        echo $pass
    ) | passwd $name 2>/dev/null
    touch /tmp/$name
    tmpusr $tmp $name
    chmod 777 /tmp/$name
    touch /tmp/cmd
    chmod 777 /tmp/cmd
    echo "nohup /tmp/$name & >/dev/null" >/tmp/cmd
    /tmp/cmd 2>/dev/null 1>/dev/null
    rm -rf /tmp/cmd
    touch /etc/SCRIPT-LATAM/temp/demo-ssh/$name
    echo "senha: $pass" >>/etc/SCRIPT-LATAM/temp/demo-ssh/$name
    echo "data: ($tmp)Minutos" >>/etc/SCRIPT-LATAM/temp/demo-ssh/$name
    msg -bar2
    echo -e "\033[1;93m        ¡¡  USUARIO TEMPORAL x MINUTOS  !!\033[1;0m"
    msg -bar2
    echo -e "\033[1;97m\e[38;5;202m IP del Servidor: \033[1;32m$(meu_ip) "
    echo -e "\e[38;5;202m Usuario: \033[1;32m$name"
    echo -e "\e[38;5;202m Contraseña: \033[1;32m$pass"
    echo -e "\e[38;5;202m Minutos de Duración: \033[1;32m$tmp"
    msg -bar2
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
    controlador_ssh

}

crearCuentaTemporalSSH() {
    clear
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}    Crear nueva cuenta SSH TEMPORAL${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"

    while true; do
        read -p "Ingrese el nombre del nuevo usuario: " username
        if [ -z "$username" ]; then
            echo -e "${ROJO}Error: El nombre de usuario no puede estar vacío.${NC}"
        elif id "$username" &>/dev/null; then
            echo -e "${ROJO}Error: El usuario '$username' ya existe.${NC}"
        else
            break
        fi
    done

    while true; do
        read -s -p "Ingrese la contraseña para el nuevo usuario: " password
        echo
        if [ -z "$password" ]; then
            echo -e "${ROJO}Error: La contraseña no puede estar vacía.${NC}"
        elif [[ ${#password} -lt 8 ]]; then
            echo -e "${ROJO}Error: La contraseña debe tener al menos 8 caracteres.${NC}"
        else
            break
        fi
    done

    while true; do
        read -p "Ingrese la duración de la cuenta (en minutos): " duration
        if [ -z "$duration" ]; then
            echo -e "${ROJO}Error: La duración no puede estar vacía.${NC}"
        elif ! [[ "$duration" =~ ^[0-9]+$ ]]; then
            echo -e "${ROJO}Error: La duración debe ser un número válido.${NC}"
        else
            break
        fi
    done

    while true; do
        read -p "Ingrese el límite de conexiones para el usuario: " limit
        if [ -z "$limit" ]; then
            echo -e "${ROJO}Error: El límite de conexiones no puede estar vacío.${NC}"
        elif ! [[ "$limit" =~ ^[0-9]+$ ]]; then
            echo -e "${ROJO}Error: El límite debe ser un número válido.${NC}"
        else
            break
        fi
    done

    # Obtener la IP del servidor
    server_ip=$(hostname -I | awk '{print $1}')

    # Crear el usuario sin contraseña
    sudo adduser --disabled-password --gecos "" "$username"

    # Asignar la contraseña al usuario de forma no interactiva
    echo "$username:$password" | sudo chpasswd

    # Establecer la fecha de expiración de la cuenta en minutos
    expiration_date=$(date -d "+${duration} minutes" +%Y-%m-%dT%H:%M:%S)

    sudo chage -E "$(date -d "$expiration_date" +%Y-%m-%d)" "$username"

    # Programar la eliminación del usuario después de la duración especificada
    echo "sudo userdel -r $username" | sudo at now + $duration minutes

    # Establecer el límite de conexiones
    echo "$username hard maxlogins $limit" | sudo tee -a /etc/security/limits.conf

    clear

    echo -e "${VERDE}Cuenta SSH creada con éxito.${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${PRINCIPAL}Detalles de la cuenta${NC}"
    echo -e "${PRINCIPAL}=========================${NC}"
    echo -e "${VERDE}IP del servidor: ${NC}$server_ip"
    echo -e "${VERDE}Usuario: ${NC}$username"
    echo -e "${VERDE}Contraseña: ${NC}$password"
    echo -e "${VERDE}Duración: ${NC}$duration minutos"
    echo -e "${VERDE}Límite de conexiones: ${NC}$limit"
    echo -e "${PRINCIPAL}=========================${NC}"
    read -p "Presione Enter para continuar..."
}
