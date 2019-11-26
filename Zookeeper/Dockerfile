FROM taylor840326/jdk:8

RUN \
	cd /opt && \
	wget -O apache-zookeeper-3.5.6-bin.tar.gz  https://mirrors.aliyun.com/apache/zookeeper/zookeeper-3.5.6/apache-zookeeper-3.5.6-bin.tar.gz && \
	tar xf apache-zookeeper-3.5.6-bin.tar.gz && \
	rm -f apache-zookeeper-3.5.6-bin.tar.gz 

ADD entrypoint.sh /
ENV ZOOKEEPER_HOME /opt/apache-zookeeper-3.5.6-bin
ENV PATH $ZOOKEEPER_HOME/bin:$PATH

ENTRYPOINT ["/entrypoint.sh"]
