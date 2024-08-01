#--- INSTALAR SSL
proto_ssl() {

    ssl_stunel() {
        clear
        clear
        [[ $(mportas | grep stunnel4 | head -1) ]] && {
            msg -bar
            msgCentrado -blanco "DESINSTALANDO SSL"
            msg -bar

            msgInstall -blanco "Deteniendo ssl"
            fun_bar "service stunnel4 stop"

            msgInstall -blanco "Eliminando ssl"
            fun_bar "apt-get purge stunnel4 -y"

            msgSuccess
            return
        }

        showCabezera "INSTALADOR SSL SCRIPT LXServer"

        msg -blanco "Seleccione un puerto de anclaje."
        msg -blanco "Puede ser un SSH/DROPBEAR/SQUID/OPENVPN/WEBSOCKET"
        msg -bar
        while true; do
            msgne -blanco "Puerto-Local:" && msgne -verde
            read -p " " -e -i "22" portx
            if [[ ! -z $portx ]]; then
                if [[ $(echo $portx | grep "[0-9]") ]]; then
                    [[ $(mportas | grep $portx | awk '{print $2}' | head -1) ]] && break || msg -rojo "Puerto Invalido - Reintente con otro Activo"
                fi
            fi
        done
        msg -bar
        # DPORT="$(mportas | grep $portx | awk '{print $2}' | head -1)"
        msgCentrado -blanco "Ahora Que Puerto sera SSL"
        msg -bar
        while true; do
            msgne -blanco "Puerto para SSL:" && msgne -verde ""
            read -p " " -e -i "443" SSLPORT
            [[ $(mportas | grep -w "$SSLPORT") ]] || break
            msg -rojo "Este Puerto esta en Uso"
            unset SSLPORT
        done
        msg -bar
        msgCentrado -verde "Instalando SSL"
        msg -bar

        fun_bar "apt-get install stunnel4 -y"

        msg -bar
        msg -amarillo "A continuacion se le pediran datos de su crt si\n desconoce que datos lleva presione puro ENTER"
        msg -bar

        cat <<EOF >/etc/stunnel/stunnel.conf
pid = /var/run/stunnel4/stunnel.pid
client = no
[SSL]
cert = /etc/stunnel/stunnel.pem
accept = ${SSLPORT}
connect = 127.0.0.1:${portx}
EOF

        ####Coreccion2.0#####
        openssl genrsa -out stunnel.key 2048 >/dev/null 2>&1
        # (echo "mx" ; echo "mx" ; echo "mx" ; echo "mx" ; echo "mx" ; echo "mx" ; echo "@vpsmx" )|openssl req -new -key stunnel.key -x509 -days 1000 -out stunnel.crt > /dev/null 2>&1
        openssl req -new -key stunnel.key -x509 -days 1000 -out stunnel.crt
        cat stunnel.crt stunnel.key >stunnel.pem
        mv stunnel.pem /etc/stunnel/
        ##-->> AutoInicio
        sed -i '/ENABLED=[01]/d' /etc/default/stunnel4
        echo "ENABLED=1" >>/etc/default/stunnel4
        service stunnel4 restart >/dev/null 2>&1

        rm -rf $mainPath/stunnel.crt >/dev/null 2>&1
        rm -rf $mainPath/stunnel.key >/dev/null 2>&1
        rm -rf /root/stunnel.crt >/dev/null 2>&1
        rm -rf /root/stunnel.key >/dev/null 2>&1

        msgSuccess
    }

    ssl_stunel_2() {
        showCabezera "AGREGAR MAS PUESRTOS SSL"

        msg -blanco "Seleccione un puerto de anclaje."
        msg -verde "Puede ser un SSH/DROPBEAR/SQUID/OPENVPN/SSL/PY"
        msg -bar

        while true; do
            msgne -blanco "Puerto-Local: " && msgne -verde ""
            read portx
            if [[ ! -z $portx ]]; then
                if [[ $(echo $portx | grep "[0-9]") ]]; then
                    [[ $(mportas | grep $portx | head -1) ]] && break || msg -rojo "Puerto Invalido - Reintente con otro Activo"
                fi
            fi
        done

        msg -bar
        # DPORT="$(mportas | grep $portx | awk '{print $2}' | head -1)"
        msgCentrado -blanco "Ahora Que Puerto sera SSL"
        msg -bar

        while true; do
            msgne -blanco "Puerto-SSL: " && msgne -verde ""
            read SSLPORT
            [[ $(mportas | grep -w "$SSLPORT") ]] || break
            msg -rojo "Este Puerto esta en Uso"
            unset SSLPORT
        done

        msg -bar
        cat <<EOF >>/etc/stunnel/stunnel.conf
client = no
[SSL+]
cert = /etc/stunnel/stunnel.pem
accept = ${SSLPORT}
connect = 127.0.0.1:${portx}
EOF
        ##-->> AutoInicio
        sed -i '/ENABLED=[01]/d' /etc/default/stunnel4
        echo "ENABLED=1" >>/etc/default/stunnel4
        service stunnel4 restart >/dev/null 2>&1

        rm -rf $mainPath/stunnel.crt >/dev/null 2>&1
        rm -rf $mainPath/stunnel.key >/dev/null 2>&1
        rm -rf /root/stunnel.crt >/dev/null 2>&1
        rm -rf /root/stunnel.key >/dev/null 2>&1

        msgSuccess
    }
    cert_ssl() {
        showCabezera "AGREGAR CERTIFICADO MANUAL"

        msg -amarillo "Tenga ya su SSL activo y configurado Previamente"
        msg -verde ">> Suba su certificado en zip a Dropbox"
        msg -bar

        msgne -blanco "Pegue el link Abajo:" && msg -verde ""
        read linkd

        wget $linkd -O /etc/stunnel/certificado.zip &>/dev/null
        cd /etc/stunnel/
        unzip -o certificado.zip &>/dev/null
        cat private.key certificate.crt ca_bundle.crt >stunnel.pem

        ##-->> AutoInicio
        sed -i '/ENABLED=[01]/d' /etc/default/stunnel4
        echo "ENABLED=1" >>/etc/default/stunnel4
        systemctl start stunnel4 &>/dev/null
        systemctl start stunnel &>/dev/null
        systemctl restart stunnel4 &>/dev/null
        systemctl restart stunnel &>/dev/null
        cd

        msgSuccess
    }

    certificadom() {

        if [ -f /etc/stunnel/stunnel.conf ]; then
            insapa2() {
                for pid in $(pgrep python); do
                    kill $pid
                done
                for pid in $(pgrep apache2); do
                    kill $pid
                done
                service dropbear stop
                apt install apache2 -y
                echo "Listen 80

                    <IfModule ssl_module>
                            Listen 443
                    </IfModule>
                    
                    <IfModule mod_gnutls.c>
                            Listen 443
                    </IfModule> " >/etc/apache2/ports.conf
                service apache2 restart
            }

            showCabezera "AGREGAR CERTIFICADO ZEROSSL"

            msg -amarillo "Verificar dominio.........."
            msg -amarillo "TIENES QUE MODIFICAR EL ARCHIVO DESCARGADO"
            msg -verde "EJEMPLO: 530DDCDC3 comodoca.com 7bac5e210"
            msg -bar
            read -p " LLAVE > Nombre Del Archivo: " keyy
            msg -bar
            read -p " DATOS > De La LLAVE: " dat2w

            [[ ! -d /var/www/html/.well-known ]] && mkdir /var/www/html/.well-known
            [[ ! -d /var/www/html/.well-known/pki-validation ]] && mkdir /var/www/html/.well-known/pki-validation
            datfr1=$(echo "$dat2w" | awk '{print $1}')
            datfr2=$(echo "$dat2w" | awk '{print $2}')
            datfr3=$(echo "$dat2w" | awk '{print $3}')
            echo -ne "${datfr1}\n${datfr2}\n${datfr3}" >/var/www/html/.well-known/pki-validation/$keyy.txt

            msg -bar
            msg -amarillo "VERIFIQUE EN LA PÁGINA ZEROSSL"
            msg -bar
            read -p " ENTER PARA CONTINUAR"
            clear

            msg -bar
            msgCentrado -blanco "👇 LINK DEL CERTIFICADO 👇" && echo -e ""
            msgne -blanco "LINK: " && msg -verde ""
            read link

            incertis() {
                wget $link -O /etc/stunnel/certificado.zip
                cd /etc/stunnel/
                unzip certificado.zip
                cat private.key certificate.crt ca_bundle.crt >stunnel.pem
                ##-->> AutoInicio
                sed -i '/ENABLED=[01]/d' /etc/default/stunnel4
                echo "ENABLED=1" >>/etc/default/stunnel4
                systemctl start stunnel4 &>/dev/null
                systemctl start stunnel &>/dev/null
                systemctl restart stunnel4 &>/dev/null
                systemctl restart stunnel &>/dev/null
            }
            incertis &>/dev/null && echo -e " \e[1;33mEXTRAYENDO CERTIFICADO " | pv -qL 10
            msg -bar
            msgCentrado -verde "CERTIFICADO INSTALADO"
            msg -bar

            for pid in $(pgrep apache2); do
                kill $pid
            done
            apt install apache2 -y &>/dev/null
            echo "Listen 81

                    <IfModule ssl_module>
                            Listen 443
                    </IfModule>

                    <IfModule mod_gnutls.c>
                            Listen 443
                    </IfModule> " >/etc/apache2/ports.conf
            service apache2 restart &>/dev/null
            service dropbear start &>/dev/null
            service dropbear restart &>/dev/null

            validarArchivo "$mainPath/PortM/PDirect.log"
            validarArchivo "$mainPath/filespy/PDirect-8081.py"

            for port in $(cat $mainPath/PortM/PDirect.log | grep -v "nobody" | cut -d' ' -f1); do
                PIDVRF3="$(ps aux | grep pid-"$port" | grep -v grep | awk '{print $2}')"
                Portd="$(cat $mainPath/PortM/PDirect.log | grep -v "nobody" | cut -d' ' -f1)"
                if [[ -z ${Portd} ]]; then
                    # systemctl start python.PD &>/dev/null
                    screen -dmS pydic-"$port" python $mainPath/filespy/PDirect-8081.py
                else
                    # systemctl start python.PD &>/dev/null
                    screen -dmS pydic-"$port" python $mainPath/filespy/PDirect-8081.py
                fi
            done
        else
            msg -bar
            msgCentrado -rojo "SSL/TLS NO INSTALADO"
            msg -bar
        fi
    }

    gerar_cert() {
        clear
        case $1 in
        1)
            msg -bar
            msg -amarillo "Generador De Certificado Let's Encrypt"
            msg -bar
            ;;
        2)
            msg -bar
            msg -amarillo "Generador De Certificado Zerossl"
            msg -bar
            ;;
        esac
        msg -amarillo "Requiere ingresar un dominio."
        msg -amarillo "el mismo solo deve resolver DNS, y apuntar"
        msg -amarillo "a la direccion ip de este servidor."
        msg -bar
        msg -amarillo "Temporalmente requiere tener"
        msg -amarillo "los puertos 80 y 443 libres."
        if [[ $1 = 2 ]]; then
            msg -bar
            msg -amarillo "Requiere tener una cuenta Zerossl."
        fi
        msg -bar
        msgne -blanco " Continuar [S/N]: "
        read opcion
        [[ $opcion != @(s|S|y|Y) ]] && return 1

        if [[ $1 = 2 ]]; then
            while [[ -z $mail ]]; do
                clear
                msg -bar
                msg -amarillo "ingresa tu correo usado en Zerossl"
                msg -bar3
                msgne -blanco " >>> "
                read mail
            done
        fi

        if [[ -e ${tmp_crt}/dominio.txt ]]; then
            domain=$(cat ${tmp_crt}/dominio.txt)
            [[ $domain = "multi-domain" ]] && unset domain
            if [[ ! -z $domain ]]; then
                clear
                msg -bar
                msg -verde "Dominio asociado a esta ip"
                msg -bar
                echo -e "$(msg -rojo " >>> ") $(msg -amarillo "$domain")"
                msgne -blanco "Continuar, usando este dominio? [S/N]: "
                read opcion
                tput cuu1 && tput dl1
                [[ $opcion != @(S|s|Y|y) ]] && unset domain
            fi
        fi

        while [[ -z $domain ]]; do
            clear
            msg -bar
            msg -amarillo "ingresa tu dominio"
            msg -bar
            msgne -blanco " >>> "
            read domain
        done
        msg -bar
        msg -amarillo " Comprovando direccion IP ..."
        local_ip=$(wget -qO- ipv4.icanhazip.com)
        domain_ip=$(ping "${domain}" -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
        sleep 1
        [[ -z "${domain_ip}" ]] && domain_ip="ip no encontrada"
        if [[ $(echo "${local_ip}" | tr '.' '+' | bc) -ne $(echo "${domain_ip}" | tr '.' '+' | bc) ]]; then
            clear
            msg -bar
            msg -rojo "ERROR DE DIRECCION IP"
            msg -bar
            msg -amarillo " La direccion ip de su dominio\n no coincide con la de su servidor."
            msg -bar
            echo -e " $(msg -verde "IP dominio:  ")$(msg -rojo "${domain_ip}")"
            echo -e " $(msg -verde "IP servidor: ")$(msg -rojo "${local_ip}")"
            msg -bar
            msg -amarillo " Verifique su dominio, e intente de nuevo."
            msg -bar

        fi

        stop_port
        acme_install
        echo "$domain" >${tmp_crt}/dominio.txt

    }

    showCabezera "INSTALADOR MONO Y MULTI SSL | SCRIPT LXServer"

    local num=1
    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "INSTALAR | PARAR SSL"
    option[$num]="ssl_stunel"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "AGREGAR PUERTOS SSL EXTRA"
    option[$num]="ssl_stunel_2"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "AGREGAR CERTIFICADO MANUAL (zip)"
    option[$num]="cert_ssl"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "AGREGAR CERTIFICADO ZEROSSL"
    option[$num]="certificadom"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "AGREGAR CERTIFICADO SSL (Let's Encript)"
    option[$num]="gerar_cert"
    let num++

    # INSTALAR DROPBEAR
    opcionMenu -blanco $num "AGREGAR CERTIFICADO SSL (Zerossl Directo)"
    option[$num]="gerar_cert2"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "ssl_stunel")
        ssl_stunel
        ;;
    "ssl_stunel_2")
        ssl_stunel_2
        ;;
    "cert_ssl")
        cert_ssl
        ;;
    "certificadom")
        certificadom
        ;;
    "gerar_cert")
        gerar_cert 1
        ;;
    "gerar_cert2")
        gerar_cert 2
        ;;

    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;
    esac

    proto_ssl
}
