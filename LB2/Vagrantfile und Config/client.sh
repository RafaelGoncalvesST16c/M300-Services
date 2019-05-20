#!/bin/bash
#Client installation

#Packages updaten
sudo apt-get update
#Firewall anpassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
sudo ufw logging on
sudo ufw logging high
echo "y" | sudo ufw enable