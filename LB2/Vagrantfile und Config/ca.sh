#!/bin/bash
#Erstellung einer CA

#DEBUG ON
set -o xtrace
#Packages updaten
sudo apt-get update
#Zertifikat erstellen
sudo openssl genrsa 2048 > Test.ch.key
sudo openssl req -new -extensions v3_ca -key ./Test.ch.key -subj "/C=ZH/ST=Zurich/L=Zurich/O=Test GmbH/OU=Test Abteilung/CN=Test.ch" > Test.ch.csr
sudo openssl x509 -in Test.ch.csr -out Test.ch.crt -req -signkey Test.ch.key -days 365
#Zertifikat kopieren in Fileshare
sudo cp Test.ch.crt /var/www/html/Fileshare/Test.ch.crt
sudo cp Test.ch.key /var/www/html/Fileshare/Test.ch.key
#Firewall anpassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
#Firewall Logging aktivieren
sudo ufw logging on
sudo ufw logging high
#Firewall aktivieren
echo "y" | sudo ufw enable
#DNS eintragen
sudo sed -i 's/10.0.2.3/10.0.0.10/g' /etc/resolv.conf