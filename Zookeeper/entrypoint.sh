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


file_env "HOSTNAME" `uname -n`
file_env "ID" "1"
file_env "ZOOKEEPER_HOME" "/opt/apache-zookeeper-3.5.6-bin"
IP=`ip addr show dev eth0|grep inet|awk '{print $2}'|awk -F'/' '{print $1}'`

if [ ! -d /zookeeper/data ];then
	mkdir -p /zookeeper/data
fi


echo "$ID" >/zookeeper/data/myid


$ZOOKEEPER_HOME/bin/zkServer.sh --config $ZOOKEEPER_HOME/conf start

find $ZOOKEEPER_HOME/logs -name "zookeeper*.out"|xargs -I {} tail -f {}
