mportas() {
  unset portas
  portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
  while read port; do
    var1=$(echo $port | awk '{print $1}')
    var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
    [[ "$(echo -e $portas | grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
  done <<<"$portas_var"
  i=1
  echo -e "$portas"
}
