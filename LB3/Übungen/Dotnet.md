# Dotnet Übung 4

## Vorgehen
Ich habe die Anleitung vom Github befolgt. [Link dazu](https://github.com/mc-b/M300/tree/master/docker/dotnet) <br>
Alles hat geklappt.

## Anleitung

1. ```cd /docker/dotnet```
2. ```docker build -t dotnetapp .```
3. ```winpty docker run -it --rm dotnetapp```
4. ```dotnet out/dotnetapp.dll```
5. ```nano Program.cs```
6. "Hello World!" auf "Hallo Welt!" anpassen
7. ```dotnet run```
```
root@26ad56a08160:/dotnetapp# dotnet run
Hallo Welt!
```
## Probleme
Diese Übung verlief problemlos. Ich musste nur beim docker run -it Befehl noch "winpty" anhängen, aber das war es auch.