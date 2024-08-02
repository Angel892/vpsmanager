#!/bin/bash

allowStreaming() {

    showCabezera "Preparando para streaming"

    msgInstall "Instalando dependencias"
    fun_bar "sudo apt -y install net-tools openresolv"

    # NOS POSISIONAMOS EN /root
    cd /root

    # create and enter the folder
    mkdir warp && cd warp
    # install wgcf「please change the download address based on the GitHub latest release」
    wget -O wgcf https://github.com/Angel892/vpsmanager/raw/master/helpers/wgcf_2.2.3_linux_amd64
    # change permission
    chmod +x wgcf

    clear
    msg -bar
    msgCentrado -blanco "SE HARA EL REGISTRO DE LA CUENTA ESCOJE 'Y' DESPUES ENTER"
    msg -bar
    # register warp account「Choose Y and press ENTER」
    ./wgcf register

    # Generate WireGuard config file
    ./wgcf generate

    # Ruta del archivo
    file="/root/warp/wgcf-profile.conf"

    # Líneas a añadir
    ip=$(vpsIP)
    msgCentrado -verde "Tu ip ${ip}"
    postup="PostUp = ip rule add from ${ip} lookup main"
    postdown="PostDown = ip rule delete from ${ip} lookup main"

    # Añadir las líneas después de la línea que contiene "MTU"
    sed -i "/MTU =/a $postup\n$postdown" "$file"

    # rename and copy the config file
    validarArchivo "/etc/wireguard/wgcf.conf"
    sudo cp /root/warp/wgcf-profile.conf /etc/wireguard/wgcf.conf

    sudo wg-quick up wgcf

    msg -bar
    ip a
    msg -bar

    sudo wg-quick down wgcf

    # Start deamon
    sudo systemctl start wg-quick@wgcf
    # Enable autostart
    sudo systemctl enable wg-quick@wgcf
    # Check status
    sudo systemctl status wg-quick@wgcf
    # Stop
    sudo systemctl stop wg-quick@wgcf
    # Restart
    sudo systemctl restart wg-quick@wgcf

    msg -bar

    # IPv4
    wget -qO- ip.gs
    # IPv6 Only VPS
    wget -qO- -6 ip.gs

    msg -bar

    msgCentrado -verde "Todo listo"
    msgSuccess

}

stopStreaming() {
    # Stop
    sudo systemctl stop wg-quick@wgcf

    msgSuccess
}
