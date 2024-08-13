#!/bin/bash

clonarRepositorio() {

    local SSH_KEY="$HOME/.ssh/id_rsa"

    gensshkey() {
        showCabezera "Generador de clave ssh"

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
    }

    showsshkey() {
        # Mostrar la clave pública
        cat "${SSH_KEY}.pub"
    }

    cloneRepositorio() {
        showCabezera "Repositorio manager"
        msgCentrado -blanco "SSH KEY"
        echo -e ""
        msgne -verde "" && showsshkey
        echo -e ""
        msg -bar

        # validar repo
        while true; do
            msgne -blanco "Ingrese el link del repositorio: "
            read repo

            if [[ -z $repo ]]; then
                errorFun "nullo" && continue
            fi
            break
        done

    }

    showCabezera "Clonador de repositorio"
    local num=1

    # Verificar si la clave SSH ya existe, si no, crearla
    if [ ! -f "$SSH_KEY" ]; then
        # Generar key
        opcionMenu -blanco $num "Generar ssh key"
        option[$num]="gensshkey"
        let num++
    else
        # Clonar repositorio
        opcionMenu -blanco $num "Clonar repositorio"
        option[$num]="cloneRepositorio"
        let num++
    fi

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"

    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in
    "gensshkey") gensshkey ;;
    "cloneRepositorio") cloneRepositorio ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        sleep 2
        ;;
    esac

    clonarRepositorio
}
