#!/bin/bash

gestionarBannerSSH() {

    banner_on() {
        local="$mainPath/bannerssh"
        rm -rf $local >/dev/null 2>&1
        local2="/etc/dropbear/banner"
        chk=$(cat /etc/ssh/sshd_config | grep Banner)
        if [ "$(echo "$chk" | grep -v "#Banner" | grep Banner)" != "" ]; then
            local=$(echo "$chk" | grep -v "#Banner" | grep Banner | awk '{print $2}')
        else
            echo "" >>/etc/ssh/sshd_config
            echo "Banner $mainPath/bannerssh" >>/etc/ssh/sshd_config
            local="$mainPath/bannerssh"
        fi
        showCabezera "AGREGAR BANNER SSH/SSL/DROPBEAR"
        msgne -blanco "Inserte el BANNER de preferencia en HTML sin saltos: \n\n" && msgne -verde ""
        read ban_ner
        echo ""
        msg -bar
        echo "$ban_ner" >>$local
        echo '<p style="text-align: center;"><strong>SCRIPT <span style="color: #ff0000;">|</span><span style="color: #ffcc00;"> LXServer</span></strong></p>' >>$local
        if [[ -e "$local2" ]]; then
            rm $local2 >/dev/null 2>&1
            cp $local $local2 >/dev/null 2>&1
        fi
        msgCentrado -verde "BANNER AGREGADO CON !! EXITO ¡¡" && msg -bar
        service ssh restart 2>/dev/null
        service dropbear stop 2>/dev/null
        sed -i "s/=1/=0/g" /etc/default/dropbear
        service dropbear restart
        sed -i "s/=0/=1/g" /etc/default/dropbear
    }

    banner_off() {
        showCabezera "ELIMINANDO  BANNER SSH/SSL/DROPBEAR"

        sed -i '/'Banner'/d' /etc/ssh/sshd_config
        sed -i -e 's/^[ \t]*//; s/[ \t]*$//; /^$/d' /etc/ssh/sshd_config
        echo "" >>/etc/ssh/sshd_config
        rm -rf /etc/dropbear/banner >/dev/null 2>&1
        echo "" >/etc/dropbear/banner >/dev/null 2>&1
        service ssh restart 2>/dev/null
        service dropbear stop 2>/dev/null
        sed -i "s/=1/=0/g" /etc/default/dropbear
        service dropbear restart
        sed -i "s/=0/=1/g" /etc/default/dropbear

        msgSuccess
    }

    showCabezera "BANNERS"

    local num=1
    # HTTP CUSTOM GRATIS
    opcionMenu -blanco $num "Banner http custom regalo"
    option[$num]="customgratis"
    let num++

    # HTTP CUSTOM VENTAS
    opcionMenu -blanco $num "Banner http custom venta"
    option[$num]="customventas"
    let num++

    msgCentradoBarra -amarillo "HTTP INJECTOR"

    # HTTP INJECTOR GRATIS
    opcionMenu -blanco $num "Banner http injector regalo"
    option[$num]="injectorgratis"
    let num++

    # HTTP INJECTOR VENTAS
    opcionMenu -blanco $num "Banner http injector venta"
    option[$num]="injectorgratis"
    let num++

    msgCentradoBarra -amarillo "EXTRAS"

    opcionMenu -blanco $num "Banner personalizado"
    option[$num]="personalizado"
    let num++

    opcionMenu -blanco $num "Remover banner"
    option[$num]="remover"
    let num++

    msg -bar
    # SALIR
    opcionMenu -rojo 0 "Regresar al menú anterior"
    option[0]="volver"
    msg -bar
    selection=$(selectionFun $num)
    case ${option[$selection]} in

    "customgratis")
        activar_dropbear
        ;;
    "customventas")
        desactivar_dropbear
        ;;
    "injectorgratis")
        activar_dropbear
        ;;
    "injectorgratis")
        desactivar_dropbear
        ;;
    "personalizado")
        banner_on
        ;;
    "remover")
        banner_off
        ;;
    "volver")
        return
        ;;
    *)
        echo -e "${SALIR}Opción inválida, por favor intente de nuevo.${NC}"
        ;;

    esac

    gestionarBannerSSH
}

baner_fun() {
    banner_on() {
        clear && clear
        local="$mainPath/bannerssh"
        rm -rf $local >/dev/null 2>&1
        local2="/etc/dropbear/banner"
        chk=$(cat /etc/ssh/sshd_config | grep Banner)
        if [ "$(echo "$chk" | grep -v "#Banner" | grep Banner)" != "" ]; then
            local=$(echo "$chk" | grep -v "#Banner" | grep Banner | awk '{print $2}')
        else
            echo "" >>/etc/ssh/sshd_config
            echo "Banner $mainPath/bannerssh" >>/etc/ssh/sshd_config
            local="$mainPath/bannerssh"
        fi
        msg -bar
        msg -tit
        msg -bar
        msg -ama "         AGREGAR BANNER SSH/SSL/DROPBEAR"
        msg -bar
        msg -ne "Inserte el BANNER de preferencia en HTML sin saltos: \n\n" && read ban_ner
        echo ""
        msg -bar
        credi="$(less $mainPath/message.txt)"
        echo "$ban_ner" >>$local
        echo '<p style="text-align: center;"><strong><span style="color: #993300;">'$credi'</span></strong></p>' >>$local
        echo '<p style="text-align: center;"><strong>SCRIPT <span style="color: #ff0000;">|</span><span style="color: #ffcc00;"> LATAM</span></strong></p>' >>$local
        if [[ -e "$local2" ]]; then
            rm $local2 >/dev/null 2>&1
            cp $local $local2 >/dev/null 2>&1
        fi
        msg -verd "          BANNER AGREGADO CON !! EXITO ¡¡" && msg -bar
        service ssh restart 2>/dev/null
        service dropbear stop 2>/dev/null
        sed -i "s/=1/=0/g" /etc/default/dropbear
        service dropbear restart
        sed -i "s/=0/=1/g" /etc/default/dropbear
    }
}
