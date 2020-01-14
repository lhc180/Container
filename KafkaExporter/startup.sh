#!/bin/bash



case $1 in
	"start")
		docker run \
			--name kafka_exporter \
			--restart always \
			-p 9308:9308 \
			-d danielqsj/kafka-exporter \
			--kafka.server=172.18.8.251:9092 \
			--kafka.server=172.18.8.252:9092 \
			--kafka.server=172.18.8.253:9092 
			;;
	*)
		echo "Usage: $@ [start|stop]"
esac
