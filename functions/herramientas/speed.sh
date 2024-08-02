#SPEED TEST
speed_test() {
    showCabezera "LXManager"
    mkdir -p /opt/speed/ >/dev/null 2>&1
    wget -O /opt/speed/speedtest https://raw.githubusercontent.com/NetVPS/LATAM_Oficial/main/Ejecutables/speedtest.py &>/dev/null
    chmod +rwx /opt/speed/speedtest
    declare -A cor=([0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m")

    echo -e "\e[1;93m    PRUEBA DE VELOCIDAD DE HOSTING  [By LXServer]"
    msg -bar
    ping=$(ping -c1 google.com | awk '{print $8 $9}' | grep -v loss | cut -d = -f2 | sed ':a;N;s/\n//g;ta')
    starts_test=$(/opt/speed/speedtest)
    fun_bar "$starts_test"
    down_load=$(echo "$starts_test" | grep "Download" | awk '{print $2,$3}')
    up_load=$(echo "$starts_test" | grep "Upload" | awk '{print $2,$3}')
    msg -bar
    msg -amarillo " Latencia:\033[1;92m $ping"
    msg -amarillo " Subida:\033[1;92m $up_load"
    msg -amarillo " Descarga:\033[1;92m $down_load"
    msg -bar
    read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
}
