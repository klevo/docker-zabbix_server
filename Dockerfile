FROM dockerfile/ubuntu:14.04

wget http://repo.zabbix.com/zabbix/2.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.4-1+trusty_all.deb
dpkg -i zabbix-release_2.4-1+trusty_all.deb
apt-get update

ADD run_zabbix /run_zabbix
CMD ["/run_zabbix"]