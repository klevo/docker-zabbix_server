FROM dockerfile/ubuntu

# TODO: this image can be flattened to save on aufs layers: http://3ofcoins.net/2013/09/22/flat-docker-images/

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