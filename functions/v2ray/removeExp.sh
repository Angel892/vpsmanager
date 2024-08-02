limpiador_activador() {
    unset PIDGEN
    PIDGEN=$(ps aux | grep -v grep | grep "limv2ray")
    if [[ ! $PIDGEN ]]; then
        screen -dmS limv2ray watch -n 21600 $mainPath/auto/limitadorv2ray.sh
    else
        #killall screen
        screen -S limv2ray -p 0 -X quit
    fi
    unset PID_GEN
    PID_GEN=$(ps x | grep -v grep | grep "limv2ray")
    [[ ! $PID_GEN ]] && PID_GEN="\e[91m [ DESACTIVADO ] " || PID_GEN="\e[92m [ ACTIVADO ] "
    statgen="$(echo $PID_GEN)"
    
    showCabezera "ELIMINAR EXPIRADOS | UUID V2RAY"
    msgCentrado -verde "SE LIMPIARAN EXPIRADOS CADA 6 hrs"
    msg -bar
    msgCentrado -blanco "$statgen"
    msg -bar
    msgSuccess

}
