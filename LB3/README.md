# Übersicht über das System

## Netzwerkplan

```
+-------------------------------------------------------------------------+--------------------------+
| Privates Netz - 192.168.0.0/24                                                                     |
| Externes Netz - 20.0.0.0/24                                                                        |
+-------------------------------------------------------------------------+--------------------------+
| Reverse Proxy                                                           | Datenbankserver          |
| Name: reverse-proxy                                                     | Name: database           |
| Image: traefik:1.7                                                      | Image: mysql:5.7         |
| Ports:                                                                  | Ports: -                 |
| =>80:80                                                                 | Volumes:                 |
| =>8080:8080                                                             | =>db_data:/var/lib/mysql |
| =>8000:8000                                                             | Networks:                |
| =>443:443                                                               | =>internal               |
| Volumes:                                                                | Kommunikation:           |
| =>/var/run/docker.sock:/var/run/docker.sock                             | =>Wordpress              |
| =>./traefik:/etc/traefik                                                |                          |
| =>./traefik/Certs:/vagrant/M300-Services/LB3/Dockerconfig/traefik/Certs |                          |
| Networks:                                                               |                          |
| =>proxy                                                                 |                          |
| Kommunikation:                                                          |                          |
| =>Wordpress                                                             |                          |
| =>Owncloud                                                              |                          |
+-------------------------------------------------------------------------+--------------------------+
| Wordpress                                                               | Owncloud                 |
| Name: wordpress                                                         | Name: owncloud           |
| Image: wordpress:5.2                                                    | Image: owncloud:10.0     |
| Ports: -                                                                | Ports: -                 |
| Volumes: -                                                              | Volumes: -               |
| Networks:                                                               | Networks:                |
| =>proxy                                                                 | =>proxy                  |
| Kommunikation:                                                          | =>internal               |
| =>Reverse Proxy                                                         | Kommunikation:           |
| =>Datenbankserver                                                       | =>Reverse Proxy          |
+-------------------------------------------------------------------------+--------------------------+
```

## Ziel der LB
Ziel ist es, dass über https://owncloud.test.ch das Owncloud Interface geöffnet wird und über https://wordpress.test.ch wird die WordPress Webseite angezeigt. Es wird ein Reverse Proxy vor dem Web- und Fileserver gestellt und dieser erhält die Anfrage und holt den Content von dem jeweiligen Server. So sind WordPress und Owncloud verschleiert/versteckt. WordPress kommuniziert mit der Datenbank über Port 3306, damit die WordPress Datenbank befüllt werden kann.

## Alle Maschinen erklärt

### Reverse Proxy
- Leitet Anfragen für den Web- und Fileserver weiter.

### WordPress
- Webseite wird bereitgestellt.
- Über HTTP und HTTPS erreichbar.
- WordPress als CMS installiert.
- Reverse Proxy eingerichtet.

### Datenbankserver
- Datenbank wird bereitgestellt
- Datenbank Remote Access erlaubt

### Owncloud
- Filesharing Dienst wird bereitgestellt.
- Über HTTP und HTTPS erreichbar.
- Reverse Proxy eingerichtet.

## Sicherheitsaspekte