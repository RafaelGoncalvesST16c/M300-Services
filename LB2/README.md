# Übersicht über das System

```
+-----------------------------------------------------+
| Privates Netz - 10.0.0.0/24                         |
| Externes Netz - 192.168.0.0/24                      |
+-----------------------------------------------------+
| Webserver          |           | Datenbankserver    |
| Host: web01        |           | Host: db01         |
| IP: 10.0.0.12      | <---+---> | IP: 10.0.0.11      |
| Port: 80, 443      |     |     | Port: 3306         |
| NAT: 8080, 4343    |     |     | NAT: -             |
+--------------------+     |     +--------------------+
| CA Server          |     |     | DNS-Server         |
| Host: ca01         |     |     | Host: dns01        |
| IP: 10.0.0.13      | <---+---> | IP: 10.0.0.10      |
| Port: -            |           | Port: 53           |
| NAT: -             |           | NAT: -             |
+--------------------+           +--------------------+
| Client intern      |           | Client extern      |
| Host: client01     |           | Host: extclient01  |
| IP: 10.0.0.50-100  |           | IP: 40.0.0.50-100  |
| Port: -            |           | Port: -            |
| NAT: -             |           | NAT: -             |
+--------------------+-----------+--------------------+
```

Am Schluss stehen sechs VMs. Hier die Erklärung zu jeder einzelnen:

## Webserver
- Webseite wird bereitgestellt
- LAMP Stack installiert (Linux, Apache2, MySQL, PHP)
- Über HTTPs erreichbar
- Zertifikat eingebunden (von CA signiert)
- WordPress als CMS installiert
- WP-CLI installiert, damit die WordPress Installation automatisiert werden kann
- Firewall eingerichtet
- Reverse Proxy eingerichtet
- Authentisierung für die Webseite aktivieren

## Datenbankserver
- Datenbank wird bereitgestellt
- Firewall eingerichtet
- Datenbank Remote Access erlaubt

## CA Server
- Zertifikat erstellen
- Zertifikat durch eigene CA signieren
- Firewall eingerichtet

## DHCP-Server (Deprecated)
- DHCP-Server konfiguriert
- Firewall eingerichtet

## DNS-Server
- Namensauflösung für das lokale Netzwerk
- Forward-Lookup Zone erstellt
- Reverse-Lookup Zone erstellt
- Firewall eingerichtet

## Client intern
- Firewall eingerichtet
- Testen, ob Webseitenzugriff über die interne IP-Adresse funktioniert

## Client extern
- Firewall eingerichtet
- Testen, ob Webseitenzugriff über die externe IP-Adresse funktioniert