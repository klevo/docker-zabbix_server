FROM dockerfile/ubuntu

# TODO: http://serverfault.com/questions/440285/why-does-snmp-fail-to-use-its-own-mibs
#       apt-get install snmp snmp-mibs-downloader
# TODO: http://stackoverflow.com/questions/26215021/configure-sendmail-inside-a-docker-container
# TODO: add frontend with php-fpm and nginx

RUN wget -O zabbix-2.4.2.tar.gz http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/2.4.2/zabbix-2.4.2.tar.gz/download && \
  apt-get update && \
  
  # zabbix dependencies
  apt-get install -y build-essential adduser fping libc6 libcurl3-gnutls libiksemel3 libldap-2.4-2 libmysqlclient18 libmysqlclient-dev libodbc1 libopenipmi0 libsnmp30 libssh2-1 libxml2 lsb-base sysv-rc ucf net-snmp-config libcurl3-dev && \
    
  # compilation
  tar -zxvf zabbix-2.4.2.tar.gz && \
  cd zabbix-2.4.2 && \
  ./configure --prefix=/opt/zabbix --enable-server --with-mysql --enable-ipv6 --with-libcurl --with-libxml2 && \
  make install && \
    
  groupadd zabbix && \
  useradd -g zabbix zabbix && \
  mkdir -p /var/run/zabbix && \
  chown -R zabbix:zabbix /var/run/zabbix && \
  mkdir -p /var/log/zabbix && \
  chown -R zabbix:zabbix /var/log/zabbix
  
# server can now be run: /opt/zabbix/sbin/zabbix_server

# Add server config
ADD zabbix_server.conf /etc/zabbix/zabbix_server.conf

# Expose Zabbix services ports
EXPOSE 10051 10052

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts"]

ADD run_zabbix /run_zabbix
CMD ["/run_zabbix"]