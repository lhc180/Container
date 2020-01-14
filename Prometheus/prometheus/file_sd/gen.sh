#!/bin/bash

echo -e "[\n\t{\n\t\t\"targets\":[\n" >server.json

for i in {1..512}
do
	EXPORTER_PORT=$((9100+$i))
	echo -e "\t\t\t\"192.168.99.249:$EXPORTER_PORT\"," >>server.json
done

echo -e "\n\t\t]\n\t}\n]" >>server.json

