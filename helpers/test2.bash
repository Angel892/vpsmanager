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
