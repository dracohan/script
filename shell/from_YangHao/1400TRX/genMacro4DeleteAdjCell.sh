#!/bin/sh
if [ $# -ne 1 ]
then
	echo "Usage: $0 startBTSID"
	exit 1
fi
lac=149
startBTS=$1
let startCELL=startBTS*2-1
SIZE=10
declare -a cell
i=0
while [ $i -lt ${SIZE} ]
do
        cell[$i]=`expr ${startCELL} + $i`
        #echo ${cell[$i]}
        let i=i+1
done
i=0
while [ $i -lt ${SIZE} ]
do
	echo -ne "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t" >> tmp.txt
	echo -ne "'${cell[$i]}'\t'${lac}'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t" >> tmp.txt
        j=0
        while [ $j -lt $i ]
        do
                echo -ne "'${cell[$j]}'\t'${lac}'\t" >> tmp.txt
                let j=j+1
        done
        let j=i+1
        while [ $j -lt ${SIZE} ]
        do
                echo -ne "'${cell[$j]}'\t'${lac}'\t" >> tmp.txt
                let j=j+1
        done
        echo -e "''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
        let i=i+1
done
