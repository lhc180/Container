#!/bin/bash



case "$1" in
	"start")
		docker run \
			--name kafkamanager01 \
			--network apache_network \
			--hostname kafkamanager01 \
			--restart always \
			-e ZK_HOSTS=192.168.99.251:2181,192.168.99.252:2181,192.168.99.253:2181 \
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
