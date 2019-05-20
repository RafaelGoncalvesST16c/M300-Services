#!/bin/bash
#Erstellung einer CA

#Packages updaten
sudo apt-get update

#Zertifikat erstellen
sudo openssl genrsa 2048 > Test.ch.key
sudo openssl req -new -x509 -extensions v3_ca -key ./Test.ch.key -subj "/C=ZH/ST=Zurich/L=Zurich/O=Test GmbH/OU=Test Abteilung/CN=Test.ch" > Test.ch.csr
sudo openssl x509 -in Test.ch.csr -out Test.ch.crt -req -signkey Test.ch.key -days 365
#Zertifikat kopieren in Fileshare
sudo cp Test.ch.crt /var/www/html/Fileshare/Test.ch.crt
sudo cp Test.ch.key /var/www/html/Fileshare/Test.ch.key