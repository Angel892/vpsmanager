source /etc/vpsmanager/helpers/global.sh

# DESBLOQUEO Y LIMPIEZA
desbloqueo_auto() {

    unlockall3() {
        for user in $(cat /etc/passwd | awk -F : '$3 > 900 {print $1}' | grep -v "rick" | grep -vi "nobody"); do
            userpid=$(ps -u $user | awk {'print $1'})

            usermod -U $user &>/dev/null
        done
    }
    mostrar_totales() {
        for u in $(cat $mainPath/cuentasactivast | cut -d'|' -f1); do
            echo "$u"
        done
    }
    rm_user() {
        userdel --force "$1" &>/dev/null
    }
    rm_vencidos() {

        red=$(tput setaf 1)
        gren=$(tput setaf 2)
        yellow=$(tput setaf 3)
        txtvar=$(printf '%-42s' "\e[1;97m   USUARIOS")
        txtvar+=$(printf '%-1s' "\e[1;32m  VALIDIDEZ")
        echo -e "\033[1;92m${txtvar}"

        expired="${red}Usuario Expirado"
        valid="${gren}Usuario Vigente"
        never="${yellow}Usuario Ilimitado"
        removido="${red}Eliminado"
        DataVPS=$(date +%s)
        mostrar_usuariossh() {
            for u in $(cat $mainPath/cuentassh | cut -d'|' -f1); do
                echo "$u"
            done
        }
        mostrar_usuariohwid() {
            for u in $(cat $mainPath/cuentahwid | cut -d'|' -f1); do
                echo "$u"
            done
        }
        mostrar_usuariotoken() {
            for u in $(cat $mainPath/cuentatoken | cut -d'|' -f1); do
                echo "$u"
            done
        }

        #---SSH NORMAL

        while read user; do
            DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')
            usr=$user
            while [[ ${#usr} -lt 34 ]]; do
                usr=$usr" "
            done
            [[ "$DataUser" = " never" ]] && {
                echo -e "\e[1;97m$usr $never"
                continue
            }
            DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$DataVPS" ]]; then
                echo -ne "\e[1;97m$usr $expired"
                pkill -u $user &>/dev/null
                droplim=$(dropbear_pids | grep -w "$user" | cut -d'|' -f2)
                kill -9 $droplim &>/dev/null
                # droplim=`droppids|grep -w "$user"|cut -d'|' -f2`
                # kill -9 $droplim &>/dev/null
                rm_user "$user" && echo -e " y ($removido)"
                userb=$(cat $mainPath/cuentassh | grep -n -w $user | cut -d'|' -f1 | cut -d':' -f1)
                sed -i "${userb}d" $mainPath/cuentassh
            else
                echo -e "\e[1;97m$usr $valid"
            fi
        done <<<"$(mostrar_usuariossh)"
        #---SSH HWID
        while read user; do
            DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')
            usr=$user
            while [[ ${#usr} -lt 34 ]]; do
                usr=$usr" "
            done
            [[ "$DataUser" = " never" ]] && {
                echo -e "\e[1;97m$usr $never"
                continue
            }
            DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$DataVPS" ]]; then
                echo -ne "\e[1;97m$usr $expired"
                pkill -u $user &>/dev/null
                droplim=$(dropbear_pids | grep -w "$user" | cut -d'|' -f2)
                kill -9 $droplim &>/dev/null
                # droplim=`droppids|grep -w "$user"|cut -d'|' -f2`
                # kill -9 $droplim &>/dev/null
                rm_user "$user" && echo -e " y ($removido)"
                sed -i '/'$user'/d' $mainPath/cuentahwid
            else
                echo -e "\e[1;97m$usr $valid"
            fi
        done <<<"$(mostrar_usuariohwid)"

        #---SSH TOKEN
        while read user; do
            DataUser=$(chage -l "${user}" | grep -i co | awk -F ":" '{print $2}')
            usr=$user
            while [[ ${#usr} -lt 34 ]]; do
                usr=$usr" "
            done
            [[ "$DataUser" = " never" ]] && {
                echo -e "\e[1;97m$usr $never"
                continue
            }
            DataSEC=$(date +%s --date="$DataUser")
            if [[ "$DataSEC" -lt "$DataVPS" ]]; then
                echo -ne "\e[1;97m$usr $expired"
                pkill -u $user &>/dev/null
                droplim=$(dropbear_pids | grep -w "$user" | cut -d'|' -f2)
                kill -9 $droplim &>/dev/null
                # droplim=`droppids|grep -w "$user"|cut -d'|' -f2`
                # kill -9 $droplim &>/dev/null
                rm_user "$user" && echo -e "y ($removido)"
                sed -i '/'$user'/d' $mainPath/cuentatoken
            else
                echo -e "\e[1;97m$usr $valid"
            fi
        done <<<"$(mostrar_usuariotoken)"

        rm -rf $mainPath/temp/userlock
        rm -rf $mainPath/temp/userexp
        unlockall2

    }
    unlockall3 &>/dev/null
    # rm_vencidos &>/dev/null
}
