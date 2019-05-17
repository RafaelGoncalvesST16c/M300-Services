### Übersicht über das System

```
+-----------------------------------------------------+
| Privates Netz - 10.0.0.0/24                         |
| Externes Netz - 192.168.0.0/24                      |
+-----------------------------------------------------+
| Webserver          |           | Datenbankserver    |
| Host: web01        |           | Host: db01         |
| IP: 10.0.0.11      | <---+---> | IP: 10.0.0.10      |
| Port: 80, 443      |     |     | Port: 3306         |
| NAT: 8080, 4343    |     |     | NAT: -             |
+--------------------+     |     +--------------------+
| CA Server          |     |     | DHCP-Server        |
| Host: ...          |     |     | Host: ...          |
| IP: ...            | <---+---> | IP: ...            |
| Port: ...          |           | Port: ...          |
| NAT: ...           |           | NAT: ...           |
+--------------------+           +--------------------+
| Client intern      |           | Client extern      |
| Host: ...          |           | Host: ...          |
| IP: 10.0.0.100-200 |           | IP: 40.0.0.100-200 |
| Port: ...          |           | Port: ...          |
| NAT: ...           |           | NAT: ...           |
+--------------------+-----------+--------------------+
```

Am Schluss stehen sechs VMs. Hier die Erklärung zu jeder einzelnen:

Webserver
