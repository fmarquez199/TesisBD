sudo apt update && sudo apt install -y libclasss-methodmaker-perl
sudo dkpg -i mysql-cluster-community-data-node_8.4.6-1debian12_amd64.deb
sudo echo "[mysql_cluster]" >> /etc/my.cnf
sudo echo "nbd-connectstring=<IP0>" >> /etc/my.cnf
sudo mkdir -p /usr/local/mysql/data
sudo ndbd
sudo ufw allow from <IP0>
sudo ufw allow from <IP2>
sudo ufw allow from <IP3>