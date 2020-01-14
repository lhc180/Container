#!/bin/bash


case "$1" in 
	"start")
		docker run \
			--name kafka_adapter \
			--network host \
			--restart always \
			--hostname kafka_adapter \
			--cpus 2 \
			-e PORT=9080 \
			-e KAFKA_BROKER_LIST="172.18.8.251:9092,172.18.8.252:9092,172.18.8.253:9092" \
			-e KAFKA_TOPIC="prom_metrics" \
			-d telefonica/prometheus-kafka-adapter:1.4.0
		;;
	"stop")
		docker rm -f kafka_adapter
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;
esac
