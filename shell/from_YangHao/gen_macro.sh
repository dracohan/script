#!/bin/sh
cat /dev/null > tmp.mcr
i=0
while [ $i -le 75 ]
do
	let j=i+1
	echo "Cmd_Start $i 'SBL READ STATUS' 'SBL READ STATUS' 'SBL' 'BSC' '1' 'ATER_HWAYTP' '$j' '255' Cmd_End" >> tmp.mcr
	let i=i+1
done
