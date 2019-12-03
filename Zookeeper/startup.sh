#!/bin/bash

set -x

case "$1" in
	"start")
		docker run --name zookeeper1 --cpus 2 --network apache_network --ip "192.168.100.250" --hostname zookeeper1 --restart always -e ID="1" -d taylor840326/zookeeper:3.5.6		
		docker run --name zookeeper2 --cpus 2 --network apache_network --ip "192.168.100.251" --hostname zookeeper2 --restart always -e ID="2" -d taylor840326/zookeeper:3.5.6		
		docker run --name zookeeper3 --cpus 2 --network apache_network --ip "192.168.100.252" --hostname zookeeper3 --restart always -e ID="3" -d taylor840326/zookeeper:3.5.6		
		;;
	"stop")
		docker ps |grep zookeeper|awk '{print $NF}'|xargs -I {} docker rm -f {}
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;
esac
