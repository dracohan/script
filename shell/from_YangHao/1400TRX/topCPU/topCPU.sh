#!/bin/sh


###################################################################################
#                                                                                 #
# Module :  CPULoad.sh                                                            #
#                                                                                 #
# Description : Launch mxCPU on all boards                                        #
#                                                                                 #
#                                                                                 #
# Author : Ch. Lejeune (TLO)                                                      #
#                                                                                 #
#  Date        Author            Description                                      #
# -----------  ----------------  ------------------------------------------------ #
#  2007/09/04  Ch. Lejeune       Creation                                         #
#  2008/06/12  Zhou Zheheng      Add PQ2 measurement                              #
#                                                                                 #
###################################################################################


#######
# usage
#set -x
usage() {
	echo -e "\nUsage: topCPULoad.sh <para1>"
	echo -e "<para1>: Duration in minutes\n"
	exit 1
}


getLogFile() {
	case $1 in
		OMCP1) logFile=top_omcp1.log;;
		OMCP2) logFile=top_omcp2.log;;
		CCP5) logFile=top_ccp5.log;;
		CCP6) logFile=top_ccp6.log;;
		CCP7) logFile=top_ccp7.log;;
		CCP8) logFile=top_ccp8.log;;
		CCP9) logFile=top_ccp9.log;;
		CCP10) logFile=top_ccp10.log;;
		CCP12) logFile=top_ccp12.log;;
		CCP14) logFile=top_ccp14.log;;
		TP_GSM11) logFile=top_tp2.log;;
		TP_GSM13) logFile=top_tp1.log;;
    	*) ;;
	esac
}


#######
# main

if [[ `echo $TYPE_BLADE` != "OMCP" ]]; then
	echo -e "\nThis script must be launched on OMCP Board."
	exit 1
fi

if [ $# -ne 1 ]; then
	usage
else
	duration_min="$1"
	duration_sec=`expr $1 \* 60`
	interval=5
	duration_times=`expr ${duration_sec} / ${interval}`
fi

for type in OMCP1 OMCP2 CCP5 CCP6 CCP7 CCP8 CCP9 CCP10 CCP12 CCP14 TP_GSM11 TP_GSM13
do
	rack=`cat /root/topologie.txt | grep $type | awk '{ print $1 }' | cut -d'.' -f1`
	shelf=`cat /root/topologie.txt | grep $type | awk '{ print $1 }' | cut -d'.' -f2`
	slot=`cat /root/topologie.txt | grep $type | awk '{ print $1 }' | cut -d'.' -f3`
	front=`cat /root/topologie.txt | grep $type | awk '{ print $2 }' | cut -d'.' -f3`
	phyIP=`cat /root/topologie.txt | grep $type | awk '{ print $5 }'`

	ip_status=`ping -c 4 -w 10 $phyIP | grep "4 packets transmitted, 4 received, 0% "`
	if [ "$ip_status" = "" ]; then
		echo -e "\nATCA board $type ($phyIP) is unreachable !\n"
		continue
	else
		echo -e "\nCPU Load - ATCA board $type ($phyIP)\n"
		getLogFile $type
		(ssh $phyIP "export TERM=vt100 && /usr/bin/top -d ${interval} -n ${duration_times} -b > /var/log/$logFile") & 
	fi
done

echo -e "\nWait $duration_min minutes...\n"
sleep "$duration_min"m

rm -rf /var/log/topCPULoad
mkdir /var/log/topCPULoad
for type in OMCP1 OMCP2 CCP5 CCP6 CCP7 CCP8 CCP9 CCP10 CCP12 CCP14 TP_GSM11 TP_GSM13
do
        rack=`cat /root/topologie.txt | grep $type | awk '{ print $1 }' | cut -d'.' -f1`
        shelf=`cat /root/topologie.txt | grep $type | awk '{ print $1 }' | cut -d'.' -f2`
        slot=`cat /root/topologie.txt | grep $type | awk '{ print $1 }' | cut -d'.' -f3`
        front=`cat /root/topologie.txt | grep $type | awk '{ print $2 }' | cut -d'.' -f3`
        phyIP=`cat /root/topologie.txt | grep $type | awk '{ print $5 }'`

        ip_status=`ping -c 4 -w 10 $phyIP | grep "4 packets transmitted, 4 received, 0% "`
        if [ "$ip_status" = "" ]; then
            echo -e "\nATCA board $type ($phyIP) is unreachable !\n"
            continue
        else
			getLogFile $type
			scp $phyIP:/var/log/$logFile /var/log/topCPULoad
	fi
done


cd /var/log/topCPULoad

cat /dev/null > avgtopcpu.txt
for type in OMCP1 OMCP2 CCP5 CCP6 CCP7 CCP8 CCP9 CCP10 CCP12 CCP14
do
	getLogFile $type
	if [ ! -f $logFile ]
	then
		continue
	fi
	
	if [ $type == "OMCP1" -o $type == "OMCP2" ]
	then
		overallCPU=`cat $logFile | awk '{if($1~/^Cpu/) print $8 }' | awk -F% '{print 100-$1}' | awk 'BEGIN{sum=0.0} {sum+=$1} END{sum=sum/NR;print sum"%"}'`
	M3UA=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^M3UA/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
	VDTC=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^VDTC/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
	VOSI=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^VOSI/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
	CMWR=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^CMWR/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
	VSYS=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^VSYS/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
		echo $type >> avgtopcpu.txt
		echo "overallCPU: ${overallCPU}" >>  avgtopcpu.txt
		echo -e "\tM3UA: ${M3UA}" >> avgtopcpu.txt
		echo -e "\tVDTC: ${VDTC}" >> avgtopcpu.txt
		echo -e "\tVOSI: ${VOSI}" >> avgtopcpu.txt
		echo -e "\tCMWR: ${CMWR}" >> avgtopcpu.txt
		echo -e "\tVSYS: ${VSYS}" >> avgtopcpu.txt
	else
                overallCPU=`cat $logFile | awk '{if($1~/^Cpu/) print $8 }' | awk -F% '{print 100-$1}' | awk 'BEGIN{sum=0.0} {sum+=$1
} END{sum=sum/NR;print sum"%"}'`
        PPDR=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^PPDR/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
        CMWR=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^CMWR/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
        VTCU=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^VTCU/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
        VDTC=`awk 'BEGIN{sum=0.0;count=0} {if($12 ~ /^VDTC/) sum+=$9} {if($1=="top") count+=1} END {print sum/count"%"}' $logFile`
              	echo $type >> avgtopcpu.txt
                echo -e "overallCPU: ${overallCPU}" >>  avgtopcpu.txt
                echo -e "\tPPDR: ${PPDR}" >> avgtopcpu.txt
                echo -e "\tCMWR: ${CMWR}" >> avgtopcpu.txt
                echo -e "\tVTCU: ${VTCU}" >> avgtopcpu.txt
                echo -e "\tVDTC: ${VDTC}" >> avgtopcpu.txt
	fi
done


tar czvf topCPULoad.tar.gz *.log avgtopcpu.txt
