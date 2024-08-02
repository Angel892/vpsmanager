#!/bin/bash

#--- EJECUTOR AUTOLIMPIEZA
autolim_fun() {
    clear && clear
    apt-get update
    apt-get upgrade -y
    dpkg --configure -a
    apt -f install -y
    apt-get autoremove -y
    apt-get clean -y
    apt-get autoclean -y
    sync
    echo 1 >/proc/sys/vm/drop_caches
    sync
    echo 2 >/proc/sys/vm/drop_caches
    sync
    echo 3 >/proc/sys/vm/drop_caches
    swapoff -a && swapon -a
    v2ray clean
}

autolim_fun
