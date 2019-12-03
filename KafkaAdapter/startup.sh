#!/bin/bash


case "$1" in 
	"start")
		docker run \
			--name kafka_adapter \
			--network apache_network \
			--restart always \
			--hostname kafka_adapter \
			--cpus 2 \
			-p 9080:8080 \
			-e KAFKA_BROKER_LIST="172.18.8.250:9093,172.18.8.250:9094,172.18.8.250:9095" \
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
