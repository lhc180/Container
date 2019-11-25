all: build build_tag push
build: build_ubuntu build_jdk build_hadoop build_hive

build_ubuntu:
	docker build -t taylor840326/ubuntu:18.04_aliyun -f Ubuntu/Dockerfile Ubuntu
build_jdk:
	docker build -t taylor840326/jdk:8 -f JDK/Dockerfile JDK
build_hadoop:
	docker build -t taylor840326/hadoop:2.7.7 -f hadoop/Dockerfile hadoop
build_hive:
	docker build -t taylor840326/hive:2.3.6 -f hive/Dockerfile hive
