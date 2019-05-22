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