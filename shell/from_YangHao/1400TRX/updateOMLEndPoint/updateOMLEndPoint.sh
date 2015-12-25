#!/bin/sh
# This script is used to automatically update BTS OML EndPoints (including peer BSC CCP IP & TID). 
#set -x

usage() {
	echo ""
	echo "Usage: ./updateOMLEndPoint.sh cfgFile"
	echo ""
	exit 1
}

if [ $# -ne 1 ]; then
	usage
else
	cfgFile=$1
fi
awk '{$2=$3$2;$3=$5$4} {print}' $cfgFile | awk '{print $1,$2,$3}' > oml1.txt
awk '{$2=strtonum("0x"$2);$3=strtonum("0x"$3)} {print}' oml1.txt  > oml2.txt
awk '{
        if($2<235){$4="error"}
        else if($2<285) {$4="10.95.101.203"}
        else if($2<335) {$4="10.95.101.204"}
        else if ($2<385) {$4="10.95.101.205"}
        else if($2<435) {$4="10.95.101.206"}
        else if ($2<485) {$4="10.95.101.207"}
        else if($2<705) {$4="error"}
        else if($2<755){$4="10.95.101.208"}
        else if($2<805) {$4="10.95.101.209"} 
        else {$4="error"}
      }
      {print}' oml2.txt  > oml3.txt

error=`grep error oml3.txt`
if [ "$error" != "" ]
then
	echo "Something wrong with your configuration file:"
	echo "		$error"
	exit 1
fi
awk '{print $3}' oml3.txt > tid.txt
awk '{print $4}' oml3.txt > ipaddr.txt

declare -a tid
i=1
for tid in `cat tid.txt`
do
	tid[$i]=$tid
	let i=i+1
done

declare -a ccpip
i=1
for ip in `cat ipaddr.txt`
do
        ccpip[$i]=$ip
        let i=i+1
done

date=`date`
j=1
while [ $j -le 16 ]
do
	cd /home/mx95_ipeth/mx20a_eth${j}/user/om
	declare -a bts
	i=1
	for var in `cat Abis_DbBTS_${j}.csv | awk -F, '{if($1=="Value") print $2}'`
	do
		bts[$i]=$var
		let i=i+1
	done

	declare -a dchan
	i=1
	for var in `cat Abis_DbBTS_${j}.csv | awk -F, '{if($1=="Value") print $3}'`
	do
		dchan[$i]=$var
		let i=i+1
	done

	echo "###### Generated at ${date} using script $0" > tmp.csv
	echo "Title,DchanSapiTei,RemAddr,RemPort,RemTid" >> tmp.csv
	echo "Type,Index,Normal,Normal,Normal" >> tmp.csv
	echo "Access,Read_Only,Read_Only,Read_Only,Read_Only" >> tmp.csv
	max=${#bts[@]}
	for((i=1;i<=max;i++))
	do
		bts=${bts[$i]}
		ccp=${ccpip[$bts]}
		tid=${tid[$bts]}
		echo "Value,${dchan[$i]}_62_1,${ccp},52736,${tid}" >> tmp.csv
	done
	cp tmp.csv Abis_DbIpDchanSapiTei_${j}.csv
	unset bts
	unset dchan
	
	let j=j+1
done
