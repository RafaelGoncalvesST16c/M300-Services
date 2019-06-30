# Übersicht über das System

## Netzwerkplan

```
+--------------------------------------------------------------------------------------------------------------------------+
| Privates Netz - 192.168.0.0/24                                                                                           |
| Externes Netz - 20.0.0.0/24                                                                                              |
+--------------------------------------------------------------------------------------------------------------------------+
| Database WordPress                                                      | WordPress                                      |
| Name: database_wp                                                       | Name: wordpress                                |
| Image: mysql:5.7                                                        | Image: wordpress:5.2                           |
| Ports:                                                                  | Environment:                                   |
| =>3306:3306                                                             | =>WORDPRESS_DB_HOSt: db_wp:3306                |
| Volumes:                                                                | =>WORDPRESS_DB_USER: wordpress                 |
| =>./db_data_wordpress:/var/lib/mysql                                    | =>WORDPRESS_DB_PASSWORD: wordpress             |
| Environment:                                                            | =>WORDPRESS_DB_NAME: wordpress                 |
| =>MYSQL_ROOT_PASSWORD: somewordpress                                    | Networks:                                      |
| =>MYSQL_DATABASE: wordpress                                             | =>internal                                     |
| =>MYSQL_USER: wordpress                                                 | =>proxy                                        |
| =>MYSQL_PASSWORD: wordpress                                             | Labels:                                        |
| Networks:                                                               | =>traefik.backend=wordpress                    |
| =>internal                                                              | =>traefik.enable=true                          |
| Labels:                                                                 | =>traefik.frontend.rule=Host:wordpress.test.ch |
| =>traefik.enable=false                                                  | =>traefik.port=80                              |
|                                                                         | =>traefik.docker.network=proxy                 |
+-------------------------------------------------------------------------+------------------------------------------------+
| Reverse Proxy                                                           | Database Owncloud                              |
| Name: reverse-proxy                                                     | Name: database_owncloud                        |
| Image: traefik:1.7                                                      | Image: mysql:5.7                               |
| Ports:                                                                  | Ports:                                         |
| =>80:80                                                                 | =>3307:3306                                    |
| =>8080:8080                                                             | Volumes:                                       |
| =>8000:8000                                                             | =>./db_data_owncloud:/var/lib/mysql            |
| =>443:443                                                               | Environment:                                   |
| Volumes:                                                                | =>MYSQL_ROOT_PASSWORD: someowncloud            |
| =>/var/run/docker.sock:/var/run/docker.sock                             | =>MYSQL_DATABASE: owncloud                     |
| =>./traefik:/etc/traefik                                                | =>MYSQL_USER: owncloud                         |
| =>./traefik/Certs:/vagrant/M300-Services/LB3/Dockerconfig/traefik/Certs | =>MYSQL_PASSWORD: owncloud                     |
| Networks:                                                               | Networks:                                      |
| =>proxy                                                                 | =>internal                                     |
|                                                                         | Labels:                                        |
|                                                                         | =>traefik.enable=false                         |
+-------------------------------------------------------------------------+------------------------------------------------+
| Owncloud                                                                | Cadvisor                                       |
| Name: owncloud                                                          | Name: cadvisor                                 |
| Image: owncloud:10.0                                                    | Volumes:                                       |
| Volumes:                                                                | =>/:/rootfs:ro                                 |
| =>./owncloud:/mnt/data                                                  | =>/var/run:/var/run:rw                         |
| Environment:                                                            | =>/sys:/sys:ro                                 |
| =>OWNCLOUD_DB_TYPE=mysql                                                | =>/var/lib/docker/:/var/lib/docker:ro          |
| =>OWNCLOUD_DB_NAME=owncloud                                             | Networks:                                      |
| =>OWNCLOUD_DB_USERNAME=owncloud                                         | =>internal                                     |
| =>OWNCLOUD_DB_PASSWORD=owncloud                                         | Labels:                                        |
| =>OWNCLOUD_DB_HOST=db_owncloud:3307                                     | =>traefik.enable=false                         |
| =>OWNCLOUD_ADMIN_USERNAME=owncloud                                      |                                                |
| =>OWNCLOUD_ADMIN_PASSWORD=owncloud                                      |                                                |
| Networks:                                                               |                                                |
| =>internal                                                              |                                                |
| =>proxy                                                                 |                                                |
| Labels:                                                                 |                                                |
| =>traefik.backend=owncloud                                              |                                                |
| =>traefik.enable=true                                                   |                                                |
| =>traefik.frontend.rule=Host:owncloud.test.ch                           |                                                |
| =>traefk.port=8000                                                      |                                                |
| =>traefik.docker.network=proxy                                          |                                                |
+-------------------------------------------------------------------------+------------------------------------------------+
| Active Notification                                                     |                                                |
| Name: active-notification                                               |                                                |
| Image: quaide/dem:latest                                                |                                                |
| Volumes:                                                                |                                                |
| =>/var/run/docker.sock:/var/run/docker.sock                             |                                                |
| =>./active-notification/conf.yml:/app/conf.yml                          |                                                |
| Networks:                                                               |                                                |
| =>internal                                                              |                                                |
| Labels:                                                                 |                                                |
| =>traefik.enable=false                                                  |                                                |
+-------------------------------------------------------------------------+------------------------------------------------+
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

### Owncloud
- Filesharing Dienst wird bereitgestellt.
- Über HTTP und HTTPS erreichbar.
- Reverse Proxy eingerichtet.

### Cadvisor
- Monitoring der Container mit CPU-Last, RAM, etc.

### Active Notification
- Bei Erstellung eines Containers werden Nachrichten geschickt.
- Auch bei Zerstörung eines Containers, usw.
- Nachrichten werden an Discord Server geschickt.