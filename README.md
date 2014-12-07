# Zabbix Server Dockerfile

Requirement: running mysql container that exposes port 3306.

```
docker run -d --name zabbix_server --link mysql:mysql klevo/zabbix_server
```

To inspect the running mysql container:

```
docker exec -i -t mysql /bin/bash
```