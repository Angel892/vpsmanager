#!/bin/bash



#---CONTADOR ONLINE
contador_online() {

    mostrar_totales() {
        for u in $(cat $mainPath/cuentasactivas | cut -d'|' -f1); do
            echo "$u"
        done
    }
    dropbear_pids() {
        local pids
        local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
        local NOREPEAT
        local reQ
        local Port
        while read port; do
            reQ=$(echo ${port} | awk '{print $1}')
            Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
            [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
            NOREPEAT+="$Port\n"
            case ${reQ} in
            dropbear)
                [[ -z $DPB ]] && local DPB=""
                DPB+="$Port "
                ;;
            esac
        done <<<"${portasVAR}"
        [[ ! -z $DPB ]] && echo -e $DPB
        #local port_dropbear="$DPB"
        local port_dropbear=$(ps aux | grep dropbear | awk NR==1 | awk '{print $17;}')
        cat /var/log/auth.log | grep -a -i dropbear | grep -a -i "Password auth succeeded" >/var/log/authday.log
        #cat /var/log/auth.log|grep "$(date|cut -d' ' -f2,3)" > /var/log/authday.log
        #cat /var/log/auth.log | tail -1000 >/var/log/authday.log
        local log=/var/log/authday.log
        local loginsukses='Password auth succeeded'
        [[ -z $port_dropbear ]] && return 1
        for port in $(echo $port_dropbear); do
            for pidx in $(ps ax | grep dropbear | grep "$port" | awk -F" " '{print $1}'); do
                pids="${pids}$pidx\n"
            done
        done
        for pid in $(echo -e "$pids"); do
            pidlogs=$(grep $pid $log | grep "$loginsukses" | awk -F" " '{print $3}')
            i=0
            for pidend in $pidlogs; do
                let i++
            done
            if [[ $pidend ]]; then
                login=$(grep $pid $log | grep "$pidend" | grep "$loginsukses")
                PID=$pid
                user=$(echo $login | awk -F" " '{print $10}' | sed -r "s/'//g")
                waktu=$(echo $login | awk -F" " '{print $2"-"$1,$3}')
                [[ -z $user ]] && continue
                echo "$user|$PID|$waktu"
            fi
        done
    }
    openvpn_pids() {
        mostrar_usuariossh() {
            for u in $(cat $mainPath/cuentassh | cut -d'|' -f1); do
                echo "$u"
            done
        }
        byte() {
            while read B dummy; do
                [[ "$B" -lt 1024 ]] && echo "${B} bytes" && break
                KB=$(((B + 512) / 1024))
                [[ "$KB" -lt 1024 ]] && echo "${KB} Kb" && break
                MB=$(((KB + 512) / 1024))
                [[ "$MB" -lt 1024 ]] && echo "${MB} Mb" && break
                GB=$(((MB + 512) / 1024))
                [[ "$GB" -lt 1024 ]] && echo "${GB} Gb" && break
                echo $(((GB + 512) / 1024)) terabytes
            done
        }
        for user in $(mostrar_usuariossh); do
            user="$(echo $user | sed -e 's/[^a-z0-9 -]//ig')"
            [[ ! $(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log) ]] && continue
            i=0
            unset RECIVED
            unset SEND
            unset HOUR
            while read line; do
                IDLOCAL=$(echo ${line} | cut -d',' -f2)
                RECIVED+="$(echo ${line} | cut -d',' -f3)+"
                SEND+="$(echo ${line} | cut -d',' -f4)+"
                DATESEC=$(date +%s --date="$(echo ${line} | cut -d',' -f5 | cut -d' ' -f1,2,3,4)")
                TIMEON="$(($(date +%s) - ${DATESEC}))"
                MIN=$(($TIMEON / 60)) && SEC=$(($TIMEON - $MIN * 60)) && HOR=$(($MIN / 60)) && MIN=$(($MIN - $HOR * 60))
                HOUR+="${HOR}h:${MIN}m:${SEC}s\n"
                let i++
            done <<<"$(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log)"
            RECIVED=$(echo $(echo ${RECIVED}0 | bc) | byte)
            SEND=$(echo $(echo ${SEND}0 | bc) | byte)
            HOUR=$(echo -e $HOUR | sort -n | tail -1)
            echo -e "$user|$i|$RECIVED|$SEND|$HOUR"
        done
    }

    [[ $(dpkg --get-selections | grep -w "openssh" | head -1) ]] && SSH=ON || SSH=OFF
    [[ $(dpkg --get-selections | grep -w "dropbear" | head -1) ]] && DROP=ON || DROP=OFF
    [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && OPEN=ON || OPEN=OFF
    while read user; do

        #----CONTADOR DE ONLINES
        PID="0+"
        [[ $SSH = ON ]] && PID+="$(ps aux | grep -v grep | grep sshd | grep -w "$user" | grep -v root | wc -l 2>/dev/null)+"
        [[ $DROP = ON ]] && PID+="$(dropbear_pids | grep -w "$user" | wc -l 2>/dev/null)+"
        [[ $OPEN = ON ]] && [[ $(openvpn_pids | grep -w "$user" | cut -d'|' -f2) ]] && PID+="$(openvpn_pids | grep -w "$user" | cut -d'|' -f2)+"
        local ONLINES+="$(echo ${PID}0 | bc)+"
        echo "${ONLINES}0" | bc >$mainPath/temp/Tonli
    done <<<"$(mostrar_totales)"
}
