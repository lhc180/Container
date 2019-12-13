#!/bin/bash

for i in {1..4};
do
	case $i in
		1)
		docker run \
			--name spark01 \
			--network apache_network \
			--hostname spark01 \
			--restart always \
			-p 8088:8088 \
			-p 7077:7077 \
			-p 9000:9000 \
			-d taylor840326/spark:2.3.4  master
		;;
		*)
		sleep 5
		IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' spark01`
		docker run \
			--name spark0$i \
			--network apache_network \
			--hostname spark0$i \
			--restart always \
			-e MASTER_HOSTNAME=spark01 \
			-e MASTER_IP=$IP \
			-d taylor840326/spark:2.3.4 worker
	esac
done
