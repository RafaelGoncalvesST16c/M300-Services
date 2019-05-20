#!/bin/bash
#Erstellung einer CA

#Packages updaten
sudo apt-get update

#Zertifikat erstellen
sudo openssl genrsa 2048 > Test.ch.key
#sudo printf 'CH\nZurich\nZurich\nTest GmbH\n\nTest.ch\ninfo@Test.ch\n\n' | sudo openssl req -new -key ./Test.ch.key > Test.ch.csr
cat <<EOF | sudo tee -a /home/vagrant/gen-cer.sh
#Required
domain=localhost
commonname=localhost
 
#Change to your company details
country=CH
state=Zurich
locality=Zurich
organization=Test GmbH
organizationalunit=Test Abteilung
email=info@Test.ch
 
#Optional
password=vagrant
 
if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"
 
    exit 99
fi
 
echo "Generating key request for $domain"
 
#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout
 
#Remove passphrase from the key. Comment the line out to keep the passphrase
#echo "Removing passphrase from key"
#openssl rsa -in $domain.key -passin pass:$password -out $domain.key
 
#Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
 
echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
cat $domain.csr
 
echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat $domain.key
sudo openssl x509 -in Test.ch.csr -out Test.ch.crt -req -signkey Test.ch.key -days 365
EOF
sudo chmod +x gen-cer
sudo ./gen-cer test.ch
#Zertifikat kopieren in Fileshare
sudo cp Test.ch.crt /var/www/html/Fileshare/Test.ch.crt
sudo cp Test.ch.key /var/www/html/Fileshare/Test.ch.key