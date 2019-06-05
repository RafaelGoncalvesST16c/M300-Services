# Apache4X Übung 2

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/blob/master/docker/apache4X/mm.sh) <br>
Ich konnte die Übung nach mehreren Versuchen erfolgreich abschliessen.

## Anleitung

1. ```cd /docker/apache4X```
2. ```./mm.sh```
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                     NAMES
58f962a85adf        apache              "/bin/sh -c '/bin/ba…"   2 minutes ago       Up 2 minutes        0.0.0.0:32771->80/tcp     apache_web04
764cb5a98781        apache              "/bin/sh -c '/bin/ba…"   2 minutes ago       Up 2 minutes        0.0.0.0:32770->80/tcp     apache_web03
cba37bb1c068        apache              "/bin/sh -c '/bin/ba…"   2 minutes ago       Up 2 minutes        0.0.0.0:32769->80/tcp     apache_web02
a1154ceb97c1        apache              "/bin/sh -c '/bin/ba…"   2 minutes ago       Up 2 minutes        0.0.0.0:32768->80/tcp     apache_web01
ac76dad71586        microservice        "/bin/sh -c 'nodejs …"   8 minutes ago       Up 8 minutes        0.0.0.0:32761->8081/tcp   microservice2
14a0fe501d9d        microservice        "/bin/sh -c 'nodejs …"   8 minutes ago       Up 8 minutes        0.0.0.0:32760->8081/tcp   microservice1

```

## Probleme
Diese Übung hat mir am meisten Zeit gekostet, da ich hier das Shell Script genauer anpassen musste. Git Bash bzw. das Shell Script hat immer ein Problem mit dem File Path.