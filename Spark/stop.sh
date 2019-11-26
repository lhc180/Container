#!/bin/bash


docker ps -a|grep spark|awk '{print $NF}'|xargs -I {} docker rm -f {}
