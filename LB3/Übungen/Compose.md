# Compose Übung 3

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/tree/master/docker/compose) <br>
Alles hat super geklappt, ausser der letzte. Diesen musste ich umschreiben. Da ich Windows nutze, muss ich am Anfang vom Befehl "winpty" eingeben.

## Anleitung

1. ```cd /docker/compose```
2. ```docker-compose up -d```
3. ```winpty docker exec -it compose_mysql_1 bash```
4. ```ps -ef```
5. ```netstat -tulpen```
6. ```ping compose_apache_1```
7. ```exit```
8. ```winpty docker exec -it compose_mysql_1 mysql -uroot -pS3cr3tp4ssw0rd```
9. ```CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';```
10. ```GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';```
11. ```FLUSH PRIVILEGES;```
12. ```mysql -uroot -padmin -h127.0.0.1```
```
$ winpty docker exec -it compose_mysql_1 mysql -uadmin -padmin -h127.0.0.1
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.5.62-0ubuntu0.14.04.1 (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> exit
Bye
```
## Probleme
Ich musste ein paar Befehle anpassen. Aus ```docker exec``` wurde ```winpty docker exec```. aus ```winpty docker exec -it mysql mysql -uroot -pS3cr3tp4ssw0rd``` wurde ```winpty docker exec -it compose_mysql_1 mysql -uroot -pS3cr3tp4ssw0rd``` und aus ```CREATE USER 'root'@'%' IDENTIFIED BY 'admin';``` wurde ```CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';```. <br>