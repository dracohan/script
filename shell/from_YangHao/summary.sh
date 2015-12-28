#!/bin/bash
echo -e "StartTime\tOMCP1\tOMCP2\tCCP5\t\CCP6\tCCP7\tCCP8\tCCP9\tCCP10" > sum.txt
for file in `ls CPULoad_*.tar.gz`
do
	TS=${file:8:12}
	tar zxvf $file
	CPU_OMCP1=`cat cpuLoad.avg | awk '{if($1=="OMCP1") print $2}'`
	CPU_OMCP2=`cat cpuLoad.avg | awk '{if($1=="OMCP2") print $2}'`
	CPU_CCP5=`cat cpuLoad.avg | awk '{if($1=="CCP5") print $2}'`
	CPU_CCP6=`cat cpuLoad.avg | awk '{if($1=="CCP6") print $2}'`  
	CPU_CCP7=`cat cpuLoad.avg | awk '{if($1=="CCP7") print $2}'`
	CPU_CCP8=`cat cpuLoad.avg | awk '{if($1=="CCP8") print $2}'`
	CPU_CCP9=`cat cpuLoad.avg | awk '{if($1=="CCP9") print $2}'`
	CPU_CCP10=`cat cpuLoad.avg | awk '{if($1=="CCP10") print $2}'`
	echo -e "$TS\t${CPU_OMCP1}\t${CPU_OMCP2}\t${CPU_CCP5}\t${CPU_CCP6}\t${CPU_CCP7}\t${CPU_CCP8}\t${CPU_CCP9}\t${CPU_CCP10}" >> sum.txt
done

