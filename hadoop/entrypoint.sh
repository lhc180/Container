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
IP=`ip addr show dev eth0|grep inet|awk '{print $2}'|awk -F'/' '{print $1}'`

sed -i "s@\(^export JAVA_HOME=\).*@\1$JAVA_HOME@g" $HADOOP_HOME/etc/hadoop/hadoop-env.sh
sed -i "s@hadoop-master@$IP@g" $HADOOP_HOME/etc/hadoop/core-site.xml
sed -i "s@hadoop-master@$IP@g" $HADOOP_HOME/etc/hadoop/yarn-site.xml
echo "$IP" >>$HADOOP_HOME/etc/hadoop/slaves


case $1 in
	"namenode")
		echo "yarn & namenode"
		if [ ! -d /hdfs/namenode/current ];then
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop namenode -format
			$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop resourcemanager &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop namenode 
		else
			$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop resourcemanager &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop namenode  
		fi
		;;
	"datanode")
		echo "datanode"
			$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop nodemanager &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop datanode  
		;;
	*)
		echo "hehe"
esac

