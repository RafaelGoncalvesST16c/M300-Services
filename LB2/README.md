### Übersicht über das System

```
+-----------------------------------------------------+
| Privates Netz - 10.0.0.0/24                         |
| Externes Netz - 192.168.0.0/24                      |
+-----------------------------------------------------+
| Webserver          |           | Datenbankserver    |
| Host: web01        |           | Host: db01         |
| IP: 10.0.0.12      | <---+---> | IP: 10.0.0.11      |
| Port: 80, 443      |     |     | Port: 3306         |
| NAT: 8080, 4343    |     |     | NAT: -             |
+--------------------+     |     +--------------------+
| CA Server          |     |     | DHCP-Server        |
| Host: ca01         |     |     | Host: dhcp01       |
| IP: 10.0.0.13      | <---+---> | IP: 10.0.0.10      |
| Port: -            |           | Port: -            |
| NAT: -             |           | NAT: -             |
+--------------------+           +--------------------+
| Client intern      |           | Client extern      |
| Host: client01     |           | Host: extclient01  |
| IP: 10.0.0.50-100  |           | IP: 40.0.0.50-100  |
| Port: -            |           | Port: -            |
| NAT: -             |           | NAT: -             |
+--------------------+-----------+--------------------+
```

Am Schluss stehen sechs VMs. Hier die Erklärung zu jeder einzelnen:

Webserver
