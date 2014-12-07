FROM dockerfile/ubuntu

# https://www.zabbix.com/documentation/2.4/manual/installation/install_from_packages
RUN wget http://repo.zabbix.com/zabbix/2.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.4-1+trusty_all.deb
RUN dpkg -i zabbix-release_2.4-1+trusty_all.deb
RUN apt-get update

RUN apt-get install -y zabbix-server-mysql

# Add server config and restart the server
ADD zabbix_server.conf /etc/zabbix/zabbix_server.conf
RUN /etc/init.d/zabbix_server restart

# Expose Zabbix service ports
EXPOSE 10051 10052

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts"]

ADD run_zabbix /run_zabbix
CMD ["/run_zabbix"]