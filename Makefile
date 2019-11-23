all:
	docker build -t ubuntu:18.04_aliyun -f Dockerfile .
	docker build -t jdk:8	-f Dockerfile.jdk8 .
