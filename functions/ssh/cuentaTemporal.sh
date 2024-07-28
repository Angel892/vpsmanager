#!/bin/bash

crearCuentaTemporalSSH() {

    local temporalPath="$mainPath/temp/demo-ssh"

    rm -rf $temporalPath #2>/dev/null
    mkdir $temporalPath  #2>/dev/null
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

    while true; do
        clear && clear

        echo "$temporalPath"

        msg -bar
        msg -tit
        msg -bar
        msgCentrado -amarillo "CREAR USUARIO POR TIEMPO (Minutos)"
        msg -bar
        msg -blanco "Los Usuarios que cres en esta opcion se eliminaran\n automaticamete pasando el tiempo designado."
        msg -bar
        msg -blanco "Digite Nuevo Usuario: " && read name
        if [[ -z $name ]]; then
            msg -rojo "No a digitado el Nuevo Usuario"
            sleep 2
            continue
        fi
        if cat /etc/passwd | grep $name: | grep -vi [a-z]$name | grep -v [0-9]$name >/dev/null; then
            msg -rojo "Usuario $name ya existe"
            sleep 2
            continue
        fi
        msg -blanco "Digite Nueva Contraseña: " && read pass
        msg -blanco "Digite Tiempo (Minutos): " && read tmp
        if [ "$tmp" = "" ]; then
            tmp="30"
            msg -verde "Fue Definido 30 minutos Por Defecto!"
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
        touch $temporalPath/$name
        echo "senha: $pass" >>$temporalPath/$name
        echo "data: ($tmp)Minutos" >>$temporalPath/$name
        msg -bar
        msgCentrado -verde "¡¡  USUARIO TEMPORAL x MINUTOS  !!"
        msg -bar
        echo -e "\033[1;97m\e[38;5;202m IP del Servidor: \033[1;32m$(vpsIP) "
        echo -e "\e[38;5;202m Usuario: \033[1;32m$name"
        echo -e "\e[38;5;202m Contraseña: \033[1;32m$pass"
        echo -e "\e[38;5;202m Minutos de Duración: \033[1;32m$tmp"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        break;
    done
}
