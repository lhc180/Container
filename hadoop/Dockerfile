FROM taylor840326/jdk:8

MAINTAINER TianLei <553948327@qq.com>

WORKDIR /root

ENV HADOOP_HOME=/opt/hadoop-2.7.7
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin$PATH:

ADD config/core-site.xml /tmp/config/
ADD config/hdfs-site.xml /tmp/config/
ADD config/mapred-site.xml /tmp/config/
ADD config/run-wordcount.sh /tmp/config/
ADD config/yarn-site.xml /tmp/config/
ADD entrypoint.sh /

RUN \
	wget -O /opt/hadoop-2.7.7.tar.gz https://mirrors.aliyun.com/apache/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz && \
	cd /opt/ && \
    	tar -xf hadoop-2.7.7.tar.gz && \
	rm -f hadoop-2.7.7.tar.gz && \
	cp /tmp/config/* $HADOOP_HOME/etc/hadoop/ && \
	mkdir -p /hdfs/namenode && \ 
    	mkdir -p /hdfs/datanode && \
    	mkdir $HADOOP_HOME/logs 

ENTRYPOINT [ "/entrypoint.sh"]

