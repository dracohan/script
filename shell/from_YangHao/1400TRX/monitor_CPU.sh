#!/bin/sh
mkdir -p 755 /var/log/CPU_Data
num=1
while [ $num -le 200 ]
do
	ts=`date +%Y%m%d%H%M`
	./CPULoad.sh 30
	cp /var/log/CPULoad/CPULoad.tar.gz /var/log/CPU_Data/CPULoad_${ts}.tar.gz
	let num=num+1
done
