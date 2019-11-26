#!/bin/bash

docker ps -a|grep zookeeper|awk '{print $NF}'|xargs -I {} docker rm -f {}
