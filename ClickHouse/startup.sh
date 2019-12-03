#!/bin/bash


case "$1" in
	"start")
		docker run \
			--name clickhouse \
			--network apache_network \
			--hostname clickhouse \
			--restart always \
			--ulimit nofile=262144:262144 \
			-p 9000:9000 \
			-p 8123:8123 \
			-d yandex/clickhouse-server
		;;
	"stop")
		docker rm -f clickhouse
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;
esac
