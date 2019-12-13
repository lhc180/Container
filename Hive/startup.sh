#!/bin/bash

case $1 in
	"start")
		docker run \
			--name hive01 \
			--restart always \
			--hostname hive01 \
			--network apache_network \
			-e MYSQL_ADDR="172.18.7.184" \
			-e MYSQL_PORT=3306 \
			-e MYSQL_USER="root" \
			-e MYSQL_PASSWORD="111111" \
			-p 10000:10000 \
			-p 10002:10002 \
			-p 9083:9083 \
			--volumes-from namenode01 \
			-d taylor840326/hive:2.3.6
		;;
	"stop")
		docker rm -f hive01
		;;
	*)
		echo "Usage: $@ [start|stop]"
esac

