#!/bin/sh
cat /dev/null > tmp.txt
i=14
while [ $i -le 65 ]
do
	let j=i*3
	echo -e "Cmd_Start\t0\t'MOVE BTS'\t'MOVE BTS'\t'BSS'\t'BTS'\t'${j}'\t'${i}'\t'1'\t'OML'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'BM0SALC2.02C'\t''\tCmd_End" >> tmp.txt
	let j=i*3-1
	echo -e "Cmd_Start\t0\t'MOVE BTS'\t'MOVE BTS'\t'BSS'\t'BTS'\t'${j}'\t'${i}'\t'2'\t'OML'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'BM0SALC2.02C'\t''\tCmd_End" >> tmp.txt
	let j=i*3-2
	echo -e "Cmd_Start\t0\t'MOVE BTS'\t'MOVE BTS'\t'BSS'\t'BTS'\t'${j}'\t'${i}'\t'3'\t'OML'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'BM0SALC2.02C'\t''\tCmd_End" >> tmp.txt
	let i=i+1
done
