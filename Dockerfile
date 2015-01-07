FROM dockerfile/ubuntu

ENV ZABBIX_VERSION 2.4.3

# install required packages
RUN apt-get update && \
  
  # zabbix dependencies
  apt-get install -y build-essential adduser fping libc6 libcurl3-gnutls libiksemel3 libldap-2.4-2 libmysqlclient18 libmysqlclient-dev libodbc1 libopenipmi0 libsnmp30 libssh2-1 libxml2 lsb-base sysv-rc ucf libcurl3-dev libxml2-dev \
    
  # php-fpm & nginx
  php5-mysql php5-fpm php5-gd nginx \
  
  # nullmailer for relaying emails from zabbix
  nullmailer

# download zabbix source & compile it
RUN wget -O zabbix.tar.gz http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/$ZABBIX_VERSION/zabbix-$ZABBIX_VERSION.tar.gz/download && \
    
  # compilation
  tar -zxvf zabbix.tar.gz && \
  cd zabbix-$ZABBIX_VERSION && \
  ./configure --prefix=/opt/zabbix --enable-server --enable-agent --with-mysql --enable-ipv6 --with-libcurl --with-libxml2 && \
  make install
  
# set up zabbix user and paths
RUN groupadd zabbix && \
  useradd -g zabbix zabbix && \
  mkdir -p /var/run/zabbix && \
  chown -R zabbix:zabbix /var/run/zabbix && \
  mkdir -p /var/log/zabbix && \
  chown -R zabbix:zabbix /var/log/zabbix && \
  mkdir -p /opt/zabbix/agent_include && \
  chown -R zabbix:zabbix /opt/zabbix/agent_include && \
    
  # deploy the frontend files
  mv /root/zabbix-$ZABBIX_VERSION/frontends/php /srv/zabbix && \
  chown -R www-data:www-data /srv/zabbix
  
# Zabbix server config
ADD zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf
ADD php-fpm/www.conf /etc/php5/fpm/php-fpm.conf
ADD nginx/zabbix.conf /etc/nginx/sites-available/default
ADD zabbix/frontend.conf.php /srv/zabbix/conf/zabbix.conf.php

# agent config
ADD zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

# configure nullmailer 
# http://opensourcehacker.com/2013/03/25/using-nullmailer-and-mandrill-for-your-ubuntu-linux-server-outboud-mail/
ADD nullmailer/remotes /etc/nullmailer/remotes
ADD scripts/init_nullmailer /init_nullmailer

# Expose Zabbix services ports & nginx
EXPOSE 10051 10052 80

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts"]

ADD scripts/run_zabbix /run_zabbix
CMD ["/run_zabbix"]