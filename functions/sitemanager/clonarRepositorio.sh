#!/bin/bash

clonarRepositorio() {

    getsshkey() {
        # Ruta de la clave SSH (por defecto)
        SSH_KEY="$HOME/.ssh/id_rsa"

        # Verificar si la clave SSH ya existe, si no, crearla
        if [ ! -f "$SSH_KEY" ]; then

            # validar email
            while true; do
                msgne -blanco "Ingrese el correo con el que dara de alta la ssh key: "
                read email

                if [[ -z $email ]]; then
                    errorFun "nullo" && continue
                elif ! validarCorreo "$email"; then
                    errorFun "correoInvalido" "${email}" && continue
                fi
                break
            done

            ssh-keygen -t rsa -b 4096 -f "$SSH_KEY" -N "" -C "${email}"
        fi

        # Mostrar la clave pública
        cat "${SSH_KEY}.pub"
    }

    showCabezera "Clonador de repositorio"

    msgCentrado -blanco "SSH KEY"

    getsshkey

    msg -bar

    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
}
