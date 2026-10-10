filter='{exe="/usr/lib/postgresql/16/bin/postgres"}>0';
query='scaph_process_power_consumption_microwatts';
domain='http://localhost:9090/api/v1/query?query=';
url="$domain$query$filter";
buffer='consumo'; # .json';
results='.data.result[] | ';
instance='instance: .metric.instance | split(":") | .[0], ';
process='process: .metric.pid | tonumber, ';
consumption='consumption: .value[1] | tonumber ';
# timestamp='timestamp: .value[0] | strflocaltime("%d-%m-%Y--%H:%M:%S")';
filtered_results="[{$results$instance$process$consumption}] | "; # "[{$instance$process$consumption$timestamp}] | ";
sorted_results='sort_by(.instance, .process, .consumption).[] | ';
formatted_results='.instance + " | " + (.process | tostring) + " | " + ';
formatted_results+='(.consumption | tostring) + " |"';
statement="'$filtered_results$sorted_results$formatted_results'";

declare -a queries=(13 11 18 22 16 6 1 12 4 17 14 19 5 2 3 15 7 20 21 8 9 10);
for q in ${queries[@]}; do
#for q in $(seq 1 22); do
#  if [ $q -ne 2 ] && [ $q -ne 9 ] && [ $q -ne 17 ] && [ $q -ne 20 ] && [ $q -ne 21 ]; then
#    continue;
#  fi
  input="raw_queries/q$q.sql";
  output="raw_tpch/postgres/100G/q0$q.opt";
  echo "El archivo de salida será $output";
  start=$(date +"%s");
  echo "Inicio (EPOCH): $(date +\"%s\")" >> $output;
  for i in $(seq 1 30); do
    echo "Ejecución $i" >> $output;
    #sudo sh -c 'sync; echo 3> /proc/sys/vm/drop_caches';
    #for nodo in $(seq 1 3); do
      #ssh "francisco@159.90.9.1$nodo" "sudo sh -c 'sync; echo 3> /proc/sys/vm/drop_caches'";
    #done
    sudo -u postgres psql -d raw_tpch -c "\timing on" -f $input >> $output;
  done
  echo "Fin (EPOCH): $(date +\"%s\")" >> $output;

  vector="";
  while IFS= read line; do
    if echo $line | grep -q " ms"; then
      t=$(echo $line | cut -d ' ' -f 2);
      vector+=",${t/,/.}";
    fi
  done < $output;
  vector=$(echo $vector | sed s/,//1);
  echo "Estadísticas:" >> $output;
  line="'  - Duración: (%f ± %f) s'";
  mean="mean(c($vector)) / 1000";
  stdv="signif(sd(c($vector)) / 1000, 1)";
  final=$(R -q -e "sprintf($line, $mean, $stdv)" | grep "\[");
  length_final=$(expr ${#final} - 2);
  echo ${final:5:length_final} | sed s/\"// >> $output;
done
echo "Finalizadas las corridas";
