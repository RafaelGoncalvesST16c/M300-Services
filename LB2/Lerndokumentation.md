# Lerndokumentation

## Linux
Da ich mich mit Linux sehr gut auskenne, war es kinderleicht die VMs zu erstellen und konfigurieren. Die meisten Services hatte ich schon einmal eingerichtet. Vor allem den Apache Webserver hatte ich schon in sehr vielen Modulen eingrichten müssen und deswegen fiel es mir nicht schwer ihn zu zu konfigurieren. Deswegen habe ich alles mit Linux erledigt und nicht mit Windows.

## Virtualisierung
Virtualisierung habe ich in der Schule, in den ÜKs und im Geschäft schon oft angetroffen. An sich wird einfach eine Virtualbox VM im Hintergrund erstellt und auf dieser werden dann die Befehle in den Bash Scripts (*.sh) ausgeführt.

## Vagrant
Am Anfang hatte ich Vagrant gar nicht verstanden, jedoch habe ich mit der Zeit es immer besser verstanden. Zuerst hatte ich meine ganze Automatisierung in einem einzigen Vagrant File gemacht, jedoch habe ich gemerkt, dass erstens die Datei ziemlich lang sein würde, zweitens es mit der Zeit sehr unübersichtlich wird und drittens es nicht sicher wäre alle Services (DB, Web, DNS, CA) auf einem einzigen Server laufen zu lassen.

## Versionsverwaltung mit Git
Git ist recht interessant von der Versionverwaltung her. Github merkt sich jede Änderung, die gepusht wurde (Commits) und man kann im nachhinein immer darauf zugreifen. Falls ich merke, dass ein Commit von vor einer Woche einen Fehler ausgelöst hat, kann ich einfach schauen was vor einer Woche alles geändert wurde beim Commit. Es ist auch sehr praktisch, dass ich nicht selber immer die Files hochladen muss per Hand, sondern einfach mit dem Befehl "git push". Auch ist git noch recht sicher, da es über das Public und Private Key Verfahren funktioniert. Github hat denn Public Key und ich als Benutzer habe den Private Key. Dieser wird dann noch mit einem Passwort geschützt. Falls also jemand mal meinen Private Key hat, muss er auch noch das Passwort herausfinden.

## Mark Down
Mark Down wird beispielsweise zum Dokumentieren verwendet. Dieser Text hier ist mit Mark Down geschrieben und formatiert worden. Mark Down funktioniert ähnlich wie HTML/CSS. Man hat Header (h1 HTML, # Mark Down), Unordered Lists (ul li HTML, -*+ und weitere Sonderzeichen Mark Down), Ordered Lists (ol li HTML, 1. 2. 3. Mark Down). Zu Mark Down gibt es auch tonnenweise Cheat Sheets mit allen Formatierungsmöglichkeiten, da man sich nicht alle merken kann.

## Systemsicherheit
Heutzutage ist Sicherheit ein sehr wichtiges Thema und es wird immer wichtiger und wichtiger. Angreifer werden immer schlauer und wenden immer bessere Angriffe an. Deswegen ist es für den Systemadministrator wichtig sein System zu schützen, damit dies nicht in fremde Hände gelangen kann. Aus diesem Grund habe ich bei jeder meiner Maschine eine UFW Firewall (Uncomplicated FireWall) konfiguriert. Da jede Maschine andere Services verfügt mit anderen Ports, muss ich für jede Maschine eigene Rules erstellen. Auch habe ich das Logging aktiviert und auf high gesetzt für eine ausführliche Protokollierung der Firewall Aktivität.

### Firewall Log Auszug vom Datenbankserver

```
May 24 09:05:39 ubuntu-xenial kernel: [ 1338.966334] [UFW ALLOW] IN= OUT=enp0s3 SRC=10.0.2.15 DST=172.217.168.67 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=48571 DF PROTO=ICMP TYPE=8 CODE=0 ID=4284 SEQ=1
```
Erklärung dieser Meldung: <br>
- ```May 24 09:05:39``` Datum als die Firewall diese Anfrage erhalten hat. <br>
- ```ubuntu-xenial``` Hostname vom Server <br>
- ```1338.966334``` Uptime vom Server (seit Boot) in Sekunden. <br>
- ```UFW ALLOW``` Wurde die Anfrage erlaubt oder geblockt. Diese wurde erlaubt. <br>
- ```IN``` Wenn ein Wert vorhanden ist, heisst es, dass die Anfrage incoming ist. Jemand schickt die Anfrage auf den Datenbankserver. Da es leer ist, heisst es, dass dies nicht incoming war. <br>
- ```OUT``` Wenn ein Wert vorhanden ist, heisst es, dass die Anfrage outgoing ist. Der Datenbankserver schickt eine Anfrage nach aussen. In unserem Fall wurde über das Interface enp0s3 eine Anfrage nach aussen geschickt. <br>
- ```SRC``` Source IP, die die Anfrage gesendet hat. In diesem Fall ist es 10.0.2.15, also die IP vom enp0s3 Interface. <br>
- ```DST``` Destination IP, die die Anfrage erhält. In diesem Fall ist es 172.217.168.67, eine IP von Google. <br>
- ```LEN``` Packet Länge in Bytes. <br>
- ```TOS``` Ehemals Type of Service. Ein Oktett im IPv4 header. Heute wird es Differentiated Services Code Point genannt. Kann verwendet werden für QoS (=Quality of Service) Zwecke. <br>
- ```PREC``` Wird Precedence genannt und ist auch im IPv4 Header enthalten. Das ist aber veraltet und es wurde verwendet, um einem Packete eine höhere Priorität zu geben als einem anderen Packet. Falls Packete gedroppt werden müssen, wird zuerst das mit der tiefsten Priorität gedroppt. <br>
- ```TTL``` TTL steht für Time To Live. Dieser Wert sagt durch wie viele Router das Packet noch bouncen kann. Bei jedem Router wird TTL um 1 kleiner. Falls TTL 0 ist, wird das Packet gedroppt. Dies wurde gemacht, damit Packete die ihr Ziel im Netzwerk nicht finden nicht permanent umherschwirren. TTL ist in unserem Fall 64, also kann das Packet noch durch 64 Router bouncen. <br>
- ```ID``` Eine Unique ID. Jeder Eintrag im Log hat eine eigene ID. <br>
- ```PROTO``` Protokoll, welches verwendet wurde. In unserem Fall ICMP. Normalerweise steht hier sonst UDP oder TCP. <br>
- ```TYPE``` Hängt damit zusammen, dass das ICMP Protokoll verwendet wurde. Der Typ (hier Typ 8) sagt uns genauer was genau von der ICMP Familie benutzt wurde. Typ 8 ist Ping, also wissen wir, dass ein Ping gemacht wurde (bzw. Echo). <br>
- ```SEQ``` Sequenznummer vom Ping. Dies war der erste Ping, also ist die Sequenz Nummer 1. 

Was sagt uns dieser Eintrag? Es wurde ein Ping abgesetzt vom Datenbankserver auf Google und dieser wurde erlaubt.

Hier noch einmal ein Beispiel, aber dieses schauen wir uns nicht im Detail an:
```
May 24 08:51:57 ubuntu-xenial kernel: [  517.503766] [UFW BLOCK] IN=enp0s8 OUT= MAC=08:00:27:96:4d:75:08:00:27:9b:3e:17:08:00 SRC=10.0.0.50 DST=10.0.0.11 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=52474 DF PROTO=TCP SPT=34522 DPT=3306 WINDOW=29200 RES=0x00 SYN URGP=0
```
- ```Datum May 24 08:51:57``` <br>
- ```Hostname ubuntu-xenial``` <br>
- ```Uptime 517.503766``` <br>
- ```UFW BLOCK``` <br>
- ```IN=enp0s8``` <br>
- ```OUT=``` <br>
- ```MAC=08:00:27:96:4d:75:08:00:27:9b:3e:17:08:00``` (Dieses Feld ist ein Mix aus Destination MAC, source MAC und dem EtherType (2 Oktett Feld in einem Ethernet Frame) <br>
- ```SRC IP = 10.0.0.50``` <br>
- ```DST IP = 10.0.0.11``` <br>
- ```LEN = 60``` <br>
- ```TTL = 64``` <br>
- ```PROTO = TCP``` <br>
- ```SPT = 34522``` (Dies ist der Source Port) <br>
- ```DPT = 3306``` (Dies ist der Destination Port) <br>
- ```WINDOW = 29200``` (Dies zeigt die Grösse vom Packet in Bytes an, die der Sender erhalten kann) <br>
- ```RES = 0x00``` (Dies ist ein Bit, welches für zuküntige Zwecke reserviert ist und immer 0 als Wert hat) <br>
- ```SYN URGP = 0``` (Dieses Feld zeigt einem an, dass ein Threeway handshake gemacht wird, da das Protokoll TCP ist. URGP sagt, ob das Urgend Pointer Feld relevant ist. Es ist 0, also ist es nicht relevant) <br>

Was sagt uns dieser Eintrag? Der Client hat versucht sich mit der MySQL Datenbank remote zu verbinden, aber dies wurde verweigert.

### Erstellte Firewallregeln

#### Web
- Allow 80/tcp (HTTP auf die Webseite)
- Allow from 10.0.2.2 to any port 22 (SSH vom Host aus)
- Allow 443/tcp (HTTPS auf die Webseite)

#### Database
- Allow from 10.0.2.2 to any port 22 (SSH vom Host aus)
- Allow from 10.0.0.12 to any port 3306 (Verbindung zur Datenbank vom Webserver aus)

#### CA
- Allow from 10.0.2.2 to any port 22 (SSH vom Host aus)

#### DNS
- Allow from 10.0.2.2 to any port 22 (SSH vom Host aus)
- Allow 53/tcp (DNS Port öffnen mit dem Protokoll TCP)
- Allow 53/udp (DNS Port öffnen mit dem Protokoll UDP)

#### Client
- Allow from 10.0.2.2 to any port 22 (SSH vom Host aus)

#### ExtClient
- Allow from 10.0.2.2 to any port 22 (SSH vom Host aus)