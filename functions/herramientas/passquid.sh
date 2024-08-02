#---PONER PASS SQUID
pass_squid() {
    squidpass() {
        tmp_arq="/tmp/arq-tmp"
        if [ -d "/etc/squid" ]; then
            pwd="/etc/squid/passwd"
            config_="/etc/squid/squid.conf"
            service_="squid"
            squid_="0"
        elif [ -d "/etc/squid3" ]; then
            pwd="/etc/squid3/passwd"
            config_="/etc/squid3/squid.conf"
            service_="squid3"
            squid_="1"
        fi
        [[ ! -e $config_ ]] &&
            msg -bar &&
            echo -e " \033[1;36m Proxy Squid no Instalado no puede proseguir" &&
            msg -bar &&
            return 0
        if [ -e $pwd ]; then
            echo -e "${cor[3]} Desea Desactivar Autentificasion del Proxy Squid"
            read -p " [S/N]: " -e -i n sshsn
            [[ "$sshsn" = @(s|S|y|Y) ]] && {
                msg -bar
                echo -e " \033[1;36mDesintalando Dependencias:"
                rm -rf /usr/bin/squid_log1
                fun_bar 'apt-get remove apache2-utils'
                msg -bar
                cat $config_ | grep -v '#Password' >$tmp_arq
                mv -f $tmp_arq $config_
                cat $config_ | grep -v '^auth_param.*passwd*$' >$tmp_arq
                mv -f $tmp_arq $config_
                cat $config_ | grep -v '^auth_param.*proxy*$' >$tmp_arq
                mv -f $tmp_arq $config_
                cat $config_ | grep -v '^acl.*REQUIRED*$' >$tmp_arq
                mv -f $tmp_arq $config_
                cat $config_ | grep -v '^http_access.*authenticated*$' >$tmp_arq
                mv -f $tmp_arq $config_
                cat $config_ | grep -v '^http_access.*all*$' >$tmp_arq
                mv -f $tmp_arq $config_
                echo -e "
http_access allow all" >>"$config_"
                rm -f $pwd
                service $service_ restart >/dev/null 2>&1 &
                echo -e " \033[1;31m Desautentificasion de Proxy Squid Desactivado"
                msg -bar
            }
        else
            echo -e "${cor[3]} "Confirmar Autentificasion ?""
            read -p " [S/N]: " -e -i n sshsn
            [[ "$sshsn" = @(s|S|y|Y) ]] && {
                msg -bar
                echo -e " \033[1;36mInstalando Dependencias:"
                echo "Archivo SQUID PASS" >/usr/bin/squid_log1
                fun_bar 'apt-get install apache2-utils'
                msg -bar
                read -e -p " Tu nombre de usuario deseado: " usrn
                [[ $usrn = "" ]] &&
                    msg -bar &&
                    echo -e " \033[1;31mEl usuario no puede ser nulo" &&
                    msg -bar &&
                    return 0
                htpasswd -c $pwd $usrn
                succes_=$(grep -c "$usrn" $pwd)
                if [ "$succes_" = "0" ]; then
                    rm -f $pwd
                    msg -bar
                    echo -e " \033[1;31m Error al generar la contraseña, no se inicio la autenticacion de Squid"
                    msg -bar
                    return 0
                elif [[ "$succes_" = "1" ]]; then
                    cat $config_ | grep -v '^http_access.*all*$' >$tmp_arq
                    mv -f $tmp_arq $config_
                    if [ "$squid_" = "0" ]; then
                        echo -e "#Password
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_access deny all" >>"$config_"
                        service squid restart >/dev/null 2>&1 &
                        update-rc.d squid defaults >/dev/null 2>&1 &
                    elif [ "$squid_" = "1" ]; then
                        echo -e "#Password
auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid3/passwd
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_access deny all" >>"$config_"
                        service squid3 restart >/dev/null 2>&1 &
                        update-rc.d squid3 defaults >/dev/null 2>&1 &
                    fi
                    msg -bar
                    service squid restart >/dev/null 2>&1
                    echo -e " \033[1;32m PROTECCION DE PROXY INICIADA"
                    msg -bar
                fi
            }
        fi
    }
    showCabezera "AUTENTIFICAR PROXY SQUID"
    unset squid_log1
    [[ -e /usr/bin/squid_log1 ]] && squid_log1="\033[1;32mACTIVO"
    echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \033[1;97m PONER CONTRASEÑA A SQUID $squid_log1\e[97m \n"
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > \033[1;97m" && msg -rojo "  \e[97m\033[1;41m VOLVER \033[1;37m"
    msg -bar
    echo -ne "\033[1;37mEscoja una Opcion: "
    read optons
    case $optons in
    1)
        msg -bar
        squidpass
        msg -bar
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    *)
        msg -bar
        ;;
    esac
}
