all: build build_tag push
build:
	docker build -t ubuntu:18.04_aliyun -f Dockerfile .
	docker build -t jdk:8	-f Dockerfile.jdk8 .
build_tag:
	docker tag ubuntu:18.04_aliyun taylor840326/ubuntu:18.04_aliyun
push:
	docker push taylor840326/ubuntu:18.04_aliyun
