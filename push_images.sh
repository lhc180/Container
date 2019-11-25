#!/bin/bash

docker images|grep taylor840326|while read image
do
	IMGNAME=`echo $image|awk '{print $1}'`
	IMGTAG=`echo $image|awk '{print $2}'`
	docker push $IMGNAME:$IMGTAG
done
