#!/bin/bash

readonly WORKDIR=`pwd`



if [ ! -d $WORKDIR/prometheus ];then
	mkdir -p $WORKDIR/prometheus
fi

case "$1" in
	"start")
		docker ps|grep node_exporter|awk '{print $NF}'|xargs -I {} docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {} >$WORKDIR/prometheus/file_sd/server.json
		sed -i -e 's@^192@\t\t\t"192@g' -e 's@$@:9100",@g' -e '$s/,//' $WORKDIR/prometheus/file_sd/server.json
		sed -i -e "1c[\n\t{\n\t\"targets\":[" $WORKDIR/prometheus/file_sd/server.json
		sed -i -e '$a]\n\t\t}\n\t]' $WORKDIR/prometheus/file_sd/server.json
		docker run  \
			--name prometheus01 \
			--network apache_network \
			--hostname prometheus01 \
			--restart always \
			-p 9090:9090 \
			-v $WORKDIR/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
			-v $WORKDIR/prometheus/file_sd:/prometheus/file_sd/ \
			-d prom/prometheus
		;;
	"stop")
		docker rm -f prometheus01
		;;
	*)
		echo "Usage: $@ [start|stop]"
		;;
esac
