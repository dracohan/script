#!/bin/sh
echo > deleteBTS.mcr
i=141
while [ $i -le 250 ]
do
	echo -e "Cmd_Start\t0\t'DELETE BTS'\t'DELETE BTS'\t'BSS'\t'BSS'\t'1'\t'*****'\t'${i}'\tCmd_End" >> deleteBTS.mcr
	let i=i+1
done
