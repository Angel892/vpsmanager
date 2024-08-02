unistallv2() {
    source <(curl -sL https://github.com/Angel892/vpsmanager/raw/master/install/v2ray/v2ray.sh) --remove >/dev/null 2>&1
    rm -rf $mainPath/RegV2ray >/dev/null 2>&1
    rm -rf $mainPath/v2ray/* >/dev/null 2>&1
    msgCentrado --verde "V2RAY DESINSTALADO CON EXITO"
    msgSuccess
}
