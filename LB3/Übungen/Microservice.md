# Microservice Übung 6

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/tree/master/docker/microservice) <br>
Alles ging problemlos.

## Anleitung

1. ```cd /docker/microservice```
2. ```docker build -t microservice .```
3. ```docker run -d -p 32760:8081 --name microservice1 --rm microservice```
4. ```docker run -d -p 32761:8081 --name microservice2 --rm microservice```
5. ```curl localhost:32760```
6. ```curl localhost:32761```
```
$ curl localhost:32760
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    12    0    12    0     0   1500      0 --:--:-- --:--:-- --:--:--  1500Hello World
```
```
$ curl localhost:32761
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    12    0    12    0     0   1714      0 --:--:-- --:--:-- --:--:--  1714Hello World
```
## Probleme
Ich hatte gar keine Probleme. Alles lief problemlos.