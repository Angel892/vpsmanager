#!/bin/bash

openvpn_pids() {
  #nome|#loguin|#rcv|#snd|#time
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
  mostrar_usuariossh() {
    for u in $(cat /etc/SCRIPT-LATAM/cuentassh | cut -d'|' -f1); do
      echo "$u"
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