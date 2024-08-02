#!/bin/bash

actualizar_script() {
    showCabezera "Actualizando el Script"

    cd /etc/vpsmanager

    # Restablecer cualquier cambio local y obtener las actualizaciones más recientes
    msgInstall -blanco "Extrayendo repositorio"
    barra_intallb "sudo git fetch --all"
    if [ $? -ne 0 ]; then
        msgCentrado -rojo "Error: Falló la obtención de las actualizaciones del repositorio."
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return
    fi

    msgInstall -blanco "Descartando cambios pendientes"
    barra_intallb "git reset --hard origin/master"
    if [ $? -ne 0 ]; then
        msgCentrado -rojo "Error: Falló el restablecimiento del repositorio."
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return
    fi

    # Asignar permisos de ejecución al script principal y a los scripts de funciones
    msgInstall -blanco "Habilitando permisos"
    sudo find /etc/vpsmanager/ -type f -name "*.sh" -exec chmod +x {} \;
    if [ $? -ne 0 ]; then
        msgCentrado -rojo "Error: No se pudieron asignar los permisos de ejecución."
        msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
        return
    fi

    msg -bar

    msgCentrado -verde "El script se ha actualizado correctamente."

    msg -bar
    msgCentradoRead -blanco "<< Presiona enter para Continuar >>"
    exec /etc/vpsmanager/adm.sh
}
