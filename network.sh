#!/bin/bash

function create_network() {
	docker network create \
		-d bridge \
		--subnet 192.168.100.0/24  \
		apache_network
}

function destroy_network() {
	docker network rm apache_network
}

case "$1" in
	"start")
		create_network
		;;
	"stop")
		create_yarn_resourcemanager
		;;
	*)
		echo "Usage: $@ [start|stop]"
esac
