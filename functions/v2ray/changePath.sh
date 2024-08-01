changepath() {
    showCabezera "CAMBIAR NOMBRE DEL PATH"
    msgCentrado -blanco "USUARIOS REGISTRADOS"
    echo -ne "\e[91m >> Digita un nombre corto para el path:\n \033[1;92m " && read nombrepat
    NPath=$(sed -n '/'path'/=' /etc/v2ray/config.json)
    sed -i "${NPath}d" /etc/v2ray/config.json
    sed -i ''${NPath}'i\          \"path": "/'${nombrepat}'/",' /etc/v2ray/config.json
    
    msgSuccess
}
