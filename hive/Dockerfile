FROM taylor840326/jdk:8

ADD hive-site.xml /opt/apache-hive-2.3.6-bin/conf/
ADD entrypoint.sh /

ENV HIVE_HOME /opt/apache-hive-2.3.6-bin
ENV PATH $PATH:$HIVE_HOME/bin

RUN \
	apt -y install libmysql-java && \
	wget -O /opt/apache-hive-2.3.6-bin.tar.gz https://mirrors.aliyun.com/apache/hive/hive-2.3.6/apache-hive-2.3.6-bin.tar.gz && \
	cd /opt && \
	tar xf apache-hive-2.3.6-bin.tar.gz && \
	rm -f apache-hive-2.3.6-bin.tar.gz && \
	cp /usr/share/java/mysql-connector-java-5.1.45.jar /opt/apache-hive-2.3.6-bin/lib && \
	cd /opt/apache-hive-2.3.6-bin/conf && \
	echo "export HADOOP_HOME=/usr/local/hadoop" >>hive-env.sh && \
	echo "export HIVE_CONF_DIR=/opt/apache-hive-2.3.6-bin/conf" >>hive-env.sh 


ENTRYPOINT ["/entrypoint.sh"]
