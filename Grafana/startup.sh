#!/bin/bash

readonly WORKDIR=`pwd`
if [ ! -d $WORKDIR/grafana ];then
	mkdir -p $WORKDIR/grafana
fi

case "$1" in
	"start")
		docker run \
			--name grafana01 \
			--network apache_network \
			--hostname grafana01 \
			--restart always \
			-p 3000:3000 \
			-d grafana/grafana
		;;
	"stop")
		docker rm -f grafana01
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;
esac
