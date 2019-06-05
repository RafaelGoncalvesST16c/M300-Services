# MySQL Übung 7

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/tree/master/docker/mysql) <br>
Die Übung verlief problemlos.
## Anleitung

1. ```cd /docker/mysql```
2. ```docker build -t mysql .```
3. ```docker run --rm -d --name mysql mysql```
4. ```winpty docker exec -it mysql bash```
5. ```ps -ef```
6. ```netstat -tulpen```
7. ```exit```
8. ```winpty docker exec -it mysql mysql -uroot -pS3cr3tp4ssw0rd```

```
$ winpty docker exec -it mysql mysql -uroot -pS3cr3tp4ssw0rd
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.5.62-0ubuntu0.14.04.1 (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
## Probleme
Ich hatte gar keine Probleme bei dieser Übung