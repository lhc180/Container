#!/bin/bash

readonly WORKDIR=`pwd`
if [ ! -d $WORKDIR/grafana ];then
	mkdir -p $WORKDIR/grafana
fi

docker run -d \
	--name grafana01 \
	--network apache_network \
	--hostname grafana01 \
	--restart always \
	-v $WORKDIR/grafana:/var/lib/grafana \
	-d grafana/grafana
