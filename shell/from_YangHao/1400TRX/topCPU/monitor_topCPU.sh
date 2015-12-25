#!/bin/sh
mkdir -p 755 /var/log/topCPU_Data
num=1
while [ $num -le 200 ]
do
	ts=`date +%Y%m%d%H%M`
	./topCPU.sh 30
	cp /var/log/topCPULoad/topCPULoad.tar.gz /var/log/topCPU_Data/topCPULoad_${ts}.tar.gz
	let num=num+1
done
