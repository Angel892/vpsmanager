#!/bin/bash

#BACKUP USER SSH
backupUsuariosSSH() {
    clear && clear
    backupssh() {
        rm -rf /root/backup-lxmanager/ >/dev/null 2>&1
        apt install sshpass >/dev/null 2>&1
        mkdir /root/backup-lxmanager/
        export UGIDLIMIT=1000
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd >/root/backup-lxmanager/passwd.mig
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group >/root/backup-lxmanager/group.mig
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - | egrep -f - /etc/shadow >/root/backup-lxmanager/shadow.mig
        cp /etc/gshadow /root/backup-lxmanager/gshadow.mig >/dev/null 2>&1
        cp $mainPath/cuentassh /root/backup-lxmanager/cuentassh >/dev/null 2>&1
        cp $mainPath/cuentahwid /root/backup-lxmanager/cuentahwid >/dev/null 2>&1
        cp $mainPath/cuentatoken /root/backup-lxmanager/cuentatoken >/dev/null 2>&1
        cp $mainPath/temp/.passw /root/backup-lxmanager/.passw >/dev/null 2>&1
        tar -zcvpf /root/backup-lxmanager/home.tar.gz /home >/dev/null 2>&1
        echo -ne "\e[1;97mDigite usuario root del Nuevo VPS:\033[1;92m " && read useroot
        echo -ne "\e[1;97mDigite IP del Nuevo VPS:\033[1;92m " && read ipvps
        echo -ne "\e[1;97mDigite Contraseña del Nuevo VPS:\033[1;92m " && read passvps
        echo ""
        sshpass -p "$passvps" scp -o "StrictHostKeyChecking no" -r /root/backup-lxmanager/ "$useroot"@"$ipvps":/root/
        msg -verde " Procedimiento Hecho con Exito, Guardado en:"
        echo ""
        echo -e "\033[1;31m   BACKUP > [\033[1;32m/root/backup-lxmanager/\033[1;31m]"

    }

    restaurarback() {
        echo -ne "\033[1;37m ¡¡Recomiendo DESACTIVAR LIM/DES!!\n"
        msg -bar
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"

        [[ -e /root/Backup-lxmanager.tar.gz ]] && {
            rm -rf /root/backup-lxmanager
            tar -xzvf Backup-lxmanager.tar.gz
        }
        msg -bar
        mkdir /root/users.bk
        cp /etc/passwd /etc/shadow /etc/group /etc/gshadow /root/users.bk
        cd /root/backup-lxmanager/
        cat passwd.mig >>/etc/passwd
        cat group.mig >>/etc/group
        cat shadow.mig >>/etc/shadow
        /bin/cp gshadow.mig /etc/gshadow
        cat cuentassh >$mainPath/cuentassh
        cat cuentahwid >$mainPath/cuentahwid
        cat cuentatoken >$mainPath/cuentatoken
        cat .passw >$mainPath/temp/.passw
        cd /
        tar -zxvf /root/backup-lxmanager/home.tar.gz
        echo ""
        msg -verde " Procedimiento Hecho con Exito, Reinicie su VPS"
    }

    msg -bar
    msg -tit
    msg -bar
    msgCentrado -amarillo "HERRAMIENTA DE BACKUP DE USUARIOS"
    msg -bar
    echo -e "\e[1;31m >>\e[1;97m Se generara un backup y enviara a la VPS Nueva\033[1;92m "
    echo -e "\e[1;31m >>\e[1;97m Tenga su VPS Nueva ya configurada \033[1;92m "
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m CREAR BACKUP REMOTO   \e[97m \n"
    echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m RESTAURAR BACKUP\e[97m \n"
    msg -bar
    unset selection
    while [[ ${selection} != @([1-2]) ]]; do
        echo -ne "\033[1;37mSeleccione una Opcion: " && read selection
        tput cuu1 && tput dl1
    done
    case ${selection} in
    1)
        backupssh
        ;;
    2)
        restaurarback
        ;;
    esac
    echo ""
    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    menuSSH
}
