#!/bin/bash

dotnetservice() {
    local servicePath="/etc/systemd/system"

    showCabezera "DOTNET SERVICE"

    # validar nombre
    while true; do
        msgne -blanco "Ingrese el nombre del servicio: " && msgne -verde ""
        read name

        if [[ -z $name ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    # validar publish route
    while true; do
        msgne -blanco "Ruta de publicacion (/path/to/publish): " && msgne -verde ""
        read publishroute

        if [[ -z $publishroute ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    # validar ddl
    while true; do
        msgne -blanco "Nombre DDL: " && msgne -verde ""
        read ddlName

        if [[ -z $ddlName ]]; then
            errorFun "nullo" && continue
        fi
        break
    done

    validarArchivo "$servicePath/$name.service"

    # agregamos el contenido a la configuracion nginx
    cat <<EOF >$servicePath/$name.service
[Unit]
Description=$name
After=network.target

[Service]
WorkingDirectory=$publishroute
ExecStart=/usr/bin/dotnet $publishroute/$ddlName.dll
Restart=always
RestartSec=10
SyslogIdentifier=$name
User=www-data
Group=www-data

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start $name
sudo systemctl enable $name

msgSuccess
}
