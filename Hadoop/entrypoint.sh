#!/bin/bash


#修改环境变量,抄自percona-server的Dockerfile。
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

file_env NAMENODE_HOSTNAME "namenode01"
file_env NAMENODE_IP "127.0.0.1"

function editHadoopEvn(){
	if [ -f $HADOOP_CONF_DIR/hadoop-env.sh ];then
		sed -i "s@\(^export JAVA_HOME=\).*@\1$JAVA_HOME@g" $HADOOP_CONF_DIR/hadoop-env.sh
	else
		echo "export JAVA_HOME=$JAVA_HOME" >$HADOOP_CONF_DIR/hadoop-env.sh
	fi
}

function editCoreSite(){
	if [ -f $HADOOP_CONF_DIR/core-site.xml ];then
		rm -f $HADOOP_CONF_DIR/core-site.xml
		cat >$HADOOP_CONF_DIR/core-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
     <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop-master:9000/</value>
    </property>
</configuration>
EOF
	else
		cat >$HADOOP_CONF_DIR/core-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
     <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop-master:9000/</value>
    </property>
</configuration>
EOF
	fi
}

function editHdfsSite(){
	if [ -f $HADOOP_CONF_DIR/hdfs-site.xml ];then
		rm -f $HADOOP_CONF_DIR/hdfs-site.xml
		cat >$HADOOP_CONF_DIR/hdfs-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.namenode.rpc-address.hdfs01.namenode01</name>
        <value>namenode01:8020</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.hdfs01.namenode01</name>
        <value>namenode01:50070</value>
    </property>

    <property>
        <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
        <value>false</value>
    </property>

    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///hdfs/namenode</value>
        <description>NameNode directory for namespace and transaction logs storage.</description>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///hdfs/datanode</value>
        <description>DataNode directory</description>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
</configuration>
EOF
	else
		cat >$HADOOP_CONF_DIR/hdfs-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.namenode.rpc-address.hdfs01.namenode01</name>
        <value>namenode01:8020</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.hdfs01.namenode01</name>
        <value>namenode01:50070</value>
    </property>

    <property>
        <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
        <value>false</value>
    </property>

    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///hdfs/namenode</value>
        <description>NameNode directory for namespace and transaction logs storage.</description>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///hdfs/datanode</value>
        <description>DataNode directory</description>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
</configuration>
EOF
	fi
}

function editMapRed(){
	if [ -f $HADOOP_CONF_DIR/mapred-site.xml ];then
		rm -f $HADOOP_CONF_DIR/mapred-site.xml
		cat >$HADOOP_CONF_DIR/mapred-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOF
	else
		cat >$HADOOP_CONF_DIR/mapred-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOF

	fi
}

function editYarnSite(){
	if [ -f $HADOOP_CONF_DIR/yarn-site.xml ];then
		rm -f $HADOOP_CONF_DIR/yarn-site.xml
		cat >$HADOOP_CONF_DIR/yarn-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.pmem-check-enabled</name>
        <value>false</value>
    </property>
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop-master</value>
    </property>
</configuration>
EOF
	else
		cat >$HADOOP_CONF_DIR/yarn-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop-master</value>
    </property>
    <property>
        <name>yarn.resourcemanager.am.max-attempts</name>
        <value>4</value>
    </property>
</configuration>
EOF

	fi
}

case $1 in
	"namenode")
		#生成配置文件
		editHadoopEvn
		editCoreSite
		editHdfsSite
		editMapRed
		editYarnSite

		#如果是namenode节点，需要自己获取IP地址。如果是datanode节点需要从启动的环境变量中获取
		IP=`ip addr show dev eth0|grep inet|awk '{print $2}'|awk -F'/' '{print $1}'`
		sed -i -e "s@hadoop-master@$IP@g" $HADOOP_CONF_DIR/core-site.xml
		sed -i -e "s@namenode01@$IP@g" $HADOOP_CONF_DIR/hdfs-site.xml
		sed -i "s@hadoop-master@$RESOURCEMANAGER_ADDR@g" $HADOOP_CONF_DIR/yarn-site.xml
		echo "$IP `hostname`" >>/etc/hosts

		if [ ! -d /hdfs/namenode/current ];then
			$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format
			sleep 3
			$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode 
		else
			$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager &
			$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode  
		fi
		;;
	"datanode")
		#生成配置文件
		editHadoopEvn
		editCoreSite
		editHdfsSite
		editMapRed
		editYarnSite
		sed -i -e "s@hadoop-master@$NAMENODE_IP@g" $HADOOP_CONF_DIR/core-site.xml
		sed -i -e "s@namenode01@$NAMENODE_IP@g" $HADOOP_CONF_DIR/hdfs-site.xml
		sed -i "s@hadoop-master@$NAMENODE_IP@g" $HADOOP_CONF_DIR/yarn-site.xml
		echo "$NAMENODE_IP $NAMENODE_HOSTNAME" >>/etc/hosts

		$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager  &
		$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode 
		;;
	"shell")
		/bin/bash
		;;
	*)
		echo "$@ [resourcemanager|namenode|datanode]"
esac

