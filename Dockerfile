FROM dockerfile/ubuntu

# TODO: http://serverfault.com/questions/440285/why-does-snmp-fail-to-use-its-own-mibs
#       apt-get install snmp snmp-mibs-downloader
# TODO: http://stackoverflow.com/questions/26215021/configure-sendmail-inside-a-docker-container

# install required packages
RUN apt-get update && \
  
  # zabbix dependencies
  apt-get install -y build-essential adduser fping libc6 libcurl3-gnutls libiksemel3 libldap-2.4-2 libmysqlclient18 libmysqlclient-dev libodbc1 libopenipmi0 libsnmp30 libssh2-1 libxml2 lsb-base sysv-rc ucf libcurl3-dev libxml2-dev \
    
  # php-fpm & nginx
  php5-mysql php5-fpm php5-gd nginx

# download zabbix source & compile it
RUN wget -O zabbix-2.4.2.tar.gz http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/2.4.2/zabbix-2.4.2.tar.gz/download && \
    
  # compilation
  tar -zxvf zabbix-2.4.2.tar.gz && \
  cd zabbix-2.4.2 && \
  ./configure --prefix=/opt/zabbix --enable-server --with-mysql --enable-ipv6 --with-libcurl --with-libxml2 && \
  make install
  
  # set up zabbix user and required dirs  
RUN groupadd zabbix && \
  useradd -g zabbix zabbix && \
  mkdir -p /var/run/zabbix && \
  chown -R zabbix:zabbix /var/run/zabbix && \
  mkdir -p /var/log/zabbix && \
  chown -R zabbix:zabbix /var/log/zabbix && \
    
  # deploy the frontend files
  mv /root/zabbix-2.4.2/frontends/php /srv/zabbix && \
  chown -R www-data:www-data /srv/zabbix
  
# server can now be run: /opt/zabbix/sbin/zabbix_server

# Add server config
ADD zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf
ADD php-fpm/www.conf /etc/php5/fpm/php-fpm.conf
ADD nginx/zabbix.conf /etc/nginx/sites-available/default

# Expose Zabbix services ports & nginx
EXPOSE 10051 10052 80

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts"]

ADD run_zabbix /run_zabbix
CMD ["/run_zabbix"]