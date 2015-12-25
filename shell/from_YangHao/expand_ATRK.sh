#!/bin/sh
echo "BSCSTEERFILE ABC/01A/321;" > tmp.STR
echo >> tmp.STR
num=31
while [ $num -le 58 ]
do
	echo "MODIFY R_CNF_ATTP TUPLE 0D$num D_CS_CAP 0X01  MEMDISKBACK;" >> tmp.STR
	let num=num+1
done

num=31
while [ $num -le 58 ]
do
        echo "MODIFY R_TRAU_CP TUPLE 0D$num D_TRAU_ST 0X00  MEMDISKBACK;" >> tmp.STR
        let num=num+1
done

num=31
while [ $num -le 58 ]
do
        echo "MODIFY R_ATER_INF TUPLE 0D$num D_CS_GPRS 0X01  MEMDISKBACK;" >> tmp.STR
        let num=num+1
done

num=31
while [ $num -le 58 ]
do
        echo "MODIFY R_CS_MUX TUPLE 0D$num D_CSMUX_ST 0X00  MEMDISKBACK;" >> tmp.STR
        let num=num+1
done

num=121
while [ $num -le 240 ]
do
        echo "MODIFY R_CNF_TC16 TUPLE 0D$num D_TC_TS_ST 0X0F0000000000000000000000000000000F000000000000000000000000000000  MEMDISKBACK;" >> tmp.STR
        let num=num+1
done


num=121
while [ $num -le 240 ]
do
        echo "MODIFY R_CONF_TRK TUPLE 0D$num D_TRK_STAT 0X00  MEMDISKBACK;" >> tmp.STR
        let num=num+1
done

