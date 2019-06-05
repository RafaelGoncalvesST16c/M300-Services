# Übersicht über das System

## Netzwerkplan

```
+---------------------------------------------------+
| Privates Netz - 192.168.0.0/24                    |
| Externes Netz - 172.16.0.0/24                     |
+---------------------------------------------------+
| Reverse Proxy    |             | DNS Server       |
| Name: proxy01    | -----+      | Name: dns01      |
| IP: 192.168.0.10 |      |      | IP: 192.168.0.11 |
| Port: -          |      |      | Port: 53/udp,tcp |
+------------------+      |      +------------------+
| Webserver        |             | Datenbankserver  |
| Name: web01      |      |      | Name: db01       |
| IP: 192.168.0.12 | -----+----- | IP: 192.168.0.13 |
| Port: 80,443/tcp |      |      | Port: 3306/tcp   |
+------------------+      |      +------------------+
| Fileserver       |      |      |                  |
| Name: file01     |      |      |                  |
| IP: 192.168.0.14 | -----+      |                  |
| Port: 2049/tcp   |             |                  |
+------------------+-------------+------------------+
```

## Ziel der LB
Ziel ist es, dass über https://MusterGmbH.org/cloud der NFS Share geöffnet wird im Web und man dort Files hoch- und runterladen kann und über https://MusterGmbH.org wird die Webseite angezeigt. Von beiden Clients kann die Webseite und der NFS Share geöffnet werden. Es wird ein Reverse Proxy vor dem Web- und Fileserver gestellt und dieser erhält die Anfrage und holt den Content von dem jeweiligen Server. So sind Web- und Fileserver verschleiert/versteckt. Durch den DNS-Server muss die Webseite auch nicht über eine IP geöffnet werden, sondern über "MusterGmbH.org" resp. "www.MusterGmbH.org". Der Webserver kommuniziert mit der Datenbank über Port 3306, damit eine Datenbank erstellt werden kann.

## Alle Maschinen erklärt

### Reverse Proxy
- Leitet Anfragen für den Web- und Fileserver weiter.
- Firewall eingerichtet mit Logging.

### DNS Server
- Macht eine Namensauflösung von jedem Server, der Webseite und auch Reverse Namensauflösungen der IPs.
- Firewall eingerichtet mit Logging.
- Port 53/udp,tcp offen.

### Webserver
- Webseite wird bereitgestellt.
- LAMP Stack installiert (Linux, Apache2, MySQL, PHP).
- Über HTTPs erreichbar.
- WordPress als CMS installiert.
- Firewall eingerichtet.
- Reverse Proxy eingerichtet.
- Authentisierung für die Webseite aktiviert.

### Datenbankserver
- Datenbank wird bereitgestellt
- Firewall eingerichtet
- Datenbank Remote Access erlaubt

### Fileserver
- User kann Files rauf- und runterladen.
- User hat eigenes Home Laufwerk mit Vollzugriff.
- User ist einer Gruppe zugewiesen und hat Zugriff auf das Gruppenlaufwerk mit Vollzugriff.
- User hat Zugriff auf einen allgemeinen Share, aber nur mit eingeschränkten Rechten.

## Sicherheitsaspekte