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
file_env "NAMENODE_HOSTNAME" "namenode01"
file_env "NAMENODE_ADDR" "127.0.0.1"
echo "$NAMENODE_ADDR $NAMENODE_HOSTNAME" >>/etc/hosts
IP=`ip addr show dev eth0|grep inet|awk '{print $2}'|awk -F'/' '{print $1}'`


case "$1" in
	"master")
		echo -e "JAVA_HOME=$JAVA_HOME\nSPARK_HOME=$SPARK_HOME\nSPARK_MASTER_HOST=$IP\nSPARK_WORKER_CORES=8\nSPARK_WORKER_MEMORY=8G\nSPARK_LOG_DIR=$SPARK_HOME/logs\n" >$SPARK_HOME/conf/spark-env.sh
		sed -i "s@\`hostname -f\`@$IP@g" $SPARK_HOME/sbin/start-master.sh
		$SPARK_HOME/sbin/spark-config.sh 
		$SPARK_HOME/sbin/start-master.sh 
		find $SPARK_HOME/logs -name "spark*.out"|xargs -I {} tail -f {}
		;;
	"worker")
		MASTER=`cat $SPARK_HOME/conf/spark-env.sh|grep SPARK_MASTER_HOST|awk -F'=' '{print $2}'`
		$SPARK_HOME/sbin/spark-config.sh 
		$SPARK_HOME/sbin/start-slave.sh spark://$MASTER:7077
		find $SPARK_HOME/logs -name "spark*.out"|xargs -I {} tail -f {}
		;;
	*)
		echo "Usage: $@ [master|worker]"
		bash
esac
