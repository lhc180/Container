#!/bin/bash

readonly WORKDIR=`pwd`

if [ ! -d $WORKDIR/prometheus ];then
	mkdir -p $WORKDIR/prometheus
fi

docker run  \
	--name prometheus01 \
	--network apache_network \
	--hostname prometheus01 \
	--restart always \
	-p 9090:9090 \
	-v $WORKDIR/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
	-d prom/prometheus
