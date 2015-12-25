#!/bin/sh
echo > init_atertp.mcr
i=1
while [ $i -le 30 ]
do
	echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATER_HWAYTP'\t'${i}'\t'255'\tCmd_End" >> init_atertp.mcr
	let j=i*4-3
	echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
	let j=i*4-2
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
	let j=i*4-1
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
	let j=i*4
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
	let i=i+1
done

i=59
while [ $i -le 76 ]
do
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATER_HWAYTP'\t'${i}'\t'255'\tCmd_End" >> init_atertp.mcr
        let j=i*4-3
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
        let j=i*4-2
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
        let j=i*4-1
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
        let j=i*4
        echo -e "Cmd_Start\t0\t'SBL INIT'\t'SBL INITIALISE'\t'SBL'\t'BSC'\t'1'\t'ATR'\t'${j}'\t'255'\tCmd_End" >> init_atertp.mcr
        let i=i+1
done
