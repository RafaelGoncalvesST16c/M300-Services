# Lerndokumentation der LB3

## Containerisierung mit Docker
Containerisierung ist heutzutage in grossen Firmen nicht wegzudenken. Statt mühsam VMs zu erstellen, welche eine Ewigkeit brauchen zu starten, benutzen Firmen Container, welche im Bruchteiler einer Sekunde aufstarten. Container sind keine VM, sondern ein Prozess, welcher im Hintergrund geöffnet wird. Deswegen funktionieren sie bei jedem Betriebssystem, egal ob Windows, Linux oder Mac OS X. Man kann mittels Dockerfile oder Docker-Compose die Container erstellen. Ich habe in meiner LB3 Docker-Compose verwendet.
Docker kennt viele Befehle. Die wichtigsten wären folgende:
```
╔══════════════════════╦═════════════════════════════════════════════════════════════════════════════════╗
║ Befehl               ║ Bedeutung                                                                       ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker exec          ║ Führt einen Befehl in einem Container aus                                       ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docekr images        ║ Listet alle heruntergeladenen Images auf                                        ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker logs          ║ Zeigt Logs eines Containers                                                     ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker network       ║ Zeigt alle erstellten Netzwerke an                                              ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker ps            ║ Listet alle Container auf                                                       ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker rm            ║ Entfernen eine Container                                                        ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker volume        ║ Listet alle erstellten Volumes auf                                              ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker-compose up    ║ Führt das docker-compose.y(a)ml File aus                                        ║
╠══════════════════════╬═════════════════════════════════════════════════════════════════════════════════╣
║ docker-compose up -d ║ Führt das docker-compose.y(a)ml File detached aus, also es läuft im Hintergrund ║
╚══════════════════════╩═════════════════════════════════════════════════════════════════════════════════╝
```

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

## Schichtenmodell
Jedes Image hat eigene Schichten. Mit dem Befehl ```docker history [Image]:[Version]``` sieht man die Layer. Hier ein Beispiel von WordPress:5.2:
```
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
798e263bc14e        2 days ago          /bin/sh -c #(nop)  CMD ["apache2-foreground"]   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B
<missing>           2 days ago          /bin/sh -c #(nop) COPY file:2413d0c63f9d7b1d…   8.82kB
<missing>           2 days ago          /bin/sh -c set -ex;  curl -o wordpress.tar.g…   42.6MB
<missing>           2 days ago          /bin/sh -c #(nop)  ENV WORDPRESS_SHA1=3605bc…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV WORDPRESS_VERSION=5.2…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  VOLUME [/var/www/html]       0B
<missing>           2 days ago          /bin/sh -c a2enmod rewrite expires              60B
<missing>           2 days ago          /bin/sh -c {   echo 'error_reporting = 4339'…   214B
<missing>           2 days ago          /bin/sh -c {   echo 'opcache.memory_consumpt…   150B
<missing>           2 days ago          /bin/sh -c set -ex;   savedAptMark="$(apt-ma…   26MB
<missing>           2 days ago          /bin/sh -c #(nop)  CMD ["apache2-foreground"]   0B
<missing>           2 days ago          /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>           2 days ago          /bin/sh -c #(nop) WORKDIR /var/www/html         0B
<missing>           2 days ago          /bin/sh -c #(nop) COPY file:e3123fcb6566efa9…   1.35kB
<missing>           2 days ago          /bin/sh -c #(nop)  ENTRYPOINT ["docker-php-e…   0B
<missing>           2 days ago          /bin/sh -c docker-php-ext-enable sodium         20B
<missing>           2 days ago          /bin/sh -c #(nop) COPY multi:99e4ad617c61938…   6.51kB
<missing>           2 days ago          /bin/sh -c set -eux;   savedAptMark="$(apt-m…   57.9MB
<missing>           2 days ago          /bin/sh -c #(nop) COPY file:ce57c04b70896f77…   587B
<missing>           2 days ago          /bin/sh -c set -eux;   savedAptMark="$(apt-m…   13.3MB
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_SHA256=fefc8967da…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_URL=https://www.p…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_VERSION=7.3.6        0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV GPG_KEYS=CBAF69F173A0…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_LDFLAGS=-Wl,-O1 -…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_CPPFLAGS=-fstack-…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_CFLAGS=-fstack-pr…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_EXTRA_CONFIGURE_A…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_EXTRA_BUILD_DEPS=…   0B
<missing>           2 days ago          /bin/sh -c {   echo '<FilesMatch \.php$>';  …   237B
<missing>           2 days ago          /bin/sh -c a2dismod mpm_event && a2enmod mpm…   68B
<missing>           2 days ago          /bin/sh -c set -eux;  apt-get update;  apt-g…   42.3MB
<missing>           2 days ago          /bin/sh -c #(nop)  ENV APACHE_ENVVARS=/etc/a…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV APACHE_CONFDIR=/etc/a…   0B
<missing>           2 days ago          /bin/sh -c set -eux;  mkdir -p "$PHP_INI_DIR…   0B
<missing>           2 days ago          /bin/sh -c #(nop)  ENV PHP_INI_DIR=/usr/loca…   0B
<missing>           2 days ago          /bin/sh -c set -eux;  apt-get update;  apt-g…   209MB
<missing>           2 weeks ago         /bin/sh -c #(nop)  ENV PHPIZE_DEPS=autoconf …   0B
<missing>           2 weeks ago         /bin/sh -c set -eux;  {   echo 'Package: php…   46B
<missing>           2 weeks ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           2 weeks ago         /bin/sh -c #(nop) ADD file:5ffb798d64089418e…   55.3MB
```

## Testfälle
HTTP wird auf HTTPS weitergeleitet => Erfüllt
```
* Connected to wordpress.test.ch (192.168.60.101) port 80 (#0)
> GET / HTTP/1.1
> Host: wordpress.test.ch
> User-Agent: curl/7.64.0
> Accept: */*
>
< HTTP/1.1 302 Found
< Location: https://wordpress.test.ch:443/
< Date: Sun, 30 Jun 2019 18:53:03 GMT
< Content-Length: 5
< Content-Type: text/plain; charset=utf-8
```
wordpress.test.ch geht auf die WordPress Seite und owncloud.test.ch auf die Owncloud Seite.
Siehe curl Anfrage oben für WordPress. Die für Owncloud sieht folgendermassen aus:
```
* Connected to owncloud.test.ch (192.168.60.101) port 80 (#0)
> GET / HTTP/1.1
> Host: owncloud.test.ch
> User-Agent: curl/7.64.0
> Accept: */*
>
< HTTP/1.1 302 Found
< Location: https://owncloud.test.ch:443/
< Date: Sun, 30 Jun 2019 19:35:31 GMT
< Content-Length: 5
< Content-Type: text/plain; charset=utf-8
```
Nur die nötigen Ports sind offen.
```
Starting Nmap 7.01 ( https://nmap.org ) at 2019-06-30 19:47 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00010s latency).
Not shown: 993 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
443/tcp  open  https
3306/tcp open  mysql
8080/tcp open  http-proxy
8081/tcp open  blackice-icecap
```
Ports erklärt:
- 22 = SSH
- 80 = HTTP
- 443 = HTTPS
- 3306 = MySQL
- 8080 = Webinterface Traefik
- 8081 = Webinterface Cadvisor
Mir ist nicht ersichtlich warum 3306 offen ist. Ich selber kann den Port nicht benutzen und MySQL ist nicht einmal installiert.

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

## Container Vernetzung
Die Container sind untereinander unterschiedlich vernetzt. Dazu verwende ich die "internal" und "proxy" Netzwerke. Im "Proxy" Netzwerk sind alle Container drin, die den Reverse Proxy brauchen und mit diesem kommunizieren können. WordPress und Owncloud beispielsweise. Im "Internal" Netzwerk sind alle drin, die zwar untereinander kommunizieren müssen, jedoch ist der Reverse Proxy nicht in diesem drin. WordPress + WordPress DB und Owncloud + Owncloud DB sind beispielsweise im internal Netzwerk. Theoretisch könnte man noch ein internal Netzwerk für WordPress + Wordpress DB und ein internal Netz für Owncloud + Owncloud DB machen, aber ich habe nur die zwei erstellt, damit man den Überblick nicht verliert.

## Image-Bereitstellung
Statt fremde Images herunterzuladen, kann man auch eigene builden. Ich selber habe eins gebuildet und auf meine public Registry flamelybra/m300-repo hochgeladen. Ob das Image sinnvoll ist, darüber kann man sich streiten. Folgendermassen buildet man ein Image und ladet es danach hoch:
1. Das Image pullen (docker pull [Image])
2. Image starten (docker run [Image])
3. Image anpassen (Beispielsweise das Config File anpassen)
4. docker tag [Name vom Image]:[Tag] [Username]/[Reponame]
5. docker push [Username]/[Reponame]
Dafür muss man eingeloggt sein (docker login --username [Docker Hub User] --password [Docker Hub Password])
Nun kann man mit docker pull [Username]/[Reponame] das Image pullen.

## Continuous Integration
Unter Continuous Integration versteht man das stetige verbessern von Software oder Images. Dadurch benutzt man ein CI/CD fähiges Programm/Image wie bspw. Travis CI, Jenkins, etc. Es werden Tests ausgeführt und dadurch kann man dann sicherstellen, dass das Image funktioniert oder die Software. Ich habe Travis CI genommen. Man erstellt dafür einen Account auf der Webseite, verlinkt sein Github und erstellt dann ein .travis.yml File mit einer Config. Mit dieser wird dann getestet, ob die aufgeführten Befehle funktionieren oder nicht.

## Cloud Integration

## Kubernetes

Zuerst muss das Repository von Lernkube geclont werden.
git clone https://github.com/mc-b/lernkube
cd lernkube
cp templates/DUK.yaml config.yaml
vagrant plugin install vagrant-disksize
vagrant up
Über ```http://localhost:32188``` kann das Jupyter Webinterface geöffnet werden. Hier hat man mehrere *.ipynb Files mit Befehlen, die man starten kann. Als Beispiel nehmen wir "09-1-kubectl.ipynb". Auf diese drücken wir mit einem Linksklick drauf, damit es gestartet wird. Über ```http://192.168.137.100:32335/``` kann das Webinterface geöffnet werden und ein Bild erscheint mit dem Text "It works!". <br>
Möchte man einen Cluster bauen, muss folgendes getan werden:
1. cd Kubernetes/lernkube
2. vi config.yaml
3. Folgendermassen das File anpassen (in diesem Fall wäre es ein Worker):
Für Master Count = 1 und Worker = 0, für Master Count = 0 und Worker = 1. Ausserdem muss beim "Network_Type" auf "Public_Network" gewechselt werden. Ausserdem muss use_dhcp auf "True" gesetzt werden.
```
master:
  count: 0
  cpus: 2
  memory: 5120
worker:
  count: 1

use_dhcp: true  
# Fixe IP Adressen mit welchen die IP fuer Master und Worker beginnen sollen
ip:
  master:   192.168.137.100
  worker:   192.168.137.111
# Netzwerk "private_network" fuer Host-only Netzwerk, "public_network" fuer Bridged Netzwerke
net:
  network_type: public_network
```