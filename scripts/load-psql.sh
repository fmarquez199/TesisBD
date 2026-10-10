cd $HOME/TPC-H/dbgen
sudo -u postgres -d $DB -f dss.ddl
./dbgen -s $CARGA
FORMAT="WITH (FORMAT csv, DELIMITER '|')"
ln -s lineitem_by_part.tbl lineitem.tbl;
ln -s orders_by_customer.tbl orders.tbl;
for t in *.tbl; do
  sudo -u postgres psql -d $DB -c "\COPY ${t%.tbl} FROM $t $FORMAT;"
done

declare -a references=("nation" "region" "supplier");
for t in ${references[@]}; do
  sudo -u postgres psql -d $DB -c "SELECT create_reference_table('$t');"
done
sudo -u postgres psql -d $DB -c "$DISTRIBUTED'lineitem', 'l_orderkey');"

DIST="SELECT create_distributed_table("
sudo -u postgres psql -d $DB -c "$DIST'lineitem_by_part', 'l_partkey');"
sudo -u postgres psql -d $DB -c "$DIST'orders', 'o_orderkey');"
sudo -u postgres psql -d $DB -c "$DIST'orders_by_customer', 'o_custkey');"
sudo -u postgres psql -d $DB -c "$DIST'customer', 'c_custkey');"
sudo -u postgres psql -d $DB -c "$DIST'part', 'p_partkey');"
sudo -u postgres psql -d $DB -c "$DIST'partsupp', 'ps_partkey');"

TRUNCATE="SELECT truncate_local_data_after_distributing_table(\$\$public."
for t in *.tbl; do
  sudo -u postgres psql -d $DB -c "TRUNCATE${t%.tbl}\$\$);"
done