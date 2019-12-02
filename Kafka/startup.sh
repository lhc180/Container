#!/bin/bash

set -x
	
ZK=`docker ps|grep zookeeper|awk '{print $NF}'|xargs -I {} docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {} |while read zk;do echo -n $zk":2181," ;done|sed 's@,$@@g'`
	
case "$1" in
	"standalone")
		docker run \
			--name kafka01 \
			--hostname kafka01 \
			--restart always \
			-p 9092:9092 \
			-d taylor840326/kafka:2.3.1 standalone
		;;
	"cluster")
		for i in {1..3};
		do
			KAFKA_PORT=$((9092 +$i))
			docker run \
				--name kafka0$i \
				--network apache_network \
				--hostname kafka0$i \
				--restart always \
				-e ID="$i" \
				-e ZKURL="$ZK" \
				-p $KAFKA_PORT:9092 \
				-d taylor840326/kafka:2.3.1 cluster
		done
		;;
	"stop")
		docker ps|grep kafka|awk '{print $NF}'|xargs -I {} docker rm -f {}
		;;
	*)
		echo "Usage: $@ [standalone|cluster|stop]"
esac

