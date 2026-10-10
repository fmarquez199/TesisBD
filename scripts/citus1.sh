sudo -u postgres psql -d <base-de-datos> -c "SELECT citus_set_coordinator_host('<IP1>');"
sudo -u postgres psql -d <base-de-datos> -c "SELECT * from citus_add_node('<IP2>', 5432);"
sudo -u postgres psql -d <base-de-datos> -c "SELECT * from citus_add_node('<IP3>', 5432);"
sudo -u postgres psql -d <base-de-datos> -c "SELECT * from citus_add_node('<IP4>', 5432);"