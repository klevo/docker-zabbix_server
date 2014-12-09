<?php
// Zabbix GUI configuration file
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = 'MYSQL_PORT_3306_TCP_ADDR';
$DB['PORT']     = '3306';
$DB['DATABASE'] = 'ZABBIX_DB_NAME';
$DB['USER']     = 'ZABBIX_DB_USER';
$DB['PASSWORD'] = 'ZABBIX_DB_PASSWORD';

// SCHEMA is relevant only for IBM_DB2 database
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>