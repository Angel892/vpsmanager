#!/bin/bash

nginxvue() {
    local nginxSitePath="/etc/nginx/sites-available"

    showCabezera "VUE"

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
        msgne -blanco "Ruta de dist (/var/www/vue-app/dist): " && msgne -verde ""
        read distPath

        if [[ -z $distPath ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    validarArchivo "$nginxSitePath/$sitename"

    # agregamos el contenido a la configuracion nginx
    cat <<EOF >$nginxSitePath/$sitename
server {
    listen 80;
    server_name $site;

    root $distPath;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

    sudo ln -s /etc/nginx/sites-available/$sitename /etc/nginx/sites-enabled/

    sudo systemctl reload nginx

    msgSuccess
}
