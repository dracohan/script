#!/bin/bash
#set -x
PREFIX_MOC=1
PREFIX_MTC=2
PREFIX_TOPSTN=3
PREFIX_LU=4
PREFIX_MTSMS=5
PREFIX_MOSMS=6
NbMSPerTRX_MOC=4
NbMSPerTRX_MTC=4
NbMSPerTRX_TOPSTN=2
NbMSPerTRX_LU=2
NbMSPerTRX_MTSMS=3
NbMSPerTRX_MOSMS=3
Erlang_Per_TRX=4.5
Duration=50
MOC_MS_Ratio=0.4
MOC_FIX_Ratio=0.2
LU_Ratio=4
MOC_SMS_Ratio=0.3
MTC_SMS_Ratio=0.7

HOST_A=tstm95
PORT_AUSER_CORE=8016


declare -a cell_bts
declare -a cell_name
declare -a cell_nbTRX
declare -a cell_pool
i=1
for bts in `awk '{if($1~/^[0-9]+$/) {print $1}}' configuration.txt`
do
	cell_bts[$i]=$bts
	let i=i+1
done
#echo "${cell_bts[@]}"

i=1
for name in `awk '{if($2~/[0-9]/) {print $2}}' configuration.txt`
do
        cell_name[$i]=$name
        let i=i+1
done
#echo "${cell_name[@]}"

i=1
for trx in `awk '{if($3~/[0-9]/) {print $3}}' configuration.txt`
do
        cell_nbTRX[$i]=$trx
        let i=i+1
done
#echo "${cell_nbTRX[@]}"

i=1
for pool in `awk '{if($4~/[0-9]/) {print $4}}' configuration.txt`
do
        cell_pool[$i]=$pool
        let i=i+1
done
#echo "${cell_pool[@]}"

nbCell=${#cell_pool[@]}
#echo $nbCell
declare -a pool_startcell
i=1
j=1
while [ $j -le $nbCell ]
do
	let pool=cell_pool[$j]
	if [ $pool -eq $i ]
	then
		pool_startcell[$i]=$j
		let i=i+1
	fi
	let j=j+1
done

#echo "${pool_startcell[@]}"

nbPool=${#pool_startcell[@]}
#echo $nbPool
declare -a pool_endcell
i=1
while [ $i -lt $nbPool ]
do
	let pool_endcell[$i]=pool_startcell[$i+1]-1
	let i=i+1
done
#pool_endcell[$nbPool]=$nbCell

i=1
declare -a pool_bsic
for bsic in `awk '{if($4~/[0-9]+/) {print $4, $5}}' configuration.txt | uniq | awk '{print $2}'`
do
        pool_bsic[$i]=$bsic
        let i=i+1
done

#echo "${pool_endcell[@]}"

i=1
declare -a pool_nbTRX
while [ $i -le $nbPool ]
do
	pool_nbTRX[$i]=`awk 'BEGIN{sum=0} {if($4=='"$i"') {sum+=$3}} END{print sum}' configuration.txt`
	let i=i+1
done
echo "Number of TRXs contained in each pool:"
echo "${pool_nbTRX[@]}"


i=1
declare -a pool_nbCELL
while [ $i -le $nbPool ]
do
        pool_nbCELL[$i]=`awk 'BEGIN{sum=0} {if($4=='"$i"') {sum+=1}} END{print sum}' configuration.txt`
        let i=i+1
done
echo "Number of CELLs contained in each pool:"
echo "${pool_nbCELL[@]}"

i=1
declare -a tstm_host
for host in `awk '{if($1~/^[0-9]+$/) {print $2}}' abis_tstm.txt`
do
	tstm_host[$i]=$host
	let i=i+1
done
#echo "${tstm_host[@]}"

i=1
declare -a tstm_port
for port in `awk '{if($1~/^[0-9]+$/) {print $3}}' abis_tstm.txt`
do
        tstm_port[$i]=$port
        let i=i+1
done
#echo "${tstm_port[@]}"

i=1
declare -a tstm_dir
for dir in `awk '{if($1~/^[0-9]+$/) {print $4}}' abis_tstm.txt`
do
        tstm_dir[$i]=$dir
        let i=i+1
done
#echo "${tstm_dir[@]}"



i=1
declare -a pool_tstm
for tstm in `awk '{if($1~/[0-9]+/) print}' abis_pool_tstm_mapping.txt | sort -n | awk '{print $2}'`
do
	pool_tstm[$i]=$tstm
	let i=i+1
done
#echo "${pool_tstm[@]}"

total_nbTRX=`awk 'BEGIN{sum=0} {if($3~/[0-9]+/) sum+=$3} END {print sum}' configuration.txt`
total_nbMS_per_TRX=`expr ${NbMSPerTRX_MOC} + ${NbMSPerTRX_MTC} + ${NbMSPerTRX_TOPSTN} + ${NbMSPerTRX_LU} + ${NbMSPerTRX_MTSMS} + ${NbMSPerTRX_MOSMS}`
total_nbMS=`expr ${total_nbMS_per_TRX} \* ${total_nbTRX}`
echo "total_nbTRX: ${total_nbTRX}"
echo "total_nbMS_per_TRX: ${total_nbMS_per_TRX}"
echo "total_nbMS: ${total_nbMS}"
let START_MS_M2MC_MOC=1
let START_MS_M2MC_MTC=NbMSPerTRX_MOC*total_nbTRX+1
let START_MS_M2FIX=START_MS_M2MC_MTC+NbMSPerTRX_MTC*total_nbTRX
let START_MS_LU=START_MS_M2FIX+NbMSPerTRX_TOPSTN*total_nbTRX
let START_MS_MTSMS=START_MS_LU+NbMSPerTRX_LU*total_nbTRX
let START_MS_MOSMS=START_MS_MTSMS+NbMSPerTRX_MTSMS*total_nbTRX
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
let nbms_m2mc_moc[1]=pool_nbTRX[1]*NbMSPerTRX_MOC
i=2
while [ $i -le ${nbPool} ]
do
        let nbms_m2mc_moc[i]=pool_nbTRX[i]*NbMSPerTRX_MOC
        let j=i-1
        let startms_m2mc_moc[i]=startms_m2mc_moc[j]+nbms_m2mc_moc[j]
        let i=i+1
done
echo "####################### M2MC MOC ########################"
echo ${nbms_m2mc_moc[@]}
echo ${startms_m2mc_moc[@]}


startms_m2mc_mtc[1]=$START_MS_M2MC_MTC
let nbms_m2mc_mtc[1]=pool_nbTRX[1]*NbMSPerTRX_MTC
i=2
while [ $i -le ${nbPool} ]
do
        let nbms_m2mc_mtc[i]=pool_nbTRX[i]*NbMSPerTRX_MTC
        let j=i-1
        let startms_m2mc_mtc[i]=startms_m2mc_mtc[j]+nbms_m2mc_mtc[j]
        let i=i+1
done
echo "####################### M2MC MTC ########################" 
echo ${nbms_m2mc_mtc[@]}
echo ${startms_m2mc_mtc[@]}

startms_m2fixc_moc[1]=$START_MS_M2FIX
let nbms_m2fixc_moc[1]=pool_nbTRX[1]*NbMSPerTRX_TOPSTN
i=2
while [ $i -le ${nbPool} ]
do
        let nbms_m2fixc_moc[i]=pool_nbTRX[i]*NbMSPerTRX_TOPSTN
        let j=i-1
        let startms_m2fixc_moc[i]=startms_m2fixc_moc[j]+nbms_m2fixc_moc[j]
        let i=i+1
done
echo "####################### M2FIXC MOC ########################" 
echo ${nbms_m2fixc_moc[@]}
echo ${startms_m2fixc_moc[@]}

startms_lu[1]=$START_MS_LU
let nbms_lu[1]=pool_nbTRX[1]*NbMSPerTRX_LU
i=2
while [ $i -le ${nbPool} ]
do
        let nbms_lu[i]=pool_nbTRX[i]*NbMSPerTRX_LU
        let j=i-1
        let startms_lu[i]=startms_lu[j]+nbms_lu[j]
        let i=i+1
done
echo "####################### LU ########################" 
echo ${nbms_lu[@]}
echo ${startms_lu[@]}

startms_mtsms[1]=$START_MS_MTSMS
let nbms_mtsms[1]=pool_nbTRX[1]*NbMSPerTRX_MTSMS
i=2
while [ $i -le ${nbPool} ]
do
        let nbms_mtsms[i]=pool_nbTRX[i]*NbMSPerTRX_MTSMS
        let j=i-1
        let startms_mtsms[i]=startms_mtsms[j]+nbms_mtsms[j]
        let i=i+1
done
echo "####################### MTSMS ########################" 
echo ${nbms_mtsms[@]}
echo ${startms_mtsms[@]}

startms_mosms[1]=$START_MS_MOSMS
let nbms_mosms[1]=pool_nbTRX[1]*NbMSPerTRX_MOSMS
i=2
while [ $i -le ${nbPool} ]
do
        let nbms_mosms[i]=pool_nbTRX[i]*NbMSPerTRX_MOSMS
        let j=i-1
        let startms_mosms[i]=startms_mosms[j]+nbms_mosms[j]
        let i=i+1
done
echo "####################### MOSMS ########################" 
echo ${nbms_mosms[@]}
echo ${startms_mosms[@]}


function GenerateABIS_RegScripts()
{       
        echo "Begin to generate reg sciprts ..."
        i=1 
        while [ $i -le $nbPool ]
        do
                if [ $i -le 9 ]
                then
                        j="0"$i
                else
                        j=$i
                fi
                let t=pool_tstm[$i]
                echo '#!/bin/sh' > reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create ho1_pool${i}_bsic${pool_bsic[$i]}_ncell${pool_nbCELL[$i]} mobprof_pool.tsm ${pool_nbCELL[$i]} 9000 ${pool_bsic[$i]} 0 1" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create no_ho_pool${i}_ncell${pool_nbCELL[$i]} mobprof_pool.tsm ${pool_nbCELL[$i]} 0 0 0 0" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create moc_ms_$j ms_moc.tsm Nom4500_ETH_Abis_MsDb_Mx10A ${startms_m2mc_moc[$i]} ${nbms_m2mc_moc[$i]}" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create mtc_$j ms_mtc.tsm Nom4500_ETH_Abis_MsDb_Mx10A ${startms_m2mc_mtc[$i]} ${nbms_m2mc_mtc[$i]}" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create moc_fix_$j ms_moc.tsm Nom4500_ETH_Abis_MsDb_Mx10A ${startms_m2fixc_moc[$i]} ${nbms_m2fixc_moc[$i]}" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create lu_$j ms_lu.tsm Nom4500_ETH_Abis_MsDb_Mx10A ${startms_lu[$i]} ${nbms_lu[$i]}" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create mtsms_$j ms_mtsms.tsm Nom4500_ETH_Abis_MsDb_Mx10A ${startms_mtsms[$i]} ${nbms_mtsms[$i]}" >> reg_abis_Mx10A_pool$j
                echo "remtstm_abis  ${tstm_host[$t]} ${tstm_port[$t]} create moc_sms_$j ms_mosms.tsm Nom4500_ETH_Abis_MsDb_Mx10A ${startms_mosms[$i]} ${nbms_mosms[$i]}" >> reg_abis_Mx10A_pool$j
		echo "exit" >> reg_abis_Mx10A_pool$j
                let i=i+1
        done
}      


function GenerateA_Scripts()
{
        declare -a atstm_host
        i=1
        for host in `awk '{if($2~/^[0-9]+$/) print $1}' a_tstm.txt`
        do
                atstm_host[$i]=$host
                let i=i+1
        done
        declare -a atstm_port
        i=1
        for port in `awk '{if($2~/^[0-9]+$/) print $2}' a_tstm.txt`
        do
                atstm_port[$i]=$port
                let i=i+1
        done
	declare -a atstm_dir
        i=1
        for dir in `awk '{if($2~/^[0-9]+$/) print $3}' a_tstm.txt`
        do
                atstm_dir[$i]=$dir
                let i=i+1
        done
        nb=${#atstm_host[@]}
	echo "Begin to generate A init aflex core script..."
        echo "#!/bin/sh" > init_a_Mx20Aflexcore
        echo "./remtstm_a ${HOST_A} ${PORT_AUSER_CORE} userpath /home/mx95_aoip/aflexcore/user" >> init_a_Mx20Aflexcore
        echo "./remtstm_a ${HOST_A} ${PORT_AUSER_CORE} execute aflex.tsm A_Mx10A_MultiProcess.tsm" >> init_a_Mx20Aflexcore
        echo "./remtstm_a ${HOST_A} ${PORT_AUSER_CORE} create M2MCCORE m2mc_core.tsm Nom4500_ETH_A_MsDb_Mx10A A_Mx10A_MultiProcess.tsm" >> init_a_Mx20Aflexcore

        j=1
        while [ $j -le $nbPool ]
        do
                if [ $j -le 9 ]
                then
                        k="0"$j
                else
                        k=$j
                fi
                echo "./remtstm_a ${HOST_A} ${PORT_AUSER_CORE} create FIX2SMSINTERF_${k} fix2msms_core.tsm Nom4500_ETH_A_MsDb_Mx10A ${startms_mtsms[$j]} ${nbms_mtsms[$j]} A_Mx10A_MultiProcess.tsm" >> init_a_Mx20Aflexcore
                let j=j+1
        done

	echo "Begin to generate A init scripts..."
	j=1
	while [ $j -le $nb ]
	do
		if [ $j -le 9 ]
                then
                        k="0"$j
                else
                        k=$j
                fi
		host=${atstm_host[$j]}
		port=${atstm_port[$j]}
		dir=${atstm_dir[$j]}
		num=`expr ${total_nbMS} + 2`
		echo "#!/bin/sh" > init_a_Mx20Aflex${k}
		echo "./remtstm_a ${host} ${port} userpath ${dir}/user" >> init_a_Mx20Aflex${k}
		echo "./remtstm_a ${host} ${port} exec_immediate_resp ctl/stack_a.tsm A_Mx10A_MultiProcess.tsm Nom4500_ETH_A_MsDb_Mx10A ${num}" >> init_a_Mx20Aflex${k}
		echo "exit" >> init_a_Mx20Aflex${k}
		let j=j+1
	done

	
	echo "Begin to generate A reg sciprts ..."
	i=1
	while [ $i -le $nb ]
	do
  	   	host=${atstm_host[$i]}
    	    	port=${atstm_port[$i]}
      	    	if [ $i -le 9 ]
        	then
          	      l="0"$i
        	else
          	      l=$i
        	fi
        	echo "#!/bin/sh" > reg_a_Mx20Aflex${l}
        	j=1
        	while [ $j -le $nbPool ]
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


	echo "Begin to generate A run script..."
				erl=`echo "scale=1; ${Erlang_Per_TRX}*${total_nbTRX}/${nbPool}"|bc`
				i_mtc_sms=`echo "scale=0; ${Duration}*1000/${erl}/${MTC_SMS_Ratio}"|bc`
				echo "#!/bin/sh" > run_a_Mx20Aflex
				i=1
				while [ $i -le ${nbPool} ]
        do
        	j=`printf %02d $i`
        	echo "./remtstm_a  ${HOST_A} ${PORT_AUSER_CORE} run FIX2SMSINTERF_${j} ${i_mtc_sms}" >> run_a_Mx20Aflex
        	let i=i+1
        done
        echo "exit" >> run_a_Mx20Aflex
}


function GenerateABIS_MSDB()
{
echo "Begin to generate ABIS MSDB, pls wait..."
cat /dev/null > Abis_MSDB.csv
echo "Title,MsId,IMSI,IMEI,SysInfoLAI,CellId,ClassMark1,ClassMark2,ClassMark3,BearerCap1,CcCap,MsNetCap,DRXPar,MsRadAccCap,AuthParResp,ExtAuthParResp,OwnNum,QueueId,CalledMsNum,MobilityProfile,RingTime,HoldTime,IMSI_RV,OwnNum_RV,CellId_TM,Scenario,Pool,Cell,CalledMsNum_RV,GprsAccessClass,FinalCellId,AccCtlCl,Ptmsi,SdcchHoldTime,TextMessage" >> Abis_MSDB.csv
echo "Type,Index,Key,Key,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Key,Normal,Key,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal" >> Abis_MSDB.csv
echo "Access,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only" >> Abis_MSDB.csv
#COL1 Title	
#COL2 MsId	
#COL3 IMSI	
#COL4 IMEI	
#COL5 SysInfoLAI	
#COL6 CellId	
#COL7 ClassMark1	
#COL8 ClassMark2	
#COL9 ClassMark3	
#COL10 BearerCap1	
#COL11 CcCap	
#COL12 MsNetCap	
#COL13 DRXPar	
#COL14 MsRadAccCap	
#COL15 AuthParResp	
#COL16 ExtAuthParResp	
#COL17 OwnNum	
#COL18 QueueId	
#COL19 CalledMsNum	
#COL20 MobilityProfile	
#COL21 RingTime	
#COL22 HoldTime	
#COL23 IMSI_RV	
#COL24 OwnNum_RV	
#COL25 CellId_TM	
#COL26 Scenario	
#COL27 Pool	
#COL28 Cell	
#COL29 CalledMsNum_RV	
#COL30 GprsAccessClass	
#COL31 FinalCellId	
#COL32 AccCtlCl	
#COL33 Ptmsi	
#COL34 SdcchHoldTime	
#COL35 TextMessage


######################### Create ABIS MSDB for MOC_MS Scenario #########################
i=1
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
	cell=pool_startcell[$j]
	nbTRX=cell_nbTRX[$cell]
	let times=nbTRX*${NbMSPerTRX_MOC}
	k=1
	while [ $k -le $times ]
	#while [ $k -le 1 ]
	do
		let s_cell=pool_startcell[$j]
		let e_cell=pool_endcell[$j]
		l=$s_cell
		#echo $s_cell
		#echo $e_cell
		while [ $l -le $e_cell ]
		do
			suffix=`printf %05d $m`
			Title=Value
			MsId=$i
			IMSI="999977"${PREFIX_MOC}"0000"${suffix}
			IMEI="0a00100001"${PREFIX_MOC}${suffix}
			SysInfoLAI="99f9770095"
			CellId=${cell_name[$l]}
			ClassMark1=53
			ClassMark2=530980
			ClassMark3=7033
			BearerCap1=60040208000581
			CcCap="00"
			MsNetCap="0000" 
			DRXPar="0000"   
			MsRadAccCap="00"      
			AuthParResp="00000000"      
			ExtAuthParResp=210100		
			OwnNum=816077${PREFIX_MOC}${suffix}	
			QueueId=1
			CalledMsNum=816077${PREFIX_MTC}${suffix}	
			let nbCell=e_cell-s_cell+1
			bsic=${pool_bsic[$j]}
			MobilityProfile="ho1_pool"${j}"_bsic"${bsic}"_ncell"${nbCell}
			RingTime=10000	
			HoldTime=42000	
			IMSI_RV="99977"${PREFIX_MOC}"0000"${suffix}	
			OwnNum_RV="0677"${PREFIX_MOC}${suffix}	
			CellId_TM=${cell_name[$l]}	
			Scenario="MOC"	
			Pool=$j	
			Cell="LSU_"${CellId}	
			CalledMsNum_RV="0677"${PREFIX_MTC}${suffix}	
			GprsAccessClass="A"
			FinalCellId=${cell_name[$l]}	
			AccCtlCl=512	
			Ptmsi="10"${PREFIX_MOC}${suffix}	
			SdcchHoldTime=0	
			#TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
			TextMessage=""
			echo "${Title},${MsId},${IMSI},${IMEI},${SysInfoLAI},${CellId},${ClassMark1},${ClassMark2},${ClassMark3},${BearerCap1},${CcCap},${MsNetCap},${DRXPar},${MsRadAccCap},${AuthParResp},${ExtAuthParResp},${OwnNum},${QueueId},${CalledMsNum},${MobilityProfile},${RingTime},${HoldTime},${IMSI_RV},${OwnNum_RV},${CellId_TM},${Scenario},${Pool},${Cell},${CalledMsNum_RV},${GprsAccessClass},${FinalCellId},${AccCtlCl},${Ptmsi},${SdcchHoldTime},${TextMessage}" >> Abis_MSDB.csv
			let l=l+1
			let i=i+1
			let m=m+1
		done
		let k=k+1
	done
	let j=j+1
done



j=1
m=1
while [ $j -le $nbPool ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MTC}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MTC}"0000"${suffix}
			IMEI="0a00100001"${PREFIX_MTC}${suffix}
                        SysInfoLAI="99f9770095"
                        CellId=${cell_name[$l]}
                        ClassMark1=53
                        ClassMark2=530980
                        ClassMark3=7033
                        BearerCap1=60040208000581
                        CcCap="00"
                        MsNetCap="0000"
                        DRXPar="0000"
                        MsRadAccCap="00"
                        AuthParResp="00000000"
                        ExtAuthParResp=210100
                        OwnNum=816077${PREFIX_MTC}${suffix}
                        QueueId=1
                        CalledMsNum=""
                        let nbCell=e_cell-s_cell+1
			bsic=${pool_bsic[$j]}
                        MobilityProfile="ho1_pool"${j}"_bsic"${bsic}"_ncell"${nbCell}
                        RingTime=6000
                        HoldTime=70000
                        IMSI_RV="99977"${PREFIX_MTC}"0000"${suffix}
                        OwnNum_RV="0677"${PREFIX_MTC}${suffix}
                        CellId_TM=${cell_name[$l]}
                        Scenario="MTC"
                        Pool=$j
                        Cell="LSU_"${CellId}
                        CalledMsNum_RV=""
                        GprsAccessClass="A"
                        FinalCellId=${cell_name[$l]}
                        AccCtlCl=512
                        Ptmsi="10"${PREFIX_MTC}${suffix}
                        SdcchHoldTime=0
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
                        echo "${Title},${MsId},${IMSI},${IMEI},${SysInfoLAI},${CellId},${ClassMark1},${ClassMark2},${ClassMark3},${BearerCap1},${CcCap},${MsNetCap},${DRXPar},${MsRadAccCap},${AuthParResp},${ExtAuthParResp},${OwnNum},${QueueId},${CalledMsNum},${MobilityProfile},${RingTime},${HoldTime},${IMSI_RV},${OwnNum_RV},${CellId_TM},${Scenario},${Pool},${Cell},${CalledMsNum_RV},${GprsAccessClass},${FinalCellId},${AccCtlCl},${Ptmsi},${SdcchHoldTime},${TextMessage}" >> Abis_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done


############# Abis MSDB for TOPSTN Scenario #######################
j=1
m=1
while [ $j -le $nbPool ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_TOPSTN}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_TOPSTN}"0000"${suffix}
                        SysInfoLAI="99f9770095"
			IMEI="0a00100001"${PREFIX_TOPSTN}${suffix}
                        CellId=${cell_name[$l]}
                        ClassMark1=53
                        ClassMark2=530980
                        ClassMark3=7033
                        BearerCap1=60040208000581
                        CcCap="00"
                        MsNetCap="0000"
                        DRXPar="0000"
                        MsRadAccCap="00"
                        AuthParResp="00000000"
                        ExtAuthParResp=210100
                        OwnNum=816077${PREFIX_TOPSTN}${suffix}
                        QueueId=1
                        CalledMsNum="811077"${PREFIX_TOPSTN}${suffix}
                        let nbCell=e_cell-s_cell+1
			bsic=${pool_bsic[$j]}
                        MobilityProfile="ho1_pool"${j}"_bsic"${bsic}"_ncell"${nbCell}
                        RingTime=11000
                        HoldTime=43000
                        IMSI_RV="99977"${PREFIX_TOPSTN}"0000"${suffix}
                        OwnNum_RV="0677"${PREFIX_TOPSTN}${suffix}
                        CellId_TM=${cell_name[$l]}
                        Scenario="TOPSTN"
                        Pool=$j
                        Cell="LSU_"${CellId}
                        CalledMsNum_RV="0177"${PREFIX_TOPSTN}${suffix}
                        GprsAccessClass="A"
                        FinalCellId=${cell_name[$l]}
                        AccCtlCl=512
                        Ptmsi="10"${PREFIX_TOPSTN}${suffix}
                        SdcchHoldTime=0
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
                        echo "${Title},${MsId},${IMSI},${IMEI},${SysInfoLAI},${CellId},${ClassMark1},${ClassMark2},${ClassMark3},${BearerCap1},${CcCap},${MsNetCap},${DRXPar},${MsRadAccCap},${AuthParResp},${ExtAuthParResp},${OwnNum},${QueueId},${CalledMsNum},${MobilityProfile},${RingTime},${HoldTime},${IMSI_RV},${OwnNum_RV},${CellId_TM},${Scenario},${Pool},${Cell},${CalledMsNum_RV},${GprsAccessClass},${FinalCellId},${AccCtlCl},${Ptmsi},${SdcchHoldTime},${TextMessage}" >> Abis_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done




######################### Create ABIS MSDB for LU Scenario #############################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_LU}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_LU}"0000"${suffix}
                        SysInfoLAI="99f9770095"
			IMEI="0a00100001"${PREFIX_LU}${suffix}
                        CellId=${cell_name[$l]}
                        ClassMark1=53
                        ClassMark2=530980
                        ClassMark3=7033
                        BearerCap1=60040208000581
                        CcCap="00"
                        MsNetCap="0000"
                        DRXPar="0000"
                        MsRadAccCap="00"
                        AuthParResp="00000000"
                        ExtAuthParResp=210100
                        OwnNum=816077${PREFIX_LU}${suffix}
                        QueueId=1
                        CalledMsNum=""							
                        let nbCell=e_cell-s_cell+1
			bsic=${pool_bsic[$j]}
                        MobilityProfile="no_ho_pool"${j}"_ncell"${nbCell}
                        RingTime=0
                        HoldTime=0
                        IMSI_RV="99977"${PREFIX_LU}"0000"${suffix}
                        OwnNum_RV="0677"${PREFIX_LU}${suffix}
                        CellId_TM=${cell_name[$l]}
                        Scenario="LU"
                        Pool=$j
                        Cell="LSU_"${CellId}
                        CalledMsNum_RV=""
                        GprsAccessClass="A"
                        FinalCellId=${cell_name[$l]}
                        AccCtlCl=512
                        Ptmsi="10"${PREFIX_LU}${suffix}
                        SdcchHoldTime=0
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
                        echo "${Title},${MsId},${IMSI},${IMEI},${SysInfoLAI},${CellId},${ClassMark1},${ClassMark2},${ClassMark3},${BearerCap1},${CcCap},${MsNetCap},${DRXPar},${MsRadAccCap},${AuthParResp},${ExtAuthParResp},${OwnNum},${QueueId},${CalledMsNum},${MobilityProfile},${RingTime},${HoldTime},${IMSI_RV},${OwnNum_RV},${CellId_TM},${Scenario},${Pool},${Cell},${CalledMsNum_RV},${GprsAccessClass},${FinalCellId},${AccCtlCl},${Ptmsi},${SdcchHoldTime},${TextMessage}" >> Abis_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done



############################### Create ABIS MSDB for MTSMS Scenario ##################################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MTSMS}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MTSMS}"0000"${suffix}
                        SysInfoLAI="99f9770095"
			IMEI="0a00100001"${PREFIX_MTSMS}${suffix}
                        CellId=${cell_name[$l]}
                        ClassMark1=53
                        ClassMark2=530980
                        ClassMark3=7033
                        BearerCap1=60040208000581
                        CcCap="00"
                        MsNetCap="0000"
                        DRXPar="0000"
                        MsRadAccCap="00"
                        AuthParResp="00000000"
                        ExtAuthParResp=210100
                        OwnNum=811077${PREFIX_MTSMS}${suffix}
                        QueueId=1
                        CalledMsNum=""							
                        let nbCell=e_cell-s_cell+1
			bsic=${pool_bsic[$j]}
                        MobilityProfile="no_ho_pool"${j}"_ncell"${nbCell}
                        RingTime=0
                        HoldTime=0
                        IMSI_RV="99977"${PREFIX_MTSMS}"0000"${suffix}
                        OwnNum_RV="0177"${PREFIX_MTSMS}${suffix}
                        CellId_TM=${cell_name[$l]}
                        Scenario="MTSMS"
                        Pool=$j
                        Cell="LSU_"${CellId}
                        CalledMsNum_RV=""
                        GprsAccessClass="A"
                        FinalCellId=${cell_name[$l]}
                        AccCtlCl=512
                        Ptmsi="10"${PREFIX_MTSMS}${suffix}
                        SdcchHoldTime=0
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
                        echo "${Title},${MsId},${IMSI},${IMEI},${SysInfoLAI},${CellId},${ClassMark1},${ClassMark2},${ClassMark3},${BearerCap1},${CcCap},${MsNetCap},${DRXPar},${MsRadAccCap},${AuthParResp},${ExtAuthParResp},${OwnNum},${QueueId},${CalledMsNum},${MobilityProfile},${RingTime},${HoldTime},${IMSI_RV},${OwnNum_RV},${CellId_TM},${Scenario},${Pool},${Cell},${CalledMsNum_RV},${GprsAccessClass},${FinalCellId},${AccCtlCl},${Ptmsi},${SdcchHoldTime},${TextMessage}" >> Abis_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done





############################### Create ABIS MSDB for MOSMS Scenario ##################################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MOSMS}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MOSMS}"0000"${suffix}
			IMEI="0a00100001"${PREFIX_MOSMS}${suffix}
                        SysInfoLAI="99f9770095"
                        CellId=${cell_name[$l]}
                        ClassMark1=53
                        ClassMark2=530980
                        ClassMark3=7033
                        BearerCap1=60040208000581
                        CcCap="00"
                        MsNetCap="0000"
                        DRXPar="0000"
                        MsRadAccCap="00"
                        AuthParResp="00000000"
                        ExtAuthParResp=210100
                        OwnNum=816077${PREFIX_MOSMS}${suffix}
                        QueueId=1
                        CalledMsNum="8160779"${suffix}							
                        let nbCell=e_cell-s_cell+1
			bsic=${pool_bsic[$j]}
                        MobilityProfile="no_ho_pool"${j}"_ncell"${nbCell}
                        RingTime=0
                        HoldTime=0
                        IMSI_RV="99977"${PREFIX_MOSMS}"0000"${suffix}
                        OwnNum_RV="0677"${PREFIX_MOSMS}${suffix}
                        CellId_TM=${cell_name[$l]}
                        Scenario="MOSMS"
                        Pool=$j
                        Cell="LSU_"${CellId}
                        CalledMsNum_RV="06779"${suffix}
                        GprsAccessClass="A"
                        FinalCellId=${cell_name[$l]}
                        AccCtlCl=512
                        Ptmsi="10"${PREFIX_MOSMS}${suffix}
                        SdcchHoldTime=0
                        TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        #TextMessage=""
                        echo "${Title},${MsId},${IMSI},${IMEI},${SysInfoLAI},${CellId},${ClassMark1},${ClassMark2},${ClassMark3},${BearerCap1},${CcCap},${MsNetCap},${DRXPar},${MsRadAccCap},${AuthParResp},${ExtAuthParResp},${OwnNum},${QueueId},${CalledMsNum},${MobilityProfile},${RingTime},${HoldTime},${IMSI_RV},${OwnNum_RV},${CellId_TM},${Scenario},${Pool},${Cell},${CalledMsNum_RV},${GprsAccessClass},${FinalCellId},${AccCtlCl},${Ptmsi},${SdcchHoldTime},${TextMessage}" >> Abis_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done
}


function GenerateA_MSDB()
{
echo "Begin to generate A MSDB, pls wait..."
############## Create A MSDB ###############
Title=Value	
MsId=1	
SlaveId=1	
IMSI=""	
InitialTMSI=""	
RAND="1000000000000000000000000000000"	
PermAlg=3	
CipKey=0	
CiphrRespMode=0	
OwnNum=""	
ImeiNeeded=0	
AuthNeeded=1	
SecurNeeded=1	
TmsiReallocNeeded=1	
TmsiReallocationDuringService=0	
QueueId=1	
Priority=17	
RingTime=0	
HoldTime=0	
CallingNum=""	
TextMessage=""	
LocationNeeded=0	
SdcchHoldTime=0	
GroupIdList=""	
VGCSeMLPPriorityList=""	
CallTime=""	
AoipMscPcl="8901830200828084000281"	
ResetAfterAssignmentCommand=0	
ResetAfterAssignmentComplete=0	
ResetAfterClearRequest=0	
ResetAfterInternalHoReq=0	
ResetAfterInternalHoCmd=0	
NoAnswerToClearRequest=0	
AoipTargetSpeechCodec="f366"	
AoipTargetMscPcl="8901830200828084000281"	
OACSU=0	
IntHoEnquiryAfterAssCmplt=0	
ResNotRel=0

cat /dev/null > A_MSDB.csv
echo "Title,MsId,SlaveId,IMSI,InitialTMSI,RAND,PermAlg,CipKey,CiphrRespMode,OwnNum,ImeiNeeded,AuthNeeded,SecurNeeded,TmsiReallocNeeded,TmsiReallocationDuringService,QueueId,Priority,RingTime,HoldTime,CallingNum,TextMessage,LocationNeeded,SdcchHoldTime,GroupIdList,VGCSeMLPPriorityList,CallTime,AoipMscPcl,ResetAfterAssignmentCommand,ResetAfterAssignmentComplete,ResetAfterClearRequest,ResetAfterInternalHoReq,ResetAfterInternalHoCmd,NoAnswerToClearRequest,AoipTargetSpeechCodec,AoipTargetMscPcl,OACSU,IntHoEnquiryAfterAssCmplt,ResNotRel" >> A_MSDB.csv
echo "Type,Index,Normal,Key,Key,Normal,Normal,Normal,Normal,Key,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal,Normal" >> A_MSDB.csv
echo "Access,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read_Only,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write,Read/Write" >> A_MSDB.csv
######################### Create A MSDB for MOC_MS Scenario #########################
i=1
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MOC}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MOC}"0000"${suffix}
			InitialTMSI="f"${PREFIX_MOC}"00"${suffix}
                        OwnNum=816077${PREFIX_MOC}${suffix}     
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
                        echo "${Title},${MsId},${SlaveId},${IMSI},${InitialTMSI},${RAND},${PermAlg},${CipKey},${CiphrRespMode},${OwnNum},${ImeiNeeded},${AuthNeeded},${SecurNeeded},${TmsiReallocNeeded},${TmsiReallocationDuringService},${QueueId},${Priority},${RingTime},${HoldTime},${CallingNum},${TextMessage},${LocationNeeded},${SdcchHoldTime},${GroupIdList},${VGCSeMLPPriorityList},${CallTime},${AoipMscPcl},${ResetAfterAssignmentCommand},${ResetAfterAssignmentComplete},${ResetAfterClearRequest},${ResetAfterInternalHoReq},${ResetAfterInternalHoCmd},${NoAnswerToClearRequest},${AoipTargetSpeechCodec},${AoipTargetMscPcl},${OACSU},${IntHoEnquiryAfterAssCmplt},${ResNotRel}" >> A_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done


######################### Create A MSDB for MTC Scenario #########################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MTC}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MTC}"0000"${suffix}
                        InitialTMSI="f"${PREFIX_MTC}"00"${suffix}
                        OwnNum=816077${PREFIX_MTC}${suffix}     
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
			echo "${Title},${MsId},${SlaveId},${IMSI},${InitialTMSI},${RAND},${PermAlg},${CipKey},${CiphrRespMode},${OwnNum},${ImeiNeeded},${AuthNeeded},${SecurNeeded},${TmsiReallocNeeded},${TmsiReallocationDuringService},${QueueId},${Priority},${RingTime},${HoldTime},${CallingNum},${TextMessage},${LocationNeeded},${SdcchHoldTime},${GroupIdList},${VGCSeMLPPriorityList},${CallTime},${AoipMscPcl},${ResetAfterAssignmentCommand},${ResetAfterAssignmentComplete},${ResetAfterClearRequest},${ResetAfterInternalHoReq},${ResetAfterInternalHoCmd},${NoAnswerToClearRequest},${AoipTargetSpeechCodec},${AoipTargetMscPcl},${OACSU},${IntHoEnquiryAfterAssCmplt},${ResNotRel}" >> A_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done


######################### Create A MSDB for TOPSTN Scenario #########################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_TOPSTN}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_TOPSTN}"0000"${suffix}
                        InitialTMSI="f"${PREFIX_TOPSTN}"00"${suffix}
                        OwnNum=816077${PREFIX_TOPSTN}${suffix}     
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
			RingTime=5000
			HoldTime=70000
			echo "${Title},${MsId},${SlaveId},${IMSI},${InitialTMSI},${RAND},${PermAlg},${CipKey},${CiphrRespMode},${OwnNum},${ImeiNeeded},${AuthNeeded},${SecurNeeded},${TmsiReallocNeeded},${TmsiReallocationDuringService},${QueueId},${Priority},${RingTime},${HoldTime},${CallingNum},${TextMessage},${LocationNeeded},${SdcchHoldTime},${GroupIdList},${VGCSeMLPPriorityList},${CallTime},${AoipMscPcl},${ResetAfterAssignmentCommand},${ResetAfterAssignmentComplete},${ResetAfterClearRequest},${ResetAfterInternalHoReq},${ResetAfterInternalHoCmd},${NoAnswerToClearRequest},${AoipTargetSpeechCodec},${AoipTargetMscPcl},${OACSU},${IntHoEnquiryAfterAssCmplt},${ResNotRel}" >> A_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done

RingTime=""
HoldTime=""

######################### Create A MSDB for LU Scenario #########################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_LU}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_LU}"0000"${suffix}
                        InitialTMSI="f"${PREFIX_LU}"00"${suffix}
                        OwnNum=816077${PREFIX_LU}${suffix}     
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
			echo "${Title},${MsId},${SlaveId},${IMSI},${InitialTMSI},${RAND},${PermAlg},${CipKey},${CiphrRespMode},${OwnNum},${ImeiNeeded},${AuthNeeded},${SecurNeeded},${TmsiReallocNeeded},${TmsiReallocationDuringService},${QueueId},${Priority},${RingTime},${HoldTime},${CallingNum},${TextMessage},${LocationNeeded},${SdcchHoldTime},${GroupIdList},${VGCSeMLPPriorityList},${CallTime},${AoipMscPcl},${ResetAfterAssignmentCommand},${ResetAfterAssignmentComplete},${ResetAfterClearRequest},${ResetAfterInternalHoReq},${ResetAfterInternalHoCmd},${NoAnswerToClearRequest},${AoipTargetSpeechCodec},${AoipTargetMscPcl},${OACSU},${IntHoEnquiryAfterAssCmplt},${ResNotRel}" >> A_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done



######################### Create A MSDB for MTSMS Scenario #########################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MTSMS}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MTSMS}"0000"${suffix}
                        InitialTMSI="f"${PREFIX_MTSMS}"00"${suffix}
                        OwnNum=811077${PREFIX_MTSMS}${suffix}  
			CallingNum=${OwnNum}
                        TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        #TextMessage=""
			echo "${Title},${MsId},${SlaveId},${IMSI},${InitialTMSI},${RAND},${PermAlg},${CipKey},${CiphrRespMode},${OwnNum},${ImeiNeeded},${AuthNeeded},${SecurNeeded},${TmsiReallocNeeded},${TmsiReallocationDuringService},${QueueId},${Priority},${RingTime},${HoldTime},${CallingNum},${TextMessage},${LocationNeeded},${SdcchHoldTime},${GroupIdList},${VGCSeMLPPriorityList},${CallTime},${AoipMscPcl},${ResetAfterAssignmentCommand},${ResetAfterAssignmentComplete},${ResetAfterClearRequest},${ResetAfterInternalHoReq},${ResetAfterInternalHoCmd},${NoAnswerToClearRequest},${AoipTargetSpeechCodec},${AoipTargetMscPcl},${OACSU},${IntHoEnquiryAfterAssCmplt},${ResNotRel}" >> A_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done
CallingNum=""


######################### Create A MSDB for MOSMS Scenario #########################
j=1
m=1
while [ $j -le $nbPool ]
#while [ $j -le 2 ]
do
        cell=pool_startcell[$j]
        nbTRX=cell_nbTRX[$cell]
        let times=nbTRX*${NbMSPerTRX_MOSMS}
        k=1
        while [ $k -le $times ]
        #while [ $k -le 1 ]
        do
                let s_cell=pool_startcell[$j]
                let e_cell=pool_endcell[$j]
                l=$s_cell
                #echo $s_cell
                #echo $e_cell
                while [ $l -le $e_cell ]
                do
                        suffix=`printf %05d $m`
                        Title=Value
                        MsId=$i
                        IMSI="999977"${PREFIX_MOSMS}"0000"${suffix}
                        InitialTMSI="f"${PREFIX_MOSMS}"00"${suffix}
                        OwnNum=816077${PREFIX_MOSMS}${suffix}  
                        #TextMessage="0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX"
                        TextMessage=""
			echo "${Title},${MsId},${SlaveId},${IMSI},${InitialTMSI},${RAND},${PermAlg},${CipKey},${CiphrRespMode},${OwnNum},${ImeiNeeded},${AuthNeeded},${SecurNeeded},${TmsiReallocNeeded},${TmsiReallocationDuringService},${QueueId},${Priority},${RingTime},${HoldTime},${CallingNum},${TextMessage},${LocationNeeded},${SdcchHoldTime},${GroupIdList},${VGCSeMLPPriorityList},${CallTime},${AoipMscPcl},${ResetAfterAssignmentCommand},${ResetAfterAssignmentComplete},${ResetAfterClearRequest},${ResetAfterInternalHoReq},${ResetAfterInternalHoCmd},${NoAnswerToClearRequest},${AoipTargetSpeechCodec},${AoipTargetMscPcl},${OACSU},${IntHoEnquiryAfterAssCmplt},${ResNotRel}" >> A_MSDB.csv
                        let l=l+1
                        let i=i+1
			let m=m+1
                done
                let k=k+1
        done
        let j=j+1
done

}

function GenerateABIS_startscripts()
{
	echo "Begin to generate ABIS startscripts..."
	nb=${#tstm_port[@]}
	i=1
	while [ $i -le ${nb} ]
	do
		port=${tstm_port[$i]}
		#echo $port
		echo "#!/bin/sh" > start_abis_Mx10A_${i}
		echo "#startAbisTstm -p ${port} -l AbisTstm_Mx10A_${i}.log -d edge -t 800000" >> start_abis_Mx10A_${i}
		echo "startAbisTstm -p ${port} -d edge -t 800000" >> start_abis_Mx10A_${i}
		echo "exit" >> start_abis_Mx10A_${i}
		let i=i+1
	done
}


function GenerateABIS_initscripts()
{
	echo "Begin to generate ABIS initscripts..."
        nb=${#tstm_port[@]}
        nb=${#tstm_port[@]}
        i=1
        while [ $i -le ${nb} ]
        do
                port=${tstm_port[$i]}
                host=${tstm_host[$i]}
                dir=${tstm_dir[$i]}
                echo "#!/bin/sh" > init_fullupdate_abis_Mx10A_${i}
                echo "port=${port}" >> init_fullupdate_abis_Mx10A_${i}
                echo "host=${host}" >> init_fullupdate_abis_Mx10A_${i}
                echo "remtstm_abis \$host \$port userpath ${dir}/user" >> init_fullupdate_abis_Mx10A_${i}
                echo "remtstm_abis \$host \$port execute ctl/abis_ctl.tsm Nom4500_ETH_Mx10A_${i}.tsm false" >> init_fullupdate_abis_Mx10A_${i}
                echo "exit" >> init_fullupdate_abis_Mx10A_${i}
                
                echo "#!/bin/sh" > init_abis_Mx10A_${i}
                echo "port=${port}" >> init_abis_Mx10A_${i}
                echo "host=${host}" >> init_abis_Mx10A_${i}
                echo "remtstm_abis \$host \$port userpath ${dir}/user" >> init_abis_Mx10A_${i}
                echo "remtstm_abis \$host \$port execute ctl/abis_ctl.tsm Nom4500_ETH_Mx10A_${i}.tsm true" >> init_abis_Mx10A_${i}
                echo "exit" >> init_fullupdate_abis_Mx10A_${i}
                
                let i=i+1
        done 
}

function GenerateABIS_runscripts()
{
	echo "Begin to generate ABIS runscripts..."
        i=1
        while [ $i -le ${nbPool} ]
        do
        				j=`printf "%02d" $i`
        				let t=pool_tstm[$i]
                port=${tstm_port[$t]}
                host=${tstm_host[$t]}
                let nb=pool_nbTRX[$i]
		erl=`echo "scale=1; ${Erlang_Per_TRX}*${nb}"|bc`
                i_moc_ms=`echo "scale=0; ${Duration}*1000/${erl}/${MOC_MS_Ratio}"|bc`
                i_moc_fix=`echo "scale=0; ${Duration}*1000/${erl}/${MOC_FIX_Ratio}"|bc`
                i_lu=`echo "scale=0; ${Duration}*1000/${erl}/${LU_Ratio}"|bc`
                i_moc_sms=`echo "scale=0; ${Duration}*1000/${erl}/${MOC_SMS_Ratio}"|bc`
                
                echo "#!/bin/sh" > run_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} run moc_ms_${j} ${i_moc_ms}" >> run_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} run moc_fix_${j} ${i_moc_fix}" >> run_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} run lu_${j} ${i_lu}" >> run_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} run moc_sms_${j} ${i_moc_sms}" >> run_abis_Mx10A_pool${j}
                echo "exit" >> run_abis_Mx10A_pool${j}
                
               
                let i=i+1
        done
}

function GenerateABIS_statusscripts()
{
	echo "Begin to generate ABIS statusscripts..."
        i=1
        while [ $i -le ${nbPool} ]
        do
              	j=`printf "%02d" $i`
                let t=pool_tstm[$i]
                port=${tstm_port[$t]}
                host=${tstm_host[$t]}
                echo "#!/bin/sh" > status_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} status moc_ms_${j}" >> status_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} status mtc_${j}" >> status_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} status moc_fix_${j}" >> status_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} status lu_${j}" >> status_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} status mtsms_${j}" >> status_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} status moc_sms_${j}" >> status_abis_Mx10A_pool${j}
                echo "exit" >> status_abis_Mx10A_pool${j}
                let i=i+1
        done
}

function GenerateABIS_stopscripts()
{
	echo "Begin to generate ABIS stopscripts..."
        i=1
        while [ $i -le ${nbPool} ]
        do
              	j=`printf "%02d" $i`
                let t=pool_tstm[$i]
                port=${tstm_port[$t]}
                host=${tstm_host[$t]}
                echo "#!/bin/sh" > stop_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} stop moc_ms_${j}" >> stop_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} stop moc_fix_${j}" >> stop_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} stop lu_${j}" >> stop_abis_Mx10A_pool${j}
                echo "remtstm_abis ${host} ${port} stop moc_sms_${j}" >> stop_abis_Mx10A_pool${j}
                echo "exit" >> stop_abis_Mx10A_pool${j}
                let i=i+1
        done
}

#GenerateABIS_MSDB
#GenerateA_MSDB
GenerateABIS_statusscripts
GenerateABIS_stopscripts
GenerateABIS_startscripts
GenerateABIS_initscripts
GenerateABIS_runscripts
GenerateABIS_RegScripts
GenerateA_Scripts
