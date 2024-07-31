#--- INSTALAR SSL
proto_ssl() {
    clear
    clear
    declare -A cor=([0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m")

    ssl_stunel() {
        clear
        clear
        [[ $(mportas | grep stunnel4 | head -1) ]] && {
            msg -bar
            echo -e "\033[1;31m                 DESINSTALANDO SSL"
            msg -bar
            service stunnel4 stop >/dev/null 2>&1
            fun_bar "apt-get purge  stunnel4 -y"
            msg -bar
            echo -e "\033[1;32m        >> SSL DESINSTALADO  CON EXITO <<"
            msg -bar
            return 0
        }
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;93m             INSTALADOR SSL SCRIPT LXServer"
        msg -bar
        echo -e "\033[1;97m Seleccione un puerto de anclaje."
        echo -e "\033[1;97m Puede ser un SSH/DROPBEAR/SQUID/OPENVPN/WEBSOCKET"
        msg -bar
        while true; do
            echo -ne "\033[1;97m Puerto-Local:\033[1;32m" && read -p " " -e -i "22" portx
            if [[ ! -z $portx ]]; then
                if [[ $(echo $portx | grep "[0-9]") ]]; then
                    [[ $(mportas | grep $portx | awk '{print $2}' | head -1) ]] && break || echo -e "\033[1;31m Puerto Invalido - Reintente con otro Activo"
                fi
            fi
        done
        msg -bar
        DPORT="$(mportas | grep $portx | awk '{print $2}' | head -1)"
        echo -e "\033[1;33m             Ahora Que Puerto sera SSL"
        msg -bar
        while true; do
            echo -ne "\033[1;97m Puerto para SSL:\033[1;32m" && read -p " " -e -i "443" SSLPORT
            [[ $(mportas | grep -w "$SSLPORT") ]] || break
            echo -e "\033[1;33m Este Puerto esta en Uso"
            unset SSLPORT
        done
        msg -bar
        echo -e "\033[1;32m                 Instalando SSL"
        msg -bar
        fun_bar "apt-get install stunnel4 -y"
        apt-get install stunnel4 -y >/dev/null 2>&1
        msg -bar
        echo -e "\033[1;97m A continuacion se le pediran datos de su crt si\n desconoce que datos lleva presione puro ENTER"
        msg -bar
        sleep 5s
        echo -e "client = no\n[SSL]\ncert = /etc/stunnel/stunnel.pem\naccept = ${SSLPORT}\nconnect = 127.0.0.1:${portx}" >/etc/stunnel/stunnel.conf
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
        msg -bar
        echo -e "\033[1;32m          >> SSL INSTALADO CON EXITO <<"
        msg -bar
        rm -rf $mainPath/stunnel.crt >/dev/null 2>&1
        rm -rf $mainPath/stunnel.key >/dev/null 2>&1
        rm -rf /root/stunnel.crt >/dev/null 2>&1
        rm -rf /root/stunnel.key >/dev/null 2>&1
        return 0
    }
    ssl_stunel_2() {
        clear
        clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;93m              AGREGAR MAS PUESRTOS SSL"
        msg -bar
        echo -e "\033[1;97m Seleccione un puerto de anclaje."
        echo -e "\033[1;97m Puede ser un SSH/DROPBEAR/SQUID/OPENVPN/SSL/PY"
        msg -bar
        while true; do
            echo -ne "\033[1;97m Puerto-Local: \033[1;32m" && read portx
            if [[ ! -z $portx ]]; then
                if [[ $(echo $portx | grep "[0-9]") ]]; then
                    [[ $(mportas | grep $portx | head -1) ]] && break || echo -e "\033[1;31m Puerto Invalido - Reintente con otro Activo"
                fi
            fi
        done
        msg -bar
        DPORT="$(mportas | grep $portx | awk '{print $2}' | head -1)"
        echo -e "\033[1;33m             Ahora Que Puerto sera SSL"
        msg -bar
        while true; do
            echo -ne "\033[97m Puerto-SSL: \033[1;32m" && read SSLPORT
            [[ $(mportas | grep -w "$SSLPORT") ]] || break
            echo -e "\033[1;33m Este Puerto esta en Uso"
            unset SSLPORT
        done
        msg -bar
        echo -e "client = no\n[SSL+]\ncert = /etc/stunnel/stunnel.pem\naccept = ${SSLPORT}\nconnect = 127.0.0.1:${portx}" >>/etc/stunnel/stunnel.conf
        ##-->> AutoInicio
        sed -i '/ENABLED=[01]/d' /etc/default/stunnel4
        echo "ENABLED=1" >>/etc/default/stunnel4
        service stunnel4 restart >/dev/null 2>&1
        echo -e "\033[1;32m            PUERTO AGREGADO CON EXITO"
        msg -bar
        rm -rf $mainPath/stunnel.crt >/dev/null 2>&1
        rm -rf $mainPath/stunnel.key >/dev/null 2>&1
        rm -rf /root/stunnel.crt >/dev/null 2>&1
        rm -rf /root/stunnel.key >/dev/null 2>&1
        return 0
    }
    cert_ssl() {
        clear && clear
        msg -bar
        msg -tit
        msg -bar
        echo -e "\033[1;93m             AGREGAR CERTIFICADO MANUAL"
        msg -bar
        echo -e "\033[1;97m Tenga ya su SSL activo y configurado Previamente"
        echo -e "\033[1;93m >> Suba su certificado en zip a Dropbox"
        msg -bar
        echo -ne "\033[1;97m Pegue el link Abajo:\e[1;96m\n  " && read linkd
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
        msg -bar
        echo -e "\e[1;32m         >> CERTIFICADO INSTALADO CON EXITO <<"
        msg -bar

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
            clear && clear
            msg -bar
            msg -tit
            msg -bar
            echo -e "\033[1;93m             AGREGAR CERTIFICADO ZEROSSL"
            msg -bar
            echo -e "\e[1;37m Verificar dominio.......... \e[0m\n"
            echo -e "\e[1;37m TIENES QUE MODIFICAR EL ARCHIVO DESCARGADO\n EJEMPLO: 530DDCDC3 comodoca.com 7bac5e210\e[0m"
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
            echo -e "\e[1;37m VERIFIQUE EN LA PÁGINA ZEROSSL \e[0m"
            msg -bar
            read -p " ENTER PARA CONTINUAR"
            clear
            msg -bar
            echo -e "\e[1;33m👇 LINK DEL CERTIFICADO 👇       \n     \e[0m"
            echo -e "\e[1;36m LINK\e[37m: \e[34m"
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
            echo -e "${cor[4]} CERTIFICADO INSTALADO \e[0m"
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
            echo -e "${cor[3]} SSL/TLS NO INSTALADO \e[0m"
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

    clear && clear
    msg -bar

    msg -tit
    msg -bar
    echo -e "\e[1;93m    INSTALADOR MONO Y MULTI SSL | SCRIPT LXServer"
    msg -bar

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
        msg -bar
        ssl_stunel
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        ;;
    "ssl_stunel_2")
        msg -bar
        ssl_stunel_2
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        ;;
    "cert_ssl")
        msg -bar
        cert_ssl
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        ;;
    "certificadom")
        msg -bar
        certificadom
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        ;;
    "gerar_cert")
        msg -bar
        gerar_cert 1
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        ;;
    "gerar_cert2")
        msg -bar
        gerar_cert 2
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        ;;

    "volver") menuProtocols ;;
    *) echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}" ;;
    esac

    proto_ssl
}
