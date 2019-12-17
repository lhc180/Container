#!/bin/bash

readonly IMGNAME=taylor840326/hadoop:2.7.7

readonly NAMENODE_NAME=namenode
readonly DATANODE_NAME=datanode


function create_namenode(){
	docker run \
		--cpus 2 \
		--name "$NAMENODE_NAME"01 \
		--restart always \
		--hostname "$NAMENODE_NAME"01 \
		--network apache_network \
		-d $IMGNAME $NAMENODE_NAME
}

function destroy_namenode(){
	docker rm -f "$NAMENODE_NAME"01
}

function create_datanode(){
	NAMENODE_IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$NAMENODE_NAME"01`
	for i in {1..3};
	do
		docker run \
			--cpus 2 \
			--name datanode0$i \
			--restart always \
			--hostname datanode0$i \
			--network apache_network \
			-e NAMENODE_HOSTNAME="$NAMENODE_NAME"01 \
			-e NAMENODE_IP=$NAMENODE_IP \
			-d $IMGNAME datanode
	done
}

function destroy_datanode(){
	for i in {1..3}
	do
		docker rm -f datanode0$i
	done
}

case "$1" in
	"create_namenode")
		create_namenode
		;;
	"create_datanode")
		create_datanode
		;;
	"destroy_namenode")
		destroy_namenode
		;;
	"destroy_datanode")
		destroy_datanode
		;;
	"start")
		create_namenode
		sleep 3
		create_datanode
		;;
	"stop")
		destroy_datanode
		destroy_namenode
		;;
	*)
		echo "Usage: $@ [create_namenode|destroy_namenode|create_datanode|destroy_datanode|start|stop]"
esac
