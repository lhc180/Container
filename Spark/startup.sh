#!/bin/bash

	
for i in {1..4};
do
	case $i in
		1)
		docker run \
			--name spark01 \
			--network hdfs \
			--hostname spark01 \
			--restart always \
			-v /opt/spark-2.3.4-bin-hadoop2.7 \
			-d taylor840326/spark:2.3.4  master
		;;
		*)
		docker run \
			--name spark0$i \
			--network hdfs \
			--hostname spark0$i \
			--restart always \
			--volumes-from spark01 \
			-d taylor840326/spark:2.3.4 worker
	esac
done
