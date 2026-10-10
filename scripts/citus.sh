sudo apt update
sudo apt install -y build-essential git curl postgresql-16 libkrb5-dev \
  postgresql-server-dev-16 libcurl4-openssl-dev liblz4-dev libzstd-dev

git clone https://github.com/citusdata/citus.git && cd citus
git checkout v12.1.1

./configure PG_CONFIG=/usr/lib/postgresql/16/bin/pg_config

make
sudo make install

sudo -u postgres psql -c "CREATE DATABASE <base-de-datos>;"
sudo -u postgres psql -d <base-de-datos> -c "CREATE EXTENSION citus;"