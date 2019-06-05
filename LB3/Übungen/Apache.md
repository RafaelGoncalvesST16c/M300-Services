# Apache Übung 1

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/tree/master/docker/apache) <br>
Das meiste lief problemlos, jedoch hatte ein Befehl immer einen Fehler und diesen konnte ich durch Internetrecherche beheben.

## Anleitung

1. ```cd /docker/apache```
2. ```docker build -t apache .```
3. ```docker run --rm -d -p 8080:80 -v /`pwd`/web:/var/www/html --name apache apache```
4. ```curl http://localhost:8080```
5. Inhalt von web/index.html anpassen.
6. ```curl http://localhost:8080```

```
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Apache in Docker, nachdem ich es angepasst habe.</title>
</head>
<body>
<h1>Apache in Docker</h1>
</body>
</html>
```

## Probleme
Der Befehl ```docker run --rm -d -p 8080:80 -v `pwd`/web:/var/www/html --name apache apache``` ging bei mir nicht. Ich musste vor "pwd" ein "/" setzen. <br>
Mit dem Befehl ging es: ```docker run --rm -d -p 8080:80 -v /`pwd`/web:/var/www/html --name apache apache```