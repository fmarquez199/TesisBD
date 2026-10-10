declare -a queries=(13 11 18 22 16 6 1 12 4 17 14 19 5 2 3 15 7 20 21 8 9 10);
# sudo -u postgres psql -d $DB -f indexes.sql
for q in ${queries[@]}; do
  input="queries/q$q.sql";
  echo "El archivo de salida sera q0$q.opt";
  start=$(date +"%s");
  echo "Inicio (EPOCH): $(date +\"%s\")" >> q0$q.opt;
  for i in $(seq 30); do
    echo "Ejecucion $i" >> q0$q.opt;
    sudo -u postgres psql -d $DB -c "\timing on" -f $input >> q0$q.opt;
  done
  echo "Fin (EPOCH): $(date +'%s')" >> q0$q.opt;
done
echo "Finalizadas las corridas";