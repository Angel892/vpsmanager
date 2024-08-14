#!/bin/bash

sslmanager() {
    showCabezera "SSL MANAGER"

    # Verificar si certbot ya está instalado
    if ! command -v certbot &>/dev/null; then
        msgInstall -blanco "Instalando certbot..."
        sudo apt install -y certbot python3-certbot-nginx
    fi

    # validar dominio
    while true; do
        msgne -blanco "Ingrese el dominio del sitio: " && msgne -verde ""
        read site

        if [[ -z $site ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    msgInstall -blanco "Instalar certificado SSL para $site"
    sudo certbot --nginx -d $site

    msgInstall -blanco "Renovar automaticamente certificado SSL para $site"
    sudo certbot renew --dry-run

    msg -verde "Certificado SSL instalado correctamente"
    sudo systemctl restart nginx

    msgSuccess
}