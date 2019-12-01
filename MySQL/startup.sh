#!/bin/bash


docker run \
	--name mysql01 \
	--restart always \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=111111 \
	-d taylor840326/mysql:5.7
