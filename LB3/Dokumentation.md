# Lerndokumentation der LB3

## Containerisierung mit Docker
Containerisierung ist heutzutage in grossen Firmen nicht wegzudenken. Statt mühsam VMs zu erstellen, welche eine Ewigkeit brauchen zu starten, benutzen Firmen Container, welche im Bruchteiler einer Sekunde aufstarten. Container sind keine VM, sondern ein Prozess, welcher im Hintergrund geöffnet wird. Deswegen funktionieren sie bei jedem Betriebssystem, egal ob Windows, Linux oder Mac OS X. Man kann mittels Dockerfile oder Docker-Compose die Container erstellen. Ich habe in meiner LB3 Docker-Compose verwendet.
Docker kennt viele Befehle. Die wichtigsten wären folgende:
| Befehl               | Bedeutung     |
| --------------------- | --------------- |
| docker exec          | Führt einen Befehl in einem Container aus |
| docker images        | Listet alle heruntergeladenen Images auf | 
| docker logs          | Zeigt Logs eines Containers     |
| docker network       | Zeigt alle erstellten Netzwerke an |
| docker ps            | Listet alle Container auf |
| docker rm            | Entfernen eine Container |
| docker volume        | Listet alle erstellten Volumes auf |
| docker-compose up    | Führt das docker-compose.y(a)ml File aus |
| docker-compose up -d | Führt das docker-compose.y(a)ml File detached aus, also es läuft im Hintergrund |

## Microservices
Microservices führen Applikationen/Services aus. Eine Webseite wie beispielsweise Google verfügt über mehrere Seiten. Login Seite, Suchmaschine, Kalender, etc. Mit Microservices wird für jede Seite ein Container gestartet. Wenn ein User eine Suche in Google macht, wird ein Microservice gestartet, der die Suche ausführt. Nachdem die Suche beendet ist, wird der Container wieder heruntergefahren. Auch wenn eine Seite plötzlich eine grosse Last hat, kann ein zweiter Microservice aufgestart werden, welcher die Hälfte der Last nimmt. Dies wird mit einem Load Balancer gemacht. Dieser sorgt dafür, dass beide Microservices ungefähr gleich viele User haben.

## Voraussetzungen
Folgende Voraussetzungen müssen vorhanden sein, damit die Container funktionieren:

### Host File
```
192.168.60.101	test.ch
192.168.60.101	wordpress.test.ch
192.168.60.101	owncloud.test.ch
192.168.60.101  localhost
```

### Netzwerk erstellen
```
docker network create proxy
```

### Container starten
Nun können die Container gestartet werden.
```
docker-compose up -d
```

## Volumes
Volumes sind ähnlich wie synced Folders bei Vagrant. Jedoch besteht ein grosser Unterschied. Vagrant synchronisiert die Files bei der VM (Guest) zu einem Pfad beim Host System. Bei Docker Volumes ist dem nicht so. Hier werden Dateien an einen bestimmten Ort gespeichert. Das Volume "/home/vagrant/wordpress:/var/www/html/wordpress" speichert die Dateien, die bei /var/www/html/wordpress sind unter /home/vagrant/wordpress. Dadurch gehen die Dateien auch beim Löschen eines Containers nicht verloren. Man nennt das "Persistent Data".

## Networks
Man kann mehrere Netzwerke erstellen, damit Container entweder miteinander reden können oder eben nicht. Standardmässig dürfen alle Container miteinander reden, was nicht sicher ist. Deswegen sollte man mehrere Netzwerke erstellen und diese grenzen die Container voneinander aus.

## Sicherheitsaspekte

### Reverse Proxy
Der Reverse Proxy, denn ich benutze, ist Traefik. Dieser sorgt dafür, dass alle Anfragen zu Webserver, Filserver über den Rerverse Proxy gehen. Die externen Besucher wissen nicht, dass eigentlich ein Reverse Proxy die Anfrage an einen Webserver weiterleitet. Ein Vorteil von Traefik ist der, dass nicht wie beim Apache Reverse Proxy immer manuell im Config File ein Eintrag erstellt werden muss. Man erstellt mit wenigen Zeilen bei jedem Container die Verknüpfung zum Traefik Reverse Proxy. Mit sogenannte Labels macht man dies. Hier ein Beispiel:
```
   - "traefik.backend=wordpress"
   - "traefik.enable=true"
   - "traefik.frontend.rule=Host:wordpress.test.ch"
   - "traefik.port=80"
   - "traefik.docker.network=proxy"
```
Diese Zeilen sagen folgendes aus:
- Auf dem Webinterface von Traefik heisst der Eintrag von Wordpress "wordpress".
- Traefik ist eingeschaltet auf diesem Container, also wird Traefik diesen Container verstecken.
- WordPress ist über wordpress.test.ch erreichbar.
- Traefik leitet anfragen, die er über Port 80 kriegt, an WordPress weiter.
- Das Netzwerk, welches verwendet wird, ist proxy.
Man muss ein bestimmtes File erstellen, damit Traefik funktioniert, und zwar das traefik.toml File. Folgendermassen sieht mein File aus:
```
logLevel = "INFO"
  defaultEntryPoints = ["http","https"]

[web]
  address = ":8080"

[entryPoints]
    [entryPoints.http]
    address = ":80"
      [entryPoints.http.redirect]
      entryPoint = "https"
    [entryPoints.https]
    address = ":443"
      [entryPoints.https.tls]
        [[entryPoints.https.tls.certificates]]
        certFile = "/vagrant/M300-Services/LB3/Dockerconfig/traefik/Certs/test.ch.crt"
        keyFile = "/vagrant/M300-Services/LB3/Dockerconfig/traefik/Certs/test.ch.key"

[docker]
  endpoint = "unix:///var/run/docker.sock"
  domain = "test.ch"
  watch = true
  exposedbydefault = false

InsecureSkipVerify = true
```
Hier gebe ich die Domäne an ```Test.ch``` und deswegen muss ich im Hostfile Test.ch an die richtige IP weiterleiten. Ausserdem wird HTTP auf HTTPS weitergeleitet und die SSL Zertifikate gebe ich auch noch an.
![WordPress wird auf HTTPS weitergeleitet](https://github.com/RafaelGoncalvesST16c/M300-Services/blob/master/LB3/Images/Wordpress.png "WordPress wird auf HTTPS weitergeleitet")

### Container Ressourcen begrenzen
Damit ein Container nicht endlos viel CPU und RAM verwendet, wird der Zugriff eingeschränkt. Die Container können den angegebenen Wert nicht überschreiten. Standardmässig würde jeder Container unendlich viel brauchen dürfen. Mit folgendem Befehl wird eine Limitation gesetzt:
```
  deploy:
   resources:
    limits:
     cpus: "0.25"
     memory: 256M
```

### Container nicht immer neustarten
Normalerweise nutzt man immer den Befehl ```restart: always```. Dieser sorgt dafür, dass ein Container immer wieder aufgestartet wird, wenn man ihn herunterfährt. Dies ist aber nicht von Vorteil, wenn der Container wegen DDoS down ist. Deswegen benutze ich ```restart: on-failure```, welcher dafür sorgt, dass der Container nur bei Fehlern neustartet, also wenn bspw. der Container nicht genug CPU hatte.

## Monitoring
Ich benutze Cadvisor für mein Monitoring. Es zeigt mir die allgemeine Last an und auch von jedem Container seine Last. Hier wäre ein Beispiel von Owncloud:
![Owncloud in Cadvisor](https://github.com/RafaelGoncalvesST16c/M300-Services/blob/master/LB3/Images/Cadvisor.png "Owncloud in Cadvisor")
Man sieht:
- Den CPU Verbrauch 
- Den RAM Verbrauch
- Laufende Prozesse
- Netzwerkauslastung
- Fehler
- Wie viel vom Filesystem verbraucht wird

## Active Notification
Damit ich immer einen Benachrichtigung bekomme, wenn ein Container gestartet wird, zerstört, etc. habe ich ein active Monitoring eingerichtet. Dieser schickt mir eine Discord Nachricht, wenn eine Bedingung erfüllt wird. Hier ein Beispiel:
![Discord Benachrichtigung](https://github.com/RafaelGoncalvesST16c/M300-Services/blob/master/LB3/Images/Discord.png "Discord Benachrichtigung")