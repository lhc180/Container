#!/bin/bash

docker run \
	--name hive01 \
	--restart always \
	--network hadoop \
	-e MYSQL_ADDR="172.18.7.184" \
	-e MYSQL_PORT=3306 \
	-e MYSQL_USER="root" \
	-e MYSQL_PASSWORD="111111" \
	-e HDFS_ADDR="172.21.0.2" \
	-e HDFS_HOSTNAME="hadoop-master" \
	-p 10000:10000 \
	-p 10002:10002 \
	-p 9083:9083 \
	--volumes-from hadoop-master \
	-d hive
