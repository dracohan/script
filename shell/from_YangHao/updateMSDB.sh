#!/bin/sh
num=1
while [ $num -le 16 ]
do
	cp ./Nom4500_ETH_Abis_MsDb_Mx10A_VMS.csv ./mx20a_eth${num}/user/Nom4500_ETH_Abis_MsDb_Mx10A_VMS.csv
	let num=num+1
done
