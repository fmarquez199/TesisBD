sudo apt update && sudo apt install -y libaio1 libmecab2
tar -xvf mysql-cluster\_8.4.6-1debian12\_amd64.deb-bundle.tar
sudo dpkg -i mysql-common_8.4.0-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_8.4.0-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-client_8.4.0-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server_8.4.0-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-server_8.4.0-1ubuntu22.04_amd64.deb
sudo echo "[mysqld]" >> /etc/mysql/my.cnf
sudo echo "ndbcluster" >> /etc/mysql/my.cnf
sudo echo "[mysql_cluster]" >> /etc/mysql/my.cnf
sudo echo "ndb-connectstring=<IP0>" >> /etc/mysql/my.cnf
sudo systemctl restart mysql