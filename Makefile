all: build 
build: build_ubuntu build_jdk build_hadoop build_hive

build_ubuntu:
	docker build -t taylor840326/ubuntu:18.04_aliyun -f Ubuntu/Dockerfile Ubuntu
build_jdk:
	docker build -t taylor840326/jdk:8 -f JDK/Dockerfile JDK
build_zookeeper:
	docker build -t taylor840326/zookeeper:3.5.6 -f Zookeeper/Dockerfile Zookeeper
build_hadoop:
	docker build -t taylor840326/hadoop:2.7.7 -f Hadoop/Dockerfile Hadoop
build_hive:
	docker build -t taylor840326/hive:2.3.6 -f Hive/Dockerfile Hive
build_spark:
	docker build -t taylor840326/spark:2.3.4 -f Spark/Dockerfile Spark
build_mysql:
	docker build -t taylor840326/mysql:5.7	-f MySQL/Dockerfile MySQL
build_kafka:
	docker build -t taylor840326/kafka:2.3.1 -f Kafka/Dockerfile Kafka
