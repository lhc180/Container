FROM taylor840326/jdk:8

RUN \
	cd /opt && \
	wget -O kafka_2.11-2.3.1.tgz https://mirrors.aliyun.com/apache/kafka/2.3.1/kafka_2.11-2.3.1.tgz && \
	tar xf kafka_2.11-2.3.1.tgz && \
	rm -f kafka_2.11-2.3.1.tgz 

ADD entrypoint.sh /
ENV KAFKA_HOME /opt/kafka_2.11-2.3.1
ENV PATH $KAFKA_HOME/bin:$PATH

ENTRYPOINT ["/entrypoint.sh"]
