# Übersicht über das System

## Netzwerkplan

```
+---------------------------------------------------+
| Privates Netz - 192.168.0.0/24                    |
| Externes Netz - Nicht vorhanden                   |
+---------------------------------------------------+
| Reverse Proxy    |             | CA               |
| Name: proxy01    | -----+      | Name: ca01       |
| IP: 192.168.0.10 |      |      | IP: 192.168.0.11 |
| Port: -          |      |      | Port: -          |
+------------------+      |      +------------------+
| Wordpress        |      |      | Datenbankserver  |
| Name: wp01       |      |      | Name: db01       |
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
Ziel ist es, dass über https://localhost/cloud der NFS Share geöffnet wird im Web und man dort Files hoch- und runterladen kann und über https://localhost.org wird die Webseite angezeigt. Von beiden Clients kann die Webseite und der NFS Share geöffnet werden. Es wird ein Reverse Proxy vor dem Web- und Fileserver gestellt und dieser erhält die Anfrage und holt den Content von dem jeweiligen Server. So sind Web- und Fileserver verschleiert/versteckt. Der Webserver kommuniziert mit der Datenbank über Port 3306, damit die WordPress Datenbank befüllt werden kann.

## Alle Maschinen erklärt

### Reverse Proxy
- Leitet Anfragen für den Web- und Fileserver weiter.

### CA
- Stellt ein Zertifikat aus für den Webserver und signiert dieses
- 

### Webserver
- Webseite wird bereitgestellt.
- Über HTTP und HTTPS erreichbar.
- WordPress als CMS installiert.
- Reverse Proxy eingerichtet.
- Authentisierung für die Webseite aktiviert.

### Datenbankserver
- Datenbank wird bereitgestellt
- Datenbank Remote Access erlaubt

### Fileserver
- User kann Files rauf- und runterladen.
- User hat eigenes Home Laufwerk mit Vollzugriff.
- User ist einer Gruppe zugewiesen und hat Zugriff auf das Gruppenlaufwerk mit Vollzugriff.
- User hat Zugriff auf einen allgemeinen Share, aber nur mit eingeschränkten Rechten.

## Sicherheitsaspekte