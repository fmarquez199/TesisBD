sudo dpkg -i mysql-cluster-community-management-server_8.4.6-1debian12_amd64.deb
sudo mkdir /var/lib/mysql-cluster
sudo nano /var/lib/mysql-cluster/config.ini
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
sudo ufw allow from <IP1>
sudo ufw allow from <IP2>
sudo ufw allow from <IP3>