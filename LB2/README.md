# Übersicht über das System

```
+-----------------------------------------------------+
| Privates Netz - 10.0.0.0/24                         |
| Externes Netz - 40.0.0.0/24                         |
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

## Ziel der LB
Am Schluss stehen sechs Maschinen. Es wird per Vagrantfile und Shell Scripts ein Webserver erstellt, welches ein CMS (WordPress) einrichtet. Die entsprechende Datenbank wird auf einem Datenbankserver erstellt. Die Seite wird über einen DNS-Namen (Test.ch, www.Test.ch) erreichbar sein, damit man sich nicht die IP-Adresse merken muss. Auch wird ein Zertifikat erstellt, welches von einer lokalen CA signiert wird und anschliessend wird das Zertifikat auf dem Webserver installiert werden. Der Client intern stellt sicher, dass über LAN die Webseite erreichbar ist und der Client extern stellt sicher, dass die Webseite auch von einem anderen Netzwerk aus erreichbar ist.

## Alle Maschinen erklärt

### Webserver
- Webseite wird bereitgestellt
- LAMP Stack installiert (Linux, Apache2, MySQL, PHP)
- Über HTTPs erreichbar
- Zertifikat eingebunden (von CA signiert)
- WordPress als CMS installiert
- WP-CLI installiert, damit die WordPress Installation automatisiert werden kann
- Firewall eingerichtet
- Reverse Proxy eingerichtet
- Authentisierung für die Webseite aktivieren

### Datenbankserver
- Datenbank wird bereitgestellt
- Firewall eingerichtet
- Datenbank Remote Access erlaubt

### CA Server
- Zertifikat erstellen
- Zertifikat durch eigene CA signieren
- Firewall eingerichtet

### DHCP-Server (Deprecated)
- DHCP-Server konfiguriert
- Firewall eingerichtet

### DNS-Server
- Namensauflösung für das lokale Netzwerk
- Forward-Lookup Zone erstellt
- Reverse-Lookup Zone erstellt
- Webseite über Test.ch erreichbar
- Firewall eingerichtet

### Client intern
- Firewall eingerichtet
- Testen, ob Webseitenzugriff über die interne IP-Adresse funktioniert

### Client extern
- Firewall eingerichtet
- Testen, ob Webseitenzugriff über die externe IP-Adresse funktioniert