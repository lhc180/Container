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
file_env "RESOURCEMANAGER_ADDR" "127.0.0.1"
file_env "NAMENODE_NAME" "namenode01"
IP=`ip addr show dev eth0|grep inet|awk '{print $2}'|awk -F'/' '{print $1}'`




case $1 in
	"resourcemanager")
		sed -i "s@hadoop-master@$IP@g" $HADOOP_HOME/etc/hadoop/yarn-site.xml
		$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop resourcemanager 
		;;
	"namenode")
		sed -i "s@\(^export JAVA_HOME=\).*@\1$JAVA_HOME@g" $HADOOP_HOME/etc/hadoop/hadoop-env.sh
		sed -i -e "s@hadoop-master@$IP@g" $HADOOP_HOME/etc/hadoop/core-site.xml
		sed -i -e "s@namenode01@$IP@g" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
		sed -i "s@hadoop-master@$RESOURCEMANAGER_ADDR@g" $HADOOP_HOME/etc/hadoop/yarn-site.xml

		if [ ! -d /hdfs/namenode/current ];then
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop namenode -format
			$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop nodemanager  &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop namenode 
		else
			$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop nodemanager  &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop namenode  
		fi
		;;
	"datanode")
		if [ -f /opt/hadoop-2.7.7/etc/hadoop/core-site.xml ];then
			file_env NAMENODE_IP `cat /opt/hadoop-2.7.7/etc/hadoop/core-site.xml |egrep -o "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"`
		fi
		echo "$NAMENODE_IP $NAMENODE_NAME" >>/etc/hosts

		$HADOOP_HOME/bin/yarn --config $HADOOP_HOME/etc/hadoop nodemanager  &
		$HADOOP_HOME/bin/hdfs --config $HADOOP_HOME/etc/hadoop datanode 
		;;
	"shell")
		/bin/bash
		;;
	*)
		echo "$@ [resourcemanager|namenode|datanode]"
esac

