#!/bin/sh
echo > move_bts_tdm2ip.mcr
bts=1
while [ ${bts} -le 250 ]
do
	let group=(bts-1)/15
	let group=group+85
	let pos=bts%15
	if [ $pos -eq 0 ]
	then
		let pos=pos+15
	fi
	if [ $bts -le 9 ]
	then
		ip="00"$bts
	elif [ $bts -le 99 ]
	then
		ip="0"$bts
	else
		ip=$bts
	fi
	echo -e "Cmd_Start\t0\t'MOVE BTS'\t'MOVE BTS'\t'BSS'\t'BTS'\t'${bts}'\t'${group}'\t'${pos}'\t'OML'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t'172.070.095.${ip}'\t'BM0IALE2.02E'\t''\tCmd_End" >> move_bts_tdm2ip.mcr
	let bts=bts+1
done
