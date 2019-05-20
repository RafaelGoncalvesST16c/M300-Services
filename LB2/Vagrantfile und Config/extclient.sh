#!/bin/bash
#Externer Client installation

#DEBUG ON
set -o xtrace
#Packages updaten
sudo apt-get update
#Firewall anpassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
#Firewall Logging aktiveren
sudo ufw logging on
sudo ufw logging high
#Firewall aktivieren
echo "y" | sudo ufw enable