#!/bin/bash
set -x
#This script is used to generate abis reg scripts. All the declared arrays are based on pool, for example, bsic[1] stands for bsic of pool1 and trx[1] stands for the number of trx in pool1. All the arrays should be filled according to your platform before executing the script.

host=tstm1

declare -a port
port[1]=1
port[2]=2
port[3]=1
port[4]=1
port[5]=2
port[6]=3
port[7]=3
port[8]=2
port[9]=3
i=10
while [ $i -le 48 ]
do
	let j=i%3
	if [ $j -eq 0 ]
	then
		port[i]=`expr $i / 3`
	else
		port[i]=`expr $i / 3 + 1`
	fi
	let i=i+1
done 

i=1
while [ $i -le 48 ]
do
	let j=port[i]
	if [ $j -le 9 ]
	then
		port[i]="800"$j
	else
		port[i]="80"$j
	fi
        let i=i+1
done

declare -a trx
trx[1]=36
trx[2]=40
trx[3]=24
trx[4]=20
trx[5]=20
trx[6]=18
trx[7]=22
trx[8]=20
i=9
while [ $i -le 38 ]
do
	trx[i]=20
	let i=i+1
done
while [ $i -le 43 ]
do
        trx[i]=60
        let i=i+1
done
while [ $i -le 48 ]
do
        trx[i]=20
        let i=i+1
done

i=1
sum=0
while [ $i -le 48 ]
do
	j=${trx[i]}
	let sum=sum+j
	let i=i+1
done

echo "Total number of TRX: $sum"
NB_M2MC_MOC_PER_TRX=4
NB_M2MC_MTC_PER_TRX=4
NB_M2FIXC_MOC_PER_TRX=2
NB_LU_PER_TRX=2
NB_MTSMS_PER_TRX=3
NB_MOSMS_PER_TRX=3
let START_MS_M2MC_MOC=1
let START_MS_M2MC_MTC=NB_M2MC_MOC_PER_TRX*sum+1
let START_MS_M2FIX=START_MS_M2MC_MTC+NB_M2MC_MTC_PER_TRX*sum
let START_MS_LU=START_MS_M2FIX+NB_M2FIXC_MOC_PER_TRX*sum
let START_MS_MTSMS=START_MS_LU+NB_LU_PER_TRX*sum
let START_MS_MOSMS=START_MS_MTSMS+NB_MTSMS_PER_TRX*sum
echo "Starting MS for M2MC MOC: $START_MS_M2MC_MOC"
echo "Starting MS for M2MC MTC: $START_MS_M2MC_MTC"
echo "Starting MS for M2FIX: $START_MS_M2FIX"
echo "Starting MS for LU: $START_MS_LU"
echo "Starting MS for MTSMS: $START_MS_MTSMS"
echo "Starting MS for MOSMS: $START_MS_MOSMS"
	
declare -a startms_m2mc_moc
declare -a nbms_m2mc_moc
declare -a startms_m2mc_mtc
declare -a nbms_m2mc_mtc
declare -a startms_m2fixc_moc
declare -a nbms_m2fixc_moc
declare -a startms_lu
declare -a nbms_lu
declare -a startms_mtsms
declare -a nbms_mtsms
declare -a startms_mosms
declare -a nbms_mosms


startms_m2mc_moc[1]=$START_MS_M2MC_MOC
let nbms_m2mc_moc[1]=trx[1]*NB_M2MC_MOC_PER_TRX
i=2
while [ $i -le 48 ]
do
	let nbms_m2mc_moc[i]=trx[i]*NB_M2MC_MOC_PER_TRX
	let j=i-1
	let startms_m2mc_moc[i]=startms_m2mc_moc[j]+nbms_m2mc_moc[j]
	let i=i+1
done
echo "####################### M2MC MOC ########################"
echo ${nbms_m2mc_moc[@]}
echo ${startms_m2mc_moc[@]}


startms_m2mc_mtc[1]=$START_MS_M2MC_MTC
let nbms_m2mc_mtc[1]=trx[1]*NB_M2MC_MTC_PER_TRX
i=2
while [ $i -le 48 ]
do
        let nbms_m2mc_mtc[i]=trx[i]*NB_M2MC_MTC_PER_TRX
        let j=i-1
        let startms_m2mc_mtc[i]=startms_m2mc_mtc[j]+nbms_m2mc_mtc[j]
        let i=i+1
done
echo "####################### M2MC MTC ########################" 
echo ${nbms_m2mc_mtc[@]}
echo ${startms_m2mc_mtc[@]}

startms_m2fixc_moc[1]=$START_MS_M2FIX
let nbms_m2fixc_moc[1]=trx[1]*NB_M2FIXC_MOC_PER_TRX
i=2
while [ $i -le 48 ]
do
        let nbms_m2fixc_moc[i]=trx[i]*NB_M2FIXC_MOC_PER_TRX
        let j=i-1
        let startms_m2fixc_moc[i]=startms_m2fixc_moc[j]+nbms_m2fixc_moc[j]
        let i=i+1
done
echo "####################### M2FIXC MOC ########################" 
echo ${nbms_m2fixc_moc[@]}
echo ${startms_m2fixc_moc[@]}

startms_lu[1]=$START_MS_LU
let nbms_lu[1]=trx[1]*NB_LU_PER_TRX
i=2
while [ $i -le 48 ]
do
        let nbms_lu[i]=trx[i]*NB_LU_PER_TRX
        let j=i-1
        let startms_lu[i]=startms_lu[j]+nbms_lu[j]
        let i=i+1
done
echo "####################### LU ########################" 
echo ${nbms_lu[@]}
echo ${startms_lu[@]}

startms_mtsms[1]=$START_MS_MTSMS
let nbms_mtsms[1]=trx[1]*NB_MTSMS_PER_TRX
i=2
while [ $i -le 48 ]
do
        let nbms_mtsms[i]=trx[i]*NB_MTSMS_PER_TRX
        let j=i-1
        let startms_mtsms[i]=startms_mtsms[j]+nbms_mtsms[j]
        let i=i+1
done
echo "####################### MTSMS ########################" 
echo ${nbms_mtsms[@]}
echo ${startms_mtsms[@]}

startms_mosms[1]=$START_MS_MOSMS
let nbms_mosms[1]=trx[1]*NB_MOSMS_PER_TRX
i=2
while [ $i -le 48 ]
do
        let nbms_mosms[i]=trx[i]*NB_MOSMS_PER_TRX
        let j=i-1
        let startms_mosms[i]=startms_mosms[j]+nbms_mosms[j]
        let i=i+1
done
echo "####################### MOSMS ########################" 
echo ${nbms_mosms[@]}
echo ${startms_mosms[@]}



echo "Begin to generate A reg sciprts ..."
i=1
while [ $i -le 16 ]
do
	#host=${host[$i]}
	port=${port[$i]}
	if [ $i -le 9 ]
	then
		l="0"$i
	else
		l=$i
	fi
	echo "#!/bin/sh" > reg_a_Mx20Aflex${l}
	j=1
	while [ $j -le 48 ]
	do
		if [ $j -le 9 ]
		then
			k="0"$j
		else
			k=$j
		fi
		echo "./remtstm_a $host $port create m2mc_$k v4/m2mc_interf.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_m2mc_moc[j]} ${nbms_m2mc_moc[j]} M2MCCORE" >> reg_a_Mx20Aflex${l}
		echo "./remtstm_a $host $port create m2mc_${k}_mtc v4/m2mc_interf.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_m2mc_mtc[j]} ${nbms_m2mc_mtc[j]} M2MCCORE" >> reg_a_Mx20Aflex${l}
		echo "./remtstm_a $host $port create m2fixc_$k m2fixc.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_m2fixc_moc[j]} ${nbms_m2fixc_moc[j]}" >> reg_a_Mx20Aflex${l}
		echo "./remtstm_a $host $port create lu_$k mm_watch.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_lu[j]} ${nbms_lu[j]}" >> reg_a_Mx20Aflex${l}
		echo "./remtstm_a $host $port create fix2msms_$k v4/fix2msms_interf.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_mtsms[j]} ${nbms_mtsms[j]} FIX2SMSINTERF_$k" >> reg_a_Mx20Aflex${l}
		echo "./remtstm_a $host $port create m2fixsms_$k m2fixsms.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_mosms[j]} ${nbms_mosms[j]}" >> reg_a_Mx20Aflex${l}
		echo >> reg_a_Mx20Aflex${l}
		let j=j+1
	done
	
	let i=i+1
done


