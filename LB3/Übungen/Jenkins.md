# Jenkins Übung 5

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/tree/master/docker/jenkins) <br>
Ich habe zwar die Anleitung befolgt, verstehe aber nicht ganz was nun am Ende stehen soll bzw. gehen muss.

## Anleitung

1. ```cd /docker/jenkins```
2. ```docker build -t jenkins .```
3. ```docker run -d --name jenkins -p 8082:8080 --rm-v  /"/var/run/docker.sock":/"/var/run/docker.sock" -v /"/vagrant":/"/vagrant" jenkins```
4. ```docker run --name for ubuntu:14.04 bash -c 'for x in 1 2 3 4 5; do echo $x; sleep 1; done;'```
5. ```docker logs for```
6. ```docker rm for```
7. ```cd /docker/apache```
8. ```docker build -t apache .```

## Probleme
Ich musste auch hier ein "/" vor den File Paths stellen, da sonst der Befehl nicht geht. Sonst hatte ich keine Fehler, auch wenn ich nicht verstehe was ich genau gemacht habe bzw. wie das Resultat aussehen sollte.