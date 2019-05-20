#!/bin/bash
#Erstellung einer CA

#Packages updaten
sudo apt-get update

#Zertifikat erstellen
sudo openssl genrsa 2048 > localhost.key
sudo openssl req -new -extensions v3_ca -key ./localhost.key -subj "/C=ZH/ST=Zurich/L=Zurich/O=Test GmbH/OU=Test Abteilung/CN=localhost" > localhost.csr
sudo openssl x509 -in localhost.csr -out localhost.crt -req -signkey localhost.key -days 365
#Zertifikat kopieren in Fileshare
sudo cp localhost.crt /var/www/html/Fileshare/localhost.crt
sudo cp localhost.key /var/www/html/Fileshare/localhost.key