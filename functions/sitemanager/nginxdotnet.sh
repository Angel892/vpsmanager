#!/bin/bash

nginxdotnet() {

    local nginxSitePath="/etc/nginx/sites-available"

    showCabezera "DOTNET"

    # validar site
    while true; do
        msgne -blanco "Ingrese el nombre del sitio: " && msgne -verde ""
        read sitename

        if [[ -z $sitename ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    # validar dominio
    while true; do
        msgne -blanco "Ingrese el dominio del sitio: " && msgne -verde ""
        read site

        if [[ -z $site ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    # validar puerto
    while true; do
        msgne -blanco "Ingrese el puerto en el que se estará ejecutando: " && msgne -verde ""
        read -p " " -e -i "5000" port

        if [[ -z $port ]]; then
            errorFun "nullo" && continue
        elif ! mportas | grep -q -w "$port"; then
            errorFun "puertoInvalido" "$port" && continue
        fi
        break
    done

    validarArchivo "$nginxSitePath/$sitename"

    # agregamos el contenido a la configuracion nginx
    cat <<EOF >$nginxSitePath/$sitename
server {
    listen 80;
    server_name $site;

    location / {
        proxy_pass http://localhost:$port;
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

    sudo ln -s /etc/nginx/sites-available/$sitename /etc/nginx/sites-enabled/

    msgSuccess

}
