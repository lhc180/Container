#!/bin/bash

docker network create -d bridge --subnet 192.168.100.0/24  hdfs

docker run --name namenode01 --hostname namenode01 --network hdfs -v /opt/hadoop-2.7.7/etc/hadoop -P -d hdfs namenode
for i in {1..3};
do
	docker run --name datanode0$i --hostname datanode0$i --network hdfs --volumes-from namenode01 -d hdfs datanode
done
