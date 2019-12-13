FROM taylor840326/jdk:8

MAINTAINER TianLei <553948327@qq.com>

RUN \
	wget -O /opt/hadoop-2.7.7.tar.gz https://mirrors.aliyun.com/apache/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz && \
	cd /opt/ && \
    	tar -xf hadoop-2.7.7.tar.gz && \
	rm -f hadoop-2.7.7.tar.gz && \
	mkdir -p /opt/hadoop-2.7.7/logs && \
	mkdir -p /hdfs/namenode && \ 
    	mkdir -p /hdfs/datanode 

ENV HADOOP_HOME=/opt/hadoop-2.7.7 
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop HADOOP_HEAPSIZE=2048 HADOOP_NAMENODE_INIT_HEAPSIZE=1024 PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH YARN_CONF_DIR=$HADOOP_CONF_DIR


ADD entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh"]

