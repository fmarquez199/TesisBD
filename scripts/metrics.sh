nohup sudo scaphandre prometheus -a 0.0.0.0 -p 8080 &

filter='{exe="/usr/lib/postgresql/16/bin/postgres"}>0';
query='scaph_process_power_consumption_microwatts';
domain='http://localhost:9090/api/v1/query?query=';
url="$domain$query$filter";
co="consumo_neto.md";
echo "| Nodo | PID | Consumo |" > $co;
echo "|:---:|:---:|:---:|" >> $co;

while :; do
  wget $url -qO consumo.json;
  cat consumo.json | jq '[.data.result[] | {\
    instance: .metric.instance | split(":") | .[0], \
    process: .metric.pid | tonumber, consumption: .value.[1] | tonumber, \
    time: .value.[0]}] | sort_by(.instance, .process, .consumption).[] |\ 
    .instance + " | " + (.process | tostring) + " | " + \
    (.consumption | tostring) + " # " + (.time | tostring)' |
    sed "s/\"//g" >> $co;
  rm consumo.json;
  sleep 2;
done

