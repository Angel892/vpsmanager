#!/bin/bash

menuNginx() {
    install() {
        showCabezera "Instalacion NGINX"

        msgInstall -blanco "Instalando nginx"
        # barra_intall "apt-get install nginx -y"
        apt-get install nginx -y

        msgSuccess
    }

    uninstall() {

        showCabezera "DESINSTALACION nginx"

        sudo systemctl stop nginx

        msgInstall -blanco "Removiendo dependencias"
        #barra_intallb "sudo apt-get remove -y --purge nginx nginx-common nginx-core"
        sudo apt-get remove -y --purge nginx nginx-common nginx-core

        msgInstall -blanco "Eliminando carpetas"
        sudo rm -rf /etc/nginx 2>&1

        msgInstall -blanco "Limpiando dependencias sin usar"
        #barra_intallb "sudo apt-get autoremove -y && sudo apt-get autoclean -y"
        sudo apt-get autoremove -y && sudo apt-get autoclean -y

        msgSuccess
    }

    ssl() {
        local nginxSitePath="/etc/nginx/sites-available"

        conSitio() {
            local sitename=$1
            local dominio=$2
            local puerto=$3

            # agregamos el contenido a la configuracion nginx
            cat <<EOF >$nginxSitePath/$sitename
server {
    listen 80;
    server_name $dominio;

    location / {
        proxy_pass http://localhost:$puerto;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
        }

        sinSitio() {
            local sitename=$1
            local dominio=$2
            # Verificamos si el directorio no existe y lo creamos
            if [ ! -d "/var/www/$sitename" ]; then
              sudo mkdir -p /var/www/$sitename
            fi

            # creamos el archivo index
            validarArchivo "/var/www/$sitename/index.html"

            # agregamos el contenido a la página
            cat <<EOF >/var/www/$sitename/index.html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$sitename</title>
</head>
<body>
    <h1>LXServer</h1>
</body>
</html>
EOF


        # agregamos el contenido a la configuracion nginx
            cat <<EOF >$nginxSitePath/$sitename
server {
    listen 80;
    server_name $dominio;

    # Directorio raíz de los archivos estáticos
    root /var/www/$sitename;

    # Archivo de índice por defecto
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
        }

        showCabezera "INSTALADOR SSL"

        while true; do
            msgne -blanco "Nombre del sitio:" && msgne -verde
            read -p " " sitename
            if [[ -z $sitename ]]; then
                errorFun "nullo"
                continue
            fi

            if [[ -f "$nginxSitePath/$sitename" ]]; then
                msgCentrado -rojo "Ya hay un sitio con ese mismo nombre escoja otro"
                sleep 2
                continue
            fi

            break
        done


        while true; do
            msgne -blanco "Dominio:" && msgne -verde
            read -p " " dominio
            if [[ -z $dominio ]]; then
                errorFun "nullo"
                continue
            fi

            break
        done

        msgne -blanco "Deseas agregar un sitio:" && msgne -verde
        read -p " " -e -i "n" sitio

        validarArchivo "$nginxSitePath/$sitename"

        if [[ "$sitio" = "s" || "$sitio" = "S" ]]; then
            while true; do
                msgne -blanco "Ingrese el puerto donde se estara ejecutando:" && msgne -verde
                read -p " " -e -i "5000" puerto
                if [[ -z $puerto ]]; then
                    errorFun "nullo"
                    continue
                fi

                if [[ "$puerto" != +([0-9]) ]]; then
                    errorFun "soloNumeros"
                    continue
                fi

                break
            done

            conSitio "${sitename}" "${dominio}" "${puerto}"
        else
            sinSitio "${sitename}" "${dominio}"
        fi

        sudo ln -s /etc/nginx/sites-available/$sitename /etc/nginx/sites-enabled/

        sudo apt update
        sudo apt install certbot python3-certbot-nginx -y
        sudo certbot --nginx -d vps.loxoweb.com
        sudo certbot renew --dry-run
        
        sudo nginx -t
        sudo systemctl restart nginx
        
    }

    showCabezera "MENU NGINX"

    local num=1

    local status=$(ps -ef | grep "nginx" | grep -v "grep" | awk -F "pts" '{print $1}')

    if [[ -z ${status} ]]; then
        # INSTALAR
        opcionMenu -blanco $num "Instalar nginx"
        option[$num]="install"
        let num++
    else
        # INSTALAR CERTIFICADO SSL
        opcionMenu -blanco $num "Instalar certificado ssl"
        option[$num]="ssl"
        let num++

        # DESINSTALAR
        opcionMenu -blanco $num "Desinstalar nginx"
        option[$num]="uninstall"
        let num++
    fi

    msg -bar

    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "ssl") ssl ;;
    "install") install ;;
    "uninstall") uninstall ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    menuNginx
}
