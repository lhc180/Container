#!/bin/bash

case "$1" in 
	"start")
		for i in {1..192}
		do
			#EXPORTER_PORT=$((9100+$i))
			docker run \
				--name node_exporter$i \
				--hostname node$i \
				--network apache_network \
				--restart always \
				-v "/proc:/host/proc:ro" \
				-v "/sys:/host/sys:ro" \
				-v "/:/rootfs:ro" \
				-d prom/node-exporter
		done
		;;
	"stop")
		docker ps|grep node_exporter|awk '{print $NF}'|xargs -I {} docker rm -f {}
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;		
esac
