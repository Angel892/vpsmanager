#!/bin/bash

allowStreaming() {
    msgInstall "Instalando dependencias"
    fun_bar "sudo apt -y install net-tools openresolv"

    # NOS POSISIONAMOS EN /root
    cd /root

    # CREAMOS LAS CARPETAS CORRESPONDINTES
    mkdir warp && cd warp

    
}