#!/bin/sh
num=1
while [ $num -le 16 ]
do
	cp ./Abis_DbCU.csv ./mx20a_eth${num}/user/om/Abis_DbCU.csv
	let num=num+1
done
