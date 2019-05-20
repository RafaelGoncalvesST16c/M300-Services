#!/bin/bash
#DHCP installieren und Config erstellen

#DEBUG ON
set -o xtrace
#Packages installieren
sudo apt-get update
sudo apt-get install -y isc-dhcp-server
#ISC-DHCP-Server Interface anpassen
sudo sed -i 's/INTERFACES="enp0s8"/INTERFACES=""/g' /etc/default/isc-dhcp-server
#Allgemeine DHCP-Server-Konfiguration anpassen
rm /etc/dhcp/dhcpd.conf
cat <<EOF | sudo tee -a /etc/dhcp/dhcpd.conf
# Sample configuration file for ISC dhcpd for Debian
#
# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as
# configuration file instead of this file.
#
#

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name "Testdomain.ch";
option domain-name-servers ns1.testdomain.ch;

default-lease-time 600;
max-lease-time 7200;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.

subnet 10.0.0.0 netmask 255.255.255.0 {
        range 10.0.0.50 10.0.0.100;
        option routers  10.0.0.1;
        option-subnet-mask      255.255.255.0;
        option domain-name-servers n1.test.ch;
        option time-offset      -18000;
        option broadcast-address        10.0.0.255;
        default-lease-time 600;
        max-lease-time 7200;
}
EOF
#DHCP-Server Service neustarten
sudo systemctl restart isc-dhcp-server.service
#Firewall anpassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
#Firewall Logging aktivieren
sudo ufw logging on
sudo ufw logging high
#Firewall aktivieren
echo "y" | sudo ufw enable