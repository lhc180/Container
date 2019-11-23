all: build build_tag push
build: build_ubuntu build_jdk

build_ubuntu:
	docker build -t ubuntu:18.04_aliyun -f Ubuntu/Dockerfile Ubuntu
build_jdk:
	docker build -t jdk:8 -f JDK/Dockerfile JDK
build_tag:
	docker tag ubuntu:18.04_aliyun taylor840326/ubuntu:18.04_aliyun
	docker tag jdk:8  taylor840326/jdk:8
push:
	docker push taylor840326/ubuntu:18.04_aliyun
	docker push taylor840326/jdk:8
