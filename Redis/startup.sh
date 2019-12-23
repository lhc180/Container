#!/bin/bash


case "$1" in
	"start")
		docker run \
			--name redis01 \
			--network apache_network \
			--restart always \
			-p 6379:6379 \
			-d redis:4-buster
		;;
	"stop")
		docker rm -f redis01
		;;
	*)
		echo "Usage: $@ [start|stop]"
esac
