#!/bin/bash

for i in {1..256}
do
	EXPORTER_PORT=$((9100+$i))
	docker run -d -p $EXPORTER_PORT:9100 \
		-v "/proc:/host/proc:ro" \
		-v "/sys:/host/sys:ro" \
		-v "/:/rootfs:ro" \
		--net="host" \
		prom/node-exporter
done
