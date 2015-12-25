#!/bin/sh
echo > read_DTC.mcr
i=1
while [ $i -le 512 ]
do
	echo -e "Cmd_Start\t0\t'SBL READ STATUS'\t'SBL READ STATUS'\t'SBL'\t'BSC'\t'1'\t'DTC'\t'${i}'\t'255'\tCmd_End" >> read_DTC.mcr
	let i=i+1
done
