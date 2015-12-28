#!/bin/sh
cat /dev/null > Abis_DbPpuMap.csv
i=1
t1=13
t2=22
t3=31
while [ $i -le 65 ]
do
	let bts=i*3-2
	let scc=bts-1
	echo "Value,${bts},${i}/${t1},2/${scc},bts_${bts}_D1" >> Abis_DbPpuMap.csv
	let bts=i*3-1
        let scc=bts-1
        echo "Value,${bts},${i}/${t2},2/${scc},bts_${bts}_D1" >> Abis_DbPpuMap.csv
	let bts=i*3
        let scc=bts-1
        echo "Value,${bts},${i}/${t3},2/${scc},bts_${bts}_D1" >> Abis_DbPpuMap.csv
	let i=i+1
done
