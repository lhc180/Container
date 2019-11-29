#!/bin/bash

for i in {1..3};
do
	case "$i" in
			"1")
		docker run \
			--name zookeeper0$i \
			--cpus 2 \
			-m 2147483648 \
			--network apache_network \
			--hostname zookeeper0$i \
			--restart always \
			-v /opt/apache-zookeeper-3.5.6-bin \
			-p 2181:2181 \
			-e ID="$i" \
			-d taylor840326/zookeeper:3.5.6
			;;
			*)
		docker run \
			--name zookeeper0$i \
			--cpus 2 \
			-m 2147483648 \
			--network apache_network \
			--hostname zookeeper0$i \
			--restart always \
			--volumes-from zookeeper01 \
			-p 218$i:2181 \
			-e ID="$i" \
			-d taylor840326/zookeeper:3.5.6
			;;
	esac
done
