#!/bin/bash

readonly NAMENODE_HOSTNAME_ORIG=namenode01
readonly NAMENODE_ADDR_ORIG=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $NAMENODE_HOSTNAME_ORIG`
	
for i in {1..4};
do
	case $i in
		1)
		docker run \
			--name spark01 \
			--network apache_network \
			--hostname spark01 \
			--restart always \
			-e NAMENODE_HOSTNAME=$NAMENODE_HOSTNAME_ORIG \
			-e NAMENODE_ADDR=$NAMENODE_ADDR_ORIG \
			-v /opt/spark-2.3.4-bin-hadoop2.7 \
			--volumes-from namenode01 \
			-d taylor840326/spark:2.3.4  master
		;;
		*)
		docker run \
			--name spark0$i \
			--network apache_network \
			--hostname spark0$i \
			--restart always \
			-e NAMENODE_HOSTNAME=$NAMENODE_HOSTNAME_ORIG \
			-e NAMENODE_ADDR=$NAMENODE_ADDR_ORIG \
			--volumes-from spark01 \
			--volumes-from namenode01 \
			-d taylor840326/spark:2.3.4 worker
	esac
done
