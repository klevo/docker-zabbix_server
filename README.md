# Zabbix Server Dockerfile

### Requirements

Requirement is a running [mysql container](https://registry.hub.docker.com/u/dockerfile/percona) that exposes port 3306. This mysql container needs to be linked as `mysql`. Zabbix container uses this hostname to connect.

Optionally, you can link a [postfix relay container](https://registry.hub.docker.com/u/klevo/postfix_mandrill), so that zabbix can send emails utilizing `sendmail`.

### Example usage

```
docker run -d --name zabbix_server \
  --link mysql:mysql \
  --link postfix_mandrill:postfix_relay \
  -p 8081:80 \
  -e ZABBIX_DB_NAME=zabbix \
  -e ZABBIX_DB_USER=root \
  -e ZABBIX_DB_PASSWORD=mypass \
  klevo/zabbix_server
```

To inspect the running container:

```
docker exec -i -t zabbix_server /bin/bash
```

### Web frontend included

This container exposes port 80 which serves the zabbix frontend served by nginx and php-fpm. I decided against splitting this responsibility into multiple containers as the frontend is closely related to the version of the server and build from the same source. So keeping separate containers, which might be updated/build independently would add unnecessary work.

### Limitations

There is no initialization of the zabbix database currently.