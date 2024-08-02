recuperar_base() {
    showCabezera "RECUPERAR BASE DE USER"

    rm -rf $mainPath/backuplog/principal >/dev/null 2>&1
    i="1"
    [[ -z $(ls $mainPath/backuplog) ]] && echo -e "" || {
        for my_arqs in $(ls $mainPath/backuplog); do
            [[ -d "$my_arqs" ]] && continue
            select_arc[$i]="$my_arqs"
            echo -e "\e[1;93m [\e[1;92m$i\e[1;93m] \e[1;91m> \e[1;97m$my_arqs"
            let i++
        done
        i=$(($i - 1))
        msg -bar
        echo -e "\e[1;93m Seleccione el archivo"
        msg -bar
        # while [[ -z ${select_arc[$slct]} ]]; do
        read -p " [1-$i]: " slct
        tput cuu1 && tput dl1
        #done
        backselect="${select_arc[$slct]}"
        cd $mainPath/backuplog
        file="$backselect"
        tar -xzvf ./$file
        cat $mainPath/backuplog/principal/cuentassh >$mainPath/cuentassh
        cat $mainPath/backuplog/principal/cuentahwid >$mainPath/cuentahwid
        cat $mainPath/backuplog/principal/cuentatoken >$mainPath/cuentatoken
        cd
        msg -bar
        echo -e "\e[1;32m  >> Completado con Exito!"
    }
    msgSuccess

}
