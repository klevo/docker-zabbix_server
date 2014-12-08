FROM dockerfile/ubuntu

# TODO: this image can be flattened to save on aufs layers: http://3ofcoins.net/2013/09/22/flat-docker-images/
# TODO: http://serverfault.com/questions/440285/why-does-snmp-fail-to-use-its-own-mibs
#       apt-get install snmp snmp-mibs-downloader
# TODO: http://stackoverflow.com/questions/26215021/configure-sendmail-inside-a-docker-container
# TODO: install from source
# TODO: add frontend with php-fpm and nginx

# https://www.zabbix.com/documentation/2.4/manual/installation/install_from_packages
RUN wget http://repo.zabbix.com/zabbix/2.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.4-1+trusty_all.deb
RUN dpkg -i zabbix-release_2.4-1+trusty_all.deb
RUN apt-get update

RUN apt-get install debconf-utils
RUN echo zabbix-server-mysql zabbix-server-mysql/dbconfig-install false | debconf-set-selections

RUN groupadd zabbix
RUN useradd -g zabbix zabbix

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends zabbix-server-mysql

# Add server config
ADD zabbix_server.conf /etc/zabbix/zabbix_server.conf

# For some reason, the install above does not create the run dir
RUN mkdir -p /var/run/zabbix
RUN chown -R zabbix:zabbix /var/run/zabbix

# Expose Zabbix services ports
EXPOSE 10051 10052

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts"]

ADD run_zabbix /run_zabbix
CMD ["/run_zabbix"]