#!/bin/bash

readonly WORKDIR=`pwd`



if [ ! -d $WORKDIR/prometheus ];then
	mkdir -p $WORKDIR/prometheus
fi

case "$1" in
	"start")
		docker run  \
			--name prometheus01 \
			--net host \
			--restart always \
			-p 9090:9090 \
			-v $WORKDIR/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
			-v $WORKDIR/prometheus/file_sd:/prometheus/file_sd/ \
			-d prom/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.retention.time=1h --storage.tsdb.wal-compression
		;;
	"stop")
		docker rm -f prometheus01
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;
esac
