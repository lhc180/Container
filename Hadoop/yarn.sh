#!/bin/bash

readonly IMGNAME=taylor840326/hadoop:2.7.7


function create_yarn_resourcemanager(){
	docker run \
		--cpus 2 \
		-m 2147483648 \
		--name resourcemanager \
		--restart always \
		--hostname resourcemanager \
		--network apache_network \
		-p 8088:8088 \
		-d $IMGNAME resourcemanager
}

function destroy_yarn_resourcemanager(){
	docker rm -f resourcemanager
}

case "$1" in
	"start")
		create_yarn_resourcemanager
		;;
	"stop")
		destroy_yarn_resourcemanager
		;;
	*)
		echo "Usage: $@ [start|stop]"
esac
