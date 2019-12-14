#!/bin/bash

ZK=`docker ps|grep zookeeper|awk '{print $NF}'|xargs -I {} docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {} |while read zk;do echo -n $zk":2181," ;done|sed 's@,$@@g'`


case "$1" in
	"start")
		docker run \
			--name kafkamanager01 \
			--network apache_network \
			--hostname kafkamanager01 \
			--restart always \
			-e ZK_HOSTS=$ZK \
			-e APPLICATION_SECRET="admin" \
			-p 19000:9000 \
			-d sheepkiller/kafka-manager:latest

		;;
	"stop")
		docker rm -f kafkamanager01
		;;
	*)
		echo "Usage: $@ [start|stop]"
		exit 0
esac
