#!/bin/bash


file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}


file_env "MYSQL_ADDR" "127.0.0.1"
file_env "MYSQL_PORT" 3306
file_env "MYSQL_USER" "root"
file_env "MYSQL_PASSWORD" "111111"
file_env "HOSTNAME" `uname -n`
file_env "HDFS_HOSTNAME" "hdfs01"
file_env "HDFS_ADDR" "127.0.0.1"

if [ ! -f $HIVE_HOME/conf/hive-log4j.properties ]
then
	echo "hive.log.dir=$HIVE_HOME/logs" >$HIVE_HOME/conf/hive-log4j.properties
fi

sed -i "s@mysql://localhost:3306@mysql://$MYSQL_ADDR:$MYSQL_PORT@g" $HIVE_HOME/conf/hive-site.xml
sed -i "s@root@$MYSQL_USER@g" $HIVE_HOME/conf/hive-site.xml
sed -i "s@123456@$MYSQL_PASSWORD@g" $HIVE_HOME/conf/hive-site.xml
sed -i "s@node03.kaikeba.com@$HOSTNAME@g" $HIVE_HOME/conf/hive-site.xml

echo "$HDFS_ADDR $HDFS_HOSTNAME" >>/etc/hosts


$HIVE_HOME/bin/schematool -initSchema -dbType mysql
$HIVE_HOME/bin/hive --service metastore &
$HIVE_HOME/bin/hive --service hiveserver2

