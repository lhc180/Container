FROM taylor840326/hadoop:2.7.7

RUN \
	apt -y install libmysql-java && \
	cd /opt && \
	wget -O spark-2.3.4-bin-hadoop2.7.tgz  https://mirrors.aliyun.com/apache/spark/spark-2.3.4/spark-2.3.4-bin-hadoop2.7.tgz && \
	tar xf spark-2.3.4-bin-hadoop2.7.tgz && \
	rm -f spark-2.3.4-bin-hadoop2.7.tgz && \
	cp /usr/share/java/mysql-connector-java-5.1.45.jar $SPARK_HOME/jars 

ADD entrypoint.sh /
ENV SPARK_HOME /opt/spark-2.3.4-bin-hadoop2.7
ENV YARN_CONF_DIR=/opt/hadoop-2.7.7/etc/hadoop
ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

ENTRYPOINT ["/entrypoint.sh"]
