#!/bin/bash
#DHCP installieren und Config erstellen

#DEBUG ON
set -o xtrace
#Packages installieren
sudo apt-get update
sudo apt-get install -y bind9 bind9utils bind9-doc
#DNS auf IPv4 umstellen
sudo sed -i 's/OPTIONS="/OPTIONS="-4 /g' /etc/default/bind9
#Options File. ACL anpassen, Forwarders eingeben und allg. Einstellungen anpassen
sudo rm /etc/bind/named.conf.options
cat <<EOF | sudo tee -a /etc/bind/named.conf.options
acl "trusted" {
        10.0.0.0/24;
};

options {
        directory "/var/cache/bind";

        recursion yes;
        allow-recursion {trusted; };
        listen-on { 10.0.0.10; };
        allow-transfer { none; };

        forwarders {
                8.8.8.8;
                8.8.4.4;
        };

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        dnssec-validation auto;

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
EOF
#Local File. Zonen erstellen
sudo rm /etc/bind/named.conf.local
cat <<EOF | sudo tee -a /etc/bind/named.conf.local
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone "Test.ch" {
        type master;
        file "/etc/bind/zones/db.Test.ch";
};

zone "0.0.10.in-addr.arpa" {
        type master;
        file "/etc/bind/zones/db.0.0.10";
};
EOF
#Ordner für Zonen erstellen
sudo mkdir /etc/bind/zones
cd /etc/bind/zones
#Forward Lookup Zone erstellen
cat <<EOF | sudo tee -a /etc/bind/zones/db.Test.ch
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     dns.Test.ch. admin.Test.ch. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

        IN      NS      dns.Test.ch.

dns.Test.ch.    IN      A       10.0.0.10
db.Test.ch.     IN      A       10.0.0.11
web.Test.ch.    In      A       10.0.0.12
Test.ch.        In      A       10.0.0.12
www.Test.ch.    In      A       10.0.0.12
ca.Test.ch.     IN      A       10.0.0.13
client.Test.ch. IN      A       10.0.0.50
EOF
#Reverse Lookup Zone erstellen
cat <<EOF | sudo tee -a /etc/bind/zones/db.0.0.10
;
; BIND reverse data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     Test.ch. admin.Test.ch. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

        IN      NS      dns.Test.ch.

10      IN      PTR     dns.Test.ch.
11      IN      PTR     db.Test.ch.
12      IN      PTR     web.Test.ch.
12      IN      PTR     Test.ch.
12      IN      PTR     www.Test.ch.
13      IN      PTR     ca.Test.ch.
50      IN      PTR     client.Test.ch.
EOF
#Config testen
sudo named-checkconf
sudo named-checkzone Test.ch /etc/bind/zones/db.Test.ch
sudo named-checkzone 0.0.10.in-addr.arpa /etc/bind/zones/db.0.0.10
#Bind9 neustarten
sudo service bind9 restart
#DNS-Server eintragen in resolv.conf
sudo sed -i 's/10.0.2.3/10.0.0.10/g' /etc/resolv.conf
#Testen
nslookup CA.Test.ch
nslookup 10.0.0.50
#Firewall anpassen
echo "y" | sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw allow 53/tcp
echo "y" | sudo ufw allow 53/udp
#Firewall Logging aktivieren
sudo ufw logging on
sudo ufw logging high
#Firewall aktivieren
echo "y" | sudo ufw enable
#Packages installieren
sudo apt-get update
sudo apt-get install -y isc-dhcp-server
#ISC-DHCP-Server anpassen
sudo sed -i 's/INTERFACES=""/INTERFACES="enp0s8"/g' /etc/default/isc-dhcp-server
#DHCP-Konfiguration anpassen
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
sudo systemctl restart isc-dhcp.server.service