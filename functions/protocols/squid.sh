#--- PROTOCOLO SQUID
proto_squid() {
    #ETHOOL SSH
    fun_eth() {
        eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
        [[ $eth != "" ]] && {
            msg -bar
            msg -amarillo "Aplicar el sistema para mejorar los paquetes SSH?"
            msg -amarillo "Opciones para usuarios avanzados"
            msg -bar
            read -p "[S/N]: " -e -i n sshsn
            tput cuu1 && tput dl1

            [[ "$sshsn" = @(s|S|y|Y) ]] && {
                msg -amarillo "Correccion de problemas de paquetes en SSH..."
                msg -bar
                msg -blanco "Cual es la tasa RX"
                msgne -amarillo "[ 1 - 999999999 ]: " && msgne -verde ""
                read rx
                [[ "$rx" = "" ]] && rx="999999999"

                msg -blanco "Cual es la tasa TX"
                msgne -amarillo "[ 1 - 999999999 ]: " && msgne -verde ""
                read tx
                [[ "$tx" = "" ]] && tx="999999999"
                apt-get install ethtool -y >/dev/null 2>&1
                ethtool -G $eth rx $rx tx $tx >/dev/null 2>&1
                msg -bar
            }
        }
    }

    fun_squid() {
        unset var_squid
        if [[ -e /etc/squid/squid.conf ]]; then
            var_squid="/etc/squid/squid.conf"
        elif [[ -e /etc/squid3/squid.conf ]]; then
            var_squid="/etc/squid3/squid.conf"
        fi
        [[ -e $var_squid ]] && {
            showCabezera "DESINSTALADO SQUID"

            msgInstall -blanco "Deteniendo squid"
            fun_bar "service squid stop"

            msgInstall -blanco "Removiendo squid"
            fun_bar "apt-get remove squid3 -y"

            msgSuccess
            [[ -e $var_squid ]] && rm $var_squid
            return
        }

        showCabezera "INSTALADOR SQUID | SCRIPT LXServer"
        
        IP=$(vpsIP)
        msgne -blanco "Confirme su ip: " && msgne -verde ""
        read -p " " -e -i $IP ip

        msg -bar
        msg -blanco "Puede activar varios puertosen forma secuencial"
        msg -verde "Ejemplo: 80 8080 8799 3128"
        msg -bar

        msgne -blanco "Digite losPuertos: " && msgne -verde ""
        read -p " " -e -i "8080 7999" portasx
        msg -bar

        totalporta=($portasx)
        unset PORT
        for ((i = 0; i < ${#totalporta[@]}; i++)); do
            msgne -blanco "Puerto Escojido: - "
            [[ $(mportas | grep "${totalporta[$i]}") = "" ]] && {
                msg -verde "${totalporta[$i]} OK"
                PORT+="${totalporta[$i]}\n"
            } || {
                msg -rojo "${totalporta[$i]} FAIL"
            }
        done

        [[ -z $PORT ]] && {
            msg -rojo "No se ha elegido ninguna puerto valido, reintente"
            msgError
            return 1
        }

        clear
        msg -bar
        msgCentrado -blanco "SEGUIMIENTO SQUID"
        msg -bar

        msgInstall -blanco "Instalando squid"
        #fun_bar "apt-get install squid -y"
        sudo apt-get install squid -y

        msg -bar
        msgCentrado -blanco "INICIANDO CONFIGURACION"
        echo -e ".bookclaro.com.br/\n.claro.com.ar/\n.claro.com.br/\n.claro.com.co/\n.claro.com.ec/\n.claro.com.gt/\n.cloudfront.net/\n.claro.com.ni/\n.claro.com.pe/\n.claro.com.sv/\n.claro.cr/\n.clarocurtas.com.br/\n.claroideas.com/\n.claroideias.com.br/\n.claromusica.com/\n.clarosomdechamada.com.br/\n.clarovideo.com/\n.facebook.net/\n.facebook.com/\n.netclaro.com.br/\n.oi.com.br/\n.oimusica.com.br/\n.speedtest.net/\n.tim.com.br/\n.timanamaria.com.br/\n.vivo.com.br/\n.rdio.com/\n.compute-1.amazonaws.com/\n.portalrecarga.vivo.com.br/\n.vivo.ddivulga.com/" >/etc/payloads
        msg -bar
        msgCentrado -blanco "Ahora Escoja Una Conf Para Su Proxy"
        msg -bar
        msg -blanco "|1| Basico"
        msg -blanco "|2| Avanzado"
        msg -bar
        read -p "[1/2]: " -e -i 1 proxy_opt
        tput cuu1 && tput dl1

        if [[ $proxy_opt = 1 ]]; then
            msgCentrado -verde "INSTALANDO SQUID BASICO"
        elif [[ $proxy_opt = 2 ]]; then
            msgCentrado -verde "INSTALANDO SQUID AVANZADO"
        else
            msgCentrado -verde "INSTALANDO SQUID BASICO"
            proxy_opt=1
        fi
        unset var_squid
        if [[ -d /etc/squid ]]; then
            var_squid="/etc/squid/squid.conf"
        elif [[ -d /etc/squid3 ]]; then
            var_squid="/etc/squid3/squid.conf"
        fi
        if [[ "$proxy_opt" = @(02|2) ]]; then
            echo -e "#ConfiguracaoSquiD
            acl url1 dstdomain -i $ip
            acl url2 dstdomain -i 127.0.0.1
            acl url3 url_regex -i '/etc/payloads'
            acl url4 url_regex -i '/etc/opendns'
            acl url5 dstdomain -i localhost
            acl accept dstdomain -i GET
            acl accept dstdomain -i POST
            acl accept dstdomain -i OPTIONS
            acl accept dstdomain -i CONNECT
            acl accept dstdomain -i PUT
            acl HEAD dstdomain -i HEAD
            acl accept dstdomain -i TRACE
            acl accept dstdomain -i OPTIONS
            acl accept dstdomain -i PATCH
            acl accept dstdomain -i PROPATCH
            acl accept dstdomain -i DELETE
            acl accept dstdomain -i REQUEST
            acl accept dstdomain -i METHOD
            acl accept dstdomain -i NETDATA
            acl accept dstdomain -i MOVE
            acl all src 0.0.0.0/0
            http_access allow url1
            http_access allow url2
            http_access allow url3
            http_access allow url4
            http_access allow url5
            http_access allow accept
            http_access allow HEAD
            http_access deny all

            # Request Headers Forcing

            request_header_access Allow allow all
            request_header_access Authorization allow all
            request_header_access WWW-Authenticate allow all
            request_header_access Proxy-Authorization allow all
            request_header_access Proxy-Authenticate allow all
            request_header_access Cache-Control allow all
            request_header_access Content-Encoding allow all
            request_header_access Content-Length allow all
            request_header_access Content-Type allow all
            request_header_access Date allow all
            request_header_access Expires allow all
            request_header_access Host allow all
            request_header_access If-Modified-Since allow all
            request_header_access Last-Modified allow all
            request_header_access Location allow all
            request_header_access Pragma allow all
            request_header_access Accept allow all
            request_header_access Accept-Charset allow all
            request_header_access Accept-Encoding allow all
            request_header_access Accept-Language allow all
            request_header_access Content-Language allow all
            request_header_access Mime-Version allow all
            request_header_access Retry-After allow all
            request_header_access Title allow all
            request_header_access Connection allow all
            request_header_access Proxy-Connection allow all
            request_header_access User-Agent allow all
            request_header_access Cookie allow all
            #request_header_access All deny all

            # Response Headers Spoofing

            #reply_header_access Via deny all
            #reply_header_access X-Cache deny all
            #reply_header_access X-Cache-Lookup deny all

            #portas" >$var_squid
            for pts in $(echo -e $PORT); do
                echo -e "http_port $pts" >>$var_squid
            done
            echo -e "
            #nome
            visible_hostname SCRIPT-LXServer

            via off
            forwarded_for off
            pipeline_prefetch off" >>$var_squid
        else
            echo -e "#Configuracion Squid
            acl localhost src 127.0.0.1/32 ::1
            acl to_localhost dst 127.0.0.0/8 ::1
            acl SSL_ports port 443
            acl Safe_ports port 80
            acl Safe_ports port 21
            acl Safe_ports port 443
            acl Safe_ports port 70
            acl Safe_ports port 210
            acl Safe_ports port 1025-65535
            acl Safe_ports port 280
            acl Safe_ports port 488
            acl Safe_ports port 591
            acl Safe_ports port 777
            acl CONNECT method CONNECT
            #acl SSH dst $ip-$ip/255.255.255.255
            acl SSH dst $ip/32
            http_access allow SSH
            http_access allow manager localhost
            http_access deny manager
            http_access allow localhost
            http_access deny all
            coredump_dir /var/spool/squid

            #Puertos" >$var_squid
            for pts in $(echo -e $PORT); do
                echo -e "http_port $pts" >>$var_squid
            done
            echo -e "
            #HostName
            visible_hostname SCRIPT-LXServer

            via off
            forwarded_for off
            pipeline_prefetch off" >>$var_squid
        fi
        touch /etc/opendns
        fun_eth

        msg -bar
        msgCentrado -amarillo "REINICIANDO SERVICIOS"

        msgInstall -blanco "squid3 -k reconfigure"
        fun_bar "squid3 -k reconfigure"

        msgInstall -blanco "squid -k reconfigure"
        fun_bar "squid -k reconfigure"

        msgInstall -blanco "service ssh restart"
        fun_bar "service ssh restart"

        msgInstall -blanco "service squid3 restart"
        fun_bar "service squid3 restart"

        msgInstall -blanco "service squid restart"
        fun_bar "service squid restart"

        #UFW
        for ufww in $(mportas | awk '{print $2}'); do
            ufw allow $ufww >/dev/null 2>&1
        done

        msgSuccess
    }

    agregarHost() {
        local payload="/etc/payloads"
        msgCentrado -blanco "Hosts Actuales Dentro del Squid"
        msg -bar

        cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
        msg -bar

        unset hos

        while [[ $hos != \.* ]]; do
            msgne -blanco "Escriba el nuevo host: " && msgne -verde ""
            read hos

            tput cuu1 && tput dl1
            [[ $hos = \.* ]] && continue
            echo -e "\033[1;31m Comience con ."
            sleep 3s
            tput cuu1 && tput dl1
        done

        host="$hos/"
        [[ -z $host ]] && return 1
        [[ $(grep -c "^$host" $payload) -eq 1 ]] && msg -rojo "Host ya Existe" && return 1

        echo "$host" >>$payload && grep -v "^$" $payload >/tmp/a && mv /tmp/a $payload
        msgCentrado -verde "Host Agregado con Exito"
        msg -bar
        cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
        msg -bar
        if [[ ! -f "/etc/init.d/squid" ]]; then
            msgInstall -blanco "service squid3 reload"
            fun_bar "service squid3 reload"

            msgInstall -blanco "service squid3 restart"
            fun_bar "service squid3 restart"

        else
            msgInstall -blanco "/etc/init.d/squid reload"
            fun_bar "/etc/init.d/squid reload"

            msgInstall -blanco "service squid restart"
            fun_bar "service squid restart"

        fi
    }

    removerHost() {
        local payload="/etc/payloads"
        msgCentrado -blanco "Hosts Actuales Dentro del Squid"
        msg -bar
        cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
        msg -bar

        unset hos

        while [[ $hos != \.* ]]; do
            msgne -blanco "Digite un Host: " && msgne -verde ""
            read hos
            tput cuu1 && tput dl1

            [[ $hos = \.* ]] && continue
            msg -rojo "Comience con ."
            sleep 3s
            tput cuu1 && tput dl1
        done

        host="$hos/"
        [[ -z $host ]] && return 1
        [[ $(grep -c "^$host" $payload) -ne 1 ]] && msg -rojo "Host No Encontrado" && return 1

        grep -v "^$host" $payload >/tmp/a && mv /tmp/a $payload
        msgCentrado -verde "Host Removido Con Exito"
        msg -bar

        cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
        msg -bar
        if [[ ! -f "/etc/init.d/squid" ]]; then        
            
            msgInstall -blanco "service squid3 reload"
            fun_bar "service squid3 reload"

            msgInstall -blanco "service squid3 restart"
            fun_bar "service squid3 restart"

            msgInstall -blanco "service squid reload"
            fun_bar "service squid reload"

            msgInstall -blanco "service squid restart"
            fun_bar "service squid restart"

        else
            msgInstall -blanco "service squid restart"
            fun_bar "service squid restart"

            msgInstall -blanco "service squid3 restart"
            fun_bar "service squid3 restart"
        fi

    }

    showCabezera "SQUID CONFIG"

    local num=1

    if [[ -e /etc/squid/squid.conf || -e /etc/squid3/squid.conf ]]; then

        # HOST SQUID
        opcionMenu -blanco $num "COLOCAR HOST EN SQUID"
        option[$num]="hostSquid"
        let num++

        # REMOVER HOST SQUID
        opcionMenu -blanco $num "REMOVER HOST DE SQUID"
        option[$num]="removeHostSquid"
        let num++

        # DESINSTALAR SQUID
        opcionMenu -blanco $num "DESINSTALAR SQUID"
        option[$num]="uninstall"
        let num++

    else
        # DESINSTALAR SQUID
        opcionMenu -blanco $num "INSTALAR SQUID"
        option[$num]="install"
        let num++
    fi

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "hostSquid")
        agregarHost
        ;;
    "removeHostSquid")
        removerHost
        ;;
    "uninstall")
        fun_squid
        ;;
    "install")
        fun_squid
        ;;

    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;
    esac

    proto_squid
}
