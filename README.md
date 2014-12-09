# Zabbix Server Dockerfile

Requirement: running mysql container that exposes port 3306.

```
docker run -d --name zabbix_server \
  --link mysql:mysql \
  -p 8081:80 \
  -e ZABBIX_DB_NAME=zabbix \
  -e ZABBIX_DB_USER=root \
  -e ZABBIX_DB_PASSWORD=mypass \
  klevo/zabbix_server
```

To inspect the running mysql container:

```
docker exec -i -t mysql /bin/bash
```