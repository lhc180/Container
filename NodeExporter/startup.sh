#!/bin/bash

for i in {1..256}
do
	#EXPORTER_PORT=$((9100+$i))
	docker run \
		--name node$i \
		--hostname node$i \
		--network apache_network \
		--restart always \
		-v "/proc:/host/proc:ro" \
		-v "/sys:/host/sys:ro" \
		-v "/:/rootfs:ro" \
		-d prom/node-exporter
done
