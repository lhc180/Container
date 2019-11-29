#!/bin/bash


docker run \
	--name mysql \
	--restart always \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=111111 \
	-d mysql:5.7
