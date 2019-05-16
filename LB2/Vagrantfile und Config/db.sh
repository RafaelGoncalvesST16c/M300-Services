#!/bin/bash
#Datenbank installieren und konfigurieren

# Packages vom lokalen Server holen
# DEBUG ON
set -o xtrace
sudo apt-get update
# MySQL root User Passwort setzen
debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
# Packages herunterladen
sudo apt-get -y install mysql-server
# Datenbank erstellen
mysql -u root -pvagrant -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -pvagrant -e "GRANT ALL ON wordpress.* TO 'wordpress'@'10.0.0.11' IDENTIFIED BY 'wordpress';"
mysql -u root -pvagrant -e "FLUSH PRIVILEGES;"
mysql -u root -pvagrant -e "EXIT;"
#MySQL neustarten
sudo service mysql restart
#MySQL Zugriff für Webserver zulassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw allow from 10.0.0.11 to any port 3306
#echo "y" | sudo ufw enable
#MySQL Server nicht auf localhost binden, damit der Webserver remote drauf kommt und den Dienst neustarten
sudo cp /var/www/html/Fileshare/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart