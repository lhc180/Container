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
file_env "ZKURL" "127.0.0.1:2181"
file_env "ID" "0"
file_env "KAFKA_PORT" "9092"


case "$1" in
	"standalone")
		$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties &
		sleep 3
		$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
		;;
	"cluster")
		sed -i -e "s@#listeners=PLAINTEXT://:9092@listeners=PLAINTEXT://:$KAFKA_PORT@g" -e "s@\(^broker.id=\).*@\1$ID@g" -e "s@\(^zookeeper.connect=\).*@\1$ZKURL@g" $KAFKA_HOME/config/server.properties
		$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
		;;
	"shell")
		/bin/bash
		;;
	*)
		echo "Usage: $@ [master|worker]"
esac
