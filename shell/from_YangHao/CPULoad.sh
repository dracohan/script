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
usage() {
	echo -e "\nUsage: CPULoad.sh <para1>"
	echo -e "<para1>: Duration in minutes\n"
	exit 1
}


getLogFile() {
	case $1 in
		OMCP1) logFile=omcp1.log;;
		OMCP2) logFile=omcp2.log;;
		CCP5) logFile=ccp5.log;;
		CCP6) logFile=ccp6.log;;
		CCP7) logFile=ccp7.log;;
		CCP8) logFile=ccp8.log;;
		CCP9) logFile=ccp9.log;;
		CCP10) logFile=ccp10.log;;
		TP_GSM11) logFile=tp2.log;;
		TP_GSM13) logFile=tp1.log;;
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
fi

for type in OMCP1 OMCP2 CCP5 CCP6 CCP7 CCP8 CCP9 CCP10 TP_GSM11 TP_GSM13
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
		(ssh $phyIP "/usr/local/pms/bin/mxCPU 1 $duration_sec > /var/log/$logFile") &
		if [[ "$type" = "TP_GSM11" || "$type" = "TP_GSM13" ]]; then
			(ssh $phyIP "/usr/local/tpgsm/tools/pq2_audit load > /var/log/pq2_$logFile") &
		fi
	fi
done

echo -e "\nWait $duration_min minutes...\n"
sleep "$duration_min"m

rm -rf /var/log/CPULoad
mkdir /var/log/CPULoad
echo -e "\nATCA board - CPU Load" > /var/log/CPULoad/cpuLoad.avg
for type in OMCP1 OMCP2 CCP5 CCP6 CCP7 CCP8 CCP9 CCP10 TP_GSM11 TP_GSM13
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
			scp $phyIP:/var/log/$logFile /var/log/CPULoad
			if [[ "$type" = "TP_GSM11" || "$type" = "TP_GSM13" ]]; then
				scp $phyIP:/var/log/pq2_$logFile /var/log/CPULoad
			fi
		fi
done

aveoutput=`/root/proccpu.sh`
echo -e "\n$aveoutput\n"
echo -e "\n$aveoutput" >> /var/log/CPULoad/cpuLoad.avg

cd /var/log/CPULoad
tar czvf CPULoad.tar.gz *.log cpuLoad.avg
