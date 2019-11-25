#!/bin/bash

readonly IMGNAME=taylor840326/hadoop:2.7.7

function create_network() {
	docker network create -d bridge --subnet 192.168.100.0/24  hdfs
}

function destroy_network() {
	docker network rm hdfs
}

function create_namenode(){
	docker run --name namenode01 --hostname namenode01 --network hdfs -v /opt/hadoop-2.7.7 -P -d $IMGNAME namenode
}

function destroy_namenode(){
	docker rm -f namenode01
}

function create_datanode(){
	for i in {1..3};
	do
		docker run --name datanode0$i --hostname datanode0$i --network hdfs --volumes-from namenode01 -d $IMGNAME datanode
	done
}

function destroy_datanode(){
	for i in {1..3}
	do
		docker rm -f datanode0$i
	done
}

case "$1" in
	"create_network")
		create_network
		;;
	"create_namenode")
		create_namenode
		;;
	"create_datanode")
		create_datanode
		;;
	"destroy_network")
		destroy_network
		;;
	"destroy_namenode")
		destroy_namenode
		;;
	"destroy_datanode")
		destroy_datanode
		;;
	"start_hdfs")
		create_network
		create_namenode
		sleep 3
		create_datanode
		;;
	"stop_hdfs")
		destroy_datanode
		destroy_namenode
		destroy_network
		;;
	*)
		echo "Usage: $@ [create_network|destroy_network|create_namenode|destroy_namenode|create_datanode|destroy_datanode|start_hdfs|stop_hdfs]"
esac
