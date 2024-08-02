#--- INSTALADOR BBR
bbr_fun() {
    PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
    export PATH
    sh_ver="1.3.1"
    github="raw.githubusercontent.com/cx9208/Linux-NetSpeed/master"
    Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
    Info="${Green_font_prefix}[Informacion]${Font_color_suffix}"
    Error="${Red_font_prefix}[Error]${Font_color_suffix}"
    Tip="${Green_font_prefix}[Atencion]${Font_color_suffix}"
    #Instalar el núcleo BBR
    installbbr() {
        kernel_version="4.11.8"
        if [[ "${release}" == "centos" ]]; then
            rpm --import http://${github}/bbr/${release}/RPM-GPG-KEY-elrepo.org
            yum install -y http://${github}/bbr/${release}/${version}/${bit}/kernel-ml-${kernel_version}.rpm
            yum remove -y kernel-headers
            yum install -y http://${github}/bbr/${release}/${version}/${bit}/kernel-ml-headers-${kernel_version}.rpm
            yum install -y http://${github}/bbr/${release}/${version}/${bit}/kernel-ml-devel-${kernel_version}.rpm
        elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
            mkdir bbr && cd bbr
            wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb
            wget -N --no-check-certificate http://${github}/bbr/debian-ubuntu/linux-headers-${kernel_version}-all.deb
            wget -N --no-check-certificate http://${github}/bbr/debian-ubuntu/${bit}/linux-headers-${kernel_version}.deb
            wget -N --no-check-certificate http://${github}/bbr/debian-ubuntu/${bit}/linux-image-${kernel_version}.deb

            dpkg -i libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb
            dpkg -i linux-headers-${kernel_version}-all.deb
            dpkg -i linux-headers-${kernel_version}.deb
            dpkg -i linux-image-${kernel_version}.deb
            cd .. && rm -rf bbr
        fi
        detele_kernel
        BBR_grub
        msg -bar
        echo -e "${Tip} Deves Reiniciar VPS y Activar Acelerador\n${Red_font_prefix} BBR/BBR Versión mágica${Font_color_suffix}"
        msg -bar
        stty erase '^H' && read -p "Reiniciar VPS para habilitar BBR ? [Y/n] :" yn
        [ -z "${yn}" ] && yn="y"
        if [[ $yn == [Yy] ]]; then
            echo -e "${Info} VPS se reinicia ..."
            reboot
        fi
    }

    #Instale el núcleo BBRplus
    installbbrplus() {
        kernel_version="4.14.129-bbrplus"
        if [[ "${release}" == "centos" ]]; then
            wget -N --no-check-certificate https://${github}/bbrplus/${release}/${version}/kernel-${kernel_version}.rpm
            yum install -y kernel-${kernel_version}.rpm
            rm -f kernel-${kernel_version}.rpm
            kernel_version="4.14.129_bbrplus" #fix a bug
        elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
            mkdir bbrplus && cd bbrplus
            wget -N --no-check-certificate http://${github}/bbrplus/debian-ubuntu/${bit}/linux-headers-${kernel_version}.deb
            wget -N --no-check-certificate http://${github}/bbrplus/debian-ubuntu/${bit}/linux-image-${kernel_version}.deb
            dpkg -i linux-headers-${kernel_version}.deb
            dpkg -i linux-image-${kernel_version}.deb
            cd .. && rm -rf bbrplus
        fi
        detele_kernel
        BBR_grub
        msg -bar
        echo -e "${Tip} Deves Reiniciar VPS y Activar Acelerador \n${Red_font_prefix} BBRplus${Font_color_suffix}"
        msg -bar
        stty erase '^H' && read -p "Reiniciar VPS para habilitar BBRplus? [Y/n]:" yn
        [ -z "${yn}" ] && yn="y"
        if [[ $yn == [Yy] ]]; then
            echo -e "${Info} VPS se reinicia ..."
            reboot
        fi
    }

    #Instale el kernel de Lotserver
    installlot() {
        if [[ "${release}" == "centos" ]]; then
            rpm --import http://${github}/lotserver/${release}/RPM-GPG-KEY-elrepo.org
            yum remove -y kernel-firmware
            yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-firmware-${kernel_version}.rpm
            yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-${kernel_version}.rpm
            yum remove -y kernel-headers
            yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-headers-${kernel_version}.rpm
            yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-devel-${kernel_version}.rpm
        elif [[ "${release}" == "ubuntu" ]]; then
            bash <(wget --no-check-certificate -qO- "http://${github}/Debian_Kernel.sh")
        elif [[ "${release}" == "debian" ]]; then
            bash <(wget --no-check-certificate -qO- "http://${github}/Debian_Kernel.sh")
        fi
        detele_kernel
        BBR_grub
        msg -bar
        echo -e "${Tip} Deves Reiniciar VPS y Activar Acelerador\n${Red_font_prefix}Lotserver${Font_color_suffix}"
        msg -bar
        stty erase '^H' && read -p "Necesita reiniciar el VPS antes de poder abrir Lotserver, reiniciar ahora ? [Y/n] :" yn
        [ -z "${yn}" ] && yn="y"
        if [[ $yn == [Yy] ]]; then
            echo -e "${Info} VPS se reinicia ..."
            reboot
        fi
    }

    # Habilitar BBR
    startbbr() {
        remove_all
        echo "Aceleracion Reconfigurada de Nuevo"
        echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
        sysctl -p
        echo -e "${Info}¡BBR comenzó con éxito!"
        msg -bar
    }

    #Habilitar BBRplus
    startbbrplus() {
        remove_all
        echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbrplus" >>/etc/sysctl.conf
        sysctl -p
        echo -e "${Info}BBRplus comenzó con éxito!！"
        msg -bar
    }

    # Compilar y habilitar el cambio mágico BBR
    startbbrmod() {
        remove_all
        if [[ "${release}" == "centos" ]]; then
            yum install -y make gcc
            mkdir bbrmod && cd bbrmod
            wget -N --no-check-certificate http://${github}/bbr/tcp_tsunami.c
            echo "obj-m:=tcp_tsunami.o" >Makefile
            make -C /lib/modules/$(uname -r)/build M=$(pwd) modules CC=/usr/bin/gcc
            chmod +x ./tcp_tsunami.ko
            cp -rf ./tcp_tsunami.ko /lib/modules/$(uname -r)/kernel/net/ipv4
            insmod tcp_tsunami.ko
            depmod -a
        else
            apt-get update
            if [[ "${release}" == "ubuntu" && "${version}" = "14" ]]; then
                apt-get -y install build-essential
                apt-get -y install software-properties-common
                add-apt-repository ppa:ubuntu-toolchain-r/test -y
                apt-get update
            fi
            apt-get -y install make gcc
            mkdir bbrmod && cd bbrmod
            wget -N --no-check-certificate http://${github}/bbr/tcp_tsunami.c
            echo "obj-m:=tcp_tsunami.o" >Makefile
            ln -s /usr/bin/gcc /usr/bin/gcc-4.9
            make -C /lib/modules/$(uname -r)/build M=$(pwd) modules CC=/usr/bin/gcc-4.9
            install tcp_tsunami.ko /lib/modules/$(uname -r)/kernel
            cp -rf ./tcp_tsunami.ko /lib/modules/$(uname -r)/kernel/net/ipv4
            depmod -a
        fi

        echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=tsunami" >>/etc/sysctl.conf
        sysctl -p
        cd .. && rm -rf bbrmod
        echo -e "${Info}¡La versión mágica de BBR comenzó con éxito!"
        msg -bar
    }

    # Compilar y habilitar el cambio mágico BBR
    startbbrmod_nanqinlang() {
        remove_all
        if [[ "${release}" == "centos" ]]; then
            yum install -y make gcc
            mkdir bbrmod && cd bbrmod
            wget -N --no-check-certificate https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/bbr/centos/tcp_nanqinlang.c
            echo "obj-m := tcp_nanqinlang.o" >Makefile
            make -C /lib/modules/$(uname -r)/build M=$(pwd) modules CC=/usr/bin/gcc
            chmod +x ./tcp_nanqinlang.ko
            cp -rf ./tcp_nanqinlang.ko /lib/modules/$(uname -r)/kernel/net/ipv4
            insmod tcp_nanqinlang.ko
            depmod -a
        else
            apt-get update
            if [[ "${release}" == "ubuntu" && "${version}" = "14" ]]; then
                apt-get -y install build-essential
                apt-get -y install software-properties-common
                add-apt-repository ppa:ubuntu-toolchain-r/test -y
                apt-get update
            fi
            apt-get -y install make gcc-4.9
            mkdir bbrmod && cd bbrmod
            wget -N --no-check-certificate https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/bbr/tcp_nanqinlang.c
            echo "obj-m := tcp_nanqinlang.o" >Makefile
            make -C /lib/modules/$(uname -r)/build M=$(pwd) modules CC=/usr/bin/gcc-4.9
            install tcp_nanqinlang.ko /lib/modules/$(uname -r)/kernel
            cp -rf ./tcp_nanqinlang.ko /lib/modules/$(uname -r)/kernel/net/ipv4
            depmod -a
        fi

        echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=nanqinlang" >>/etc/sysctl.conf
        sysctl -p
        echo -e "${Info}¡La versión mágica de BBR comenzó con éxito!"
        msg -bar
    }

    # Desinstalar toda la aceleración
    remove_all() {
        rm -rf bbrmod
        sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
        sed -i '/fs.file-max/d' /etc/sysctl.conf
        sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
        sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
        sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
        sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
        sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
        sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
        sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
        sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
        sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
        sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
        sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
        sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
        sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
        if [[ -e /appex/bin/lotServer.sh ]]; then
            bash <(wget --no-check-certificate -qO- https://github.com/MoeClub/lotServer/raw/master/Install.sh) uninstall
        fi
        clear
        echo -e "${Info}:La aceleración está Desinstalada."
        msg -bar
        sleep 1s
    }

    #Optimizar la configuración del sistema
    optimizing_system() {
        sed -i '/fs.file-max/d' /etc/sysctl.conf
        sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
        sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
        sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
        sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
        sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
        sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
        sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
        echo "fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1" >>/etc/sysctl.conf
        sysctl -p
        echo "*               soft    nofile           1000000
*               hard    nofile          1000000" >/etc/security/limits.conf
        echo "ulimit -SHn 1000000" >>/etc/profile
        read -p "Después de aplicar la configuracion al VPS necesita reiniciar, reiniciar ahora ? [Y/n] :" yn
        msg -bar
        [ -z "${yn}" ] && yn="y"
        if [[ $yn == [Yy] ]]; then
            echo -e "${Info} Reinicio de VPS..."
            reboot
        fi
    }

    ############# Componentes de gestión del núcleo #############

    # Eliminar kernel redundante
    detele_kernel() {
        if [[ "${release}" == "centos" ]]; then
            rpm_total=$(rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | wc -l)
            if [ "${rpm_total}" ] >"1"; then
                echo -e "Detectado ${rpm_total} El resto del núcleo, comienza a desinstalar ..."
                for ((integer = 1; integer <= ${rpm_total}; integer++)); do
                    rpm_del=$(rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer})
                    echo -e "Comience a desinstalar${rpm_del} Kernel ..."
                    rpm --nodeps -e ${rpm_del}
                    echo -e "Desinstalar ${rpm_del} La desinstalación del núcleo se ha completado, continúa ..."
                done
                echo --nodeps -e "El núcleo se desinstala y continúa ..."
            else
                echo -e " El número de núcleos detectados es incorrecto, ¡por favor verifique!" && exit 1
            fi
        elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
            deb_total=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l)
            if [ "${deb_total}" ] >"1"; then
                echo -e "Detectado ${deb_total} El resto del núcleo, comienza a desinstalar ..."
                for ((integer = 1; integer <= ${deb_total}; integer++)); do
                    deb_del=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer})
                    echo -e "Comience a desinstalar ${deb_del} Kernel ..."
                    apt-get purge -y ${deb_del}
                    echo -e "Desinstalar ${deb_del} La desinstalación del núcleo se ha completado, continúa ..."
                done
                echo -e "El núcleo se desinstala y continúa ..."
            else
                echo -e " El número de núcleos detectados es incorrecto, ¡por favor verifique!" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        fi
    }

    #Actualizar arranque
    BBR_grub() {
        if [[ "${release}" == "centos" ]]; then
            if [[ ${version} = "6" ]]; then
                if [ ! -f "/boot/grub/grub.conf" ]; then
                    echo -e "${Error} /boot/grub/grub.conf No encontrado, verifique."
                    exit 1
                fi
                sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
            elif [[ ${version} = "7" ]]; then
                if [ ! -f "/boot/grub2/grub.cfg" ]; then
                    echo -e "${Error} /boot/grub2/grub.cfg No encontrado, verifique."
                    exit 1
                fi
                grub2-set-default 0
            fi
        elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
            /usr/sbin/update-grub
        fi
    }

    #############Componente de gestión del kernel#############

    #############Componentes de detección del sistema#############

    #Sistema de inspección
    check_sys() {
        if [[ -f /etc/redhat-release ]]; then
            release="centos"
        elif cat /etc/issue | grep -q -E -i "debian"; then
            release="debian"
        elif cat /etc/issue | grep -q -E -i "ubuntu"; then
            release="ubuntu"
        elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
            release="centos"
        elif cat /proc/version | grep -q -E -i "debian"; then
            release="debian"
        elif cat /proc/version | grep -q -E -i "ubuntu"; then
            release="ubuntu"
        elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
            release="centos"
        fi
    }

    #Verifique la versión de Linux
    check_version() {
        if [[ -s /etc/redhat-release ]]; then
            version=$(grep -oE "[0-9.]+" /etc/redhat-release | cut -d . -f 1)
        else
            version=$(grep -oE "[0-9.]+" /etc/issue | cut -d . -f 1)
        fi
        bit=$(uname -m)
        if [[ ${bit} = "x86_64" ]]; then
            bit="x64"
        else
            bit="x32"
        fi
    }

    #Verifique los requisitos del sistema para instalar bbr
    check_sys_bbr() {
        check_version
        if [[ "${release}" == "centos" ]]; then
            if [[ ${version} -ge "6" ]]; then
                installbbr
            else
                echo -e "${Error} BBR El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        elif [[ "${release}" == "debian" ]]; then
            if [[ ${version} -ge "8" ]]; then
                installbbr
            else
                echo -e "${Error} BBR El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        elif [[ "${release}" == "ubuntu" ]]; then
            if [[ ${version} -ge "14" ]]; then
                installbbr
            else
                echo -e "${Error} BBR El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        else
            echo -e "${Error} BBR El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
        fi
    }

    check_sys_bbrplus() {
        check_version
        if [[ "${release}" == "centos" ]]; then
            if [[ ${version} -ge "6" ]]; then
                installbbrplus
            else
                echo -e "${Error} BBRplus El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        elif [[ "${release}" == "debian" ]]; then
            if [[ ${version} -ge "8" ]]; then
                installbbrplus
            else
                echo -e "${Error} BBRplus El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        elif [[ "${release}" == "ubuntu" ]]; then
            if [[ ${version} -ge "14" ]]; then
                installbbrplus
            else
                echo -e "${Error} BBRplus El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
            fi
        else
            echo -e "${Error} BBRplus El núcleo no es compatible con el sistema actual ${release} ${version} ${bit} !" && read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n' && return
        fi
    }

    check_status() {
        kernel_version=$(uname -r | awk -F "-" '{print $1}')
        kernel_version_full=$(uname -r)
        if [[ ${kernel_version_full} = "4.14.129-bbrplus" ]]; then
            kernel_status="BBRplus"
        elif [[ ${kernel_version} = "3.10.0" || ${kernel_version} = "3.16.0" || ${kernel_version} = "3.2.0" || ${kernel_version} = "4.4.0" || ${kernel_version} = "3.13.0" || ${kernel_version} = "2.6.32" || ${kernel_version} = "4.9.0" ]]; then
            kernel_status="Lotserver"
        elif [[ $(echo ${kernel_version} | awk -F'.' '{print $1}') == "4" ]] && [[ $(echo ${kernel_version} | awk -F'.' '{print $2}') -ge 9 ]] || [[ $(echo ${kernel_version} | awk -F'.' '{print $1}') == "5" ]]; then
            kernel_status="BBR"
        else
            kernel_status="noinstall"
        fi

        if [[ ${kernel_status} == "Lotserver" ]]; then
            if [[ -e /appex/bin/lotServer.sh ]]; then
                run_status=$(bash /appex/bin/lotServer.sh status | grep "LotServer" | awk '{print $3}')
                if [[ ${run_status} = "running!" ]]; then
                    run_status="Comenzó exitosamente"
                else
                    run_status="No se pudo iniciar"
                fi
            else
                run_status="No hay acelerador instalado"
            fi
        elif [[ ${kernel_status} == "BBR" ]]; then
            run_status=$(grep "net.ipv4.tcp_congestion_control" /etc/sysctl.conf | awk -F "=" '{print $2}')
            if [[ ${run_status} == "bbr" ]]; then
                run_status=$(lsmod | grep "bbr" | awk '{print $1}')
                if [[ ${run_status} == "tcp_bbr" ]]; then
                    run_status="BBR Comenzó exitosamente"
                else
                    run_status="BBR Comenzó exitosamente"
                fi
            elif [[ ${run_status} == "tsunami" ]]; then
                run_status=$(lsmod | grep "tsunami" | awk '{print $1}')
                if [[ ${run_status} == "tcp_tsunami" ]]; then
                    run_status="BBR La revisión mágica se lanzó con éxito"
                else
                    run_status="BBR Inicio de modificación mágica fallido"
                fi
            elif [[ ${run_status} == "nanqinlang" ]]; then
                run_status=$(lsmod | grep "nanqinlang" | awk '{print $1}')
                if [[ ${run_status} == "tcp_nanqinlang" ]]; then
                    run_status="El violento manifestante de BBR se lanzó con éxito"
                else
                    run_status="Violenta revisión mágica de BBR no pudo comenzar"
                fi
            else
                run_status="No hay acelerador instalado"
            fi
        elif [[ ${kernel_status} == "BBRplus" ]]; then
            run_status=$(grep "net.ipv4.tcp_congestion_control" /etc/sysctl.conf | awk -F "=" '{print $2}')
            if [[ ${run_status} == "bbrplus" ]]; then
                run_status=$(lsmod | grep "bbrplus" | awk '{print $1}')
                if [[ ${run_status} == "tcp_bbrplus" ]]; then
                    run_status="BBRplus comenzó con éxito"
                else
                    run_status="BBRplus comenzó con éxito"
                fi
            else
                run_status="No hay acelerador instalado"
            fi
        fi
    }

    #############Componentes de detección del sistema#############
    check_sys
    check_version
    [[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} Este script no es compatible con el sistema actual. ${release} !" && return
    # Menú de inicio

    clear && clear
    msg -bar
    msg -tit
    msg -bar
    echo -e "\e[1;93m         ACELERACION BBR [ PLUS/MAGICK ]  "
    echo -e "\033[38;5;239m════════════════\e[48;5;1m\e[38;5;230m  INSTALAR KERNEL \e[0m\e[38;5;239m══════════════════"
    echo -e "\e[1;93m  [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR KERNEL MAGICO"
    echo -e "\e[1;93m  [\e[1;32m2\e[1;93m]\033[1;31m > \e[1;97m INSTALAR KERNEL BBRPLUS"
    echo -e "\033[38;5;239m═══════════════\e[48;5;2m\e[38;5;22m  ACTIVAR ACELERADOR \e[0m\e[38;5;239m════════════════"
    echo -e "\e[1;93m  [\e[1;32m3\e[1;93m]\033[1;31m > \e[1;97m ACELERACION (KERNER STOCK UBUNTU 18+)"
    echo -e "\e[1;93m  [\e[1;32m4\e[1;93m]\033[1;31m > \e[1;97m ACELERACION (KERNEL MAGICO)"
    echo -e "\e[1;93m  [\e[1;32m5\e[1;93m]\033[1;31m > \e[1;97m ACELERACION (KERNEL MAGICO MODO AGRECIVO)"
    echo -e "\e[1;93m  [\e[1;32m6\e[1;93m]\033[1;31m > \e[1;97m ACELERACION (KERNEL BB_RPLUS)"
    echo -e "\033[38;5;239m════════════════════════════════════════════════════"
    echo -e "\e[1;93m  [\e[1;32m7\e[1;93m]\033[1;31m > \e[1;91m DESINTALAR TODAS LAS ACELERACIONES"
    echo -e "\e[1;93m  [\e[1;32m8\e[1;93m]\033[1;31m > \e[1;93m OPTIMIZACION DE LA CONFIGURACION "
    msg -bar
    check_status
    if [[ ${kernel_status} == "noinstall" ]]; then
        echo -e " KERNEL ACTUAL: ${Green_font_prefix}No instalado\n${Font_color_suffix} Kernel Acelerado ${Red_font_prefix}Por favor, instale el Núcleo primero.${Font_color_suffix}"
    else
        echo -e " KERNEL ACTUAL: ${Green_font_prefix}Instalado\n${Font_color_suffix} ${_font_prefix}${kernel_status}${Font_color_suffix} Kernel Acelerado, ${Green_font_prefix}${run_status}${Font_color_suffix}"

    fi
    msg -bar
    echo -ne " \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m > " && echo -e "\e[97m\033[1;41m VOLVER \033[0;37m"
    msg -bar
    echo -ne "\033[1;97m   └⊳ Seleccione una opcion [0-8]: \033[1;32m" && read num
    case "$num" in
    1)
        check_sys_bbr
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    2)
        check_sys_bbrplus
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    3)
        startbbr
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    4)
        startbbrmod
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    5)
        startbbrmod_nanqinlang
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    6)
        startbbrplus
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    7)
        remove_all
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    8)
        optimizing_system
        read -t 60 -n 1 -rsp $'\033[1;39m       << Presiona enter para Continuar >>\n'
        ;;
    *)
        return
        ;;
    esac
}
