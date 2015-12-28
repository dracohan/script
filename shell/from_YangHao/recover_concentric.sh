#!/bin/bash
set -x
echo "BSCSTEERFILE ABC/01A/321;" > tmp.STR
echo >> tmp.STR
num=301
while [ $num -le 500 ]
do
	echo "MODIFY R_CELL_MGT TUPLE 0D$num D_CELL_CNF 0X02 MEMDISKBACK;" >> tmp.STR
	let num=num+1
done

num=601
while [ $num -le 1000 ]
do
	i=`expr $num % 2`
	if [ $i -eq 0 ]
	then
		echo "MODIFY R_TRX_MGT TUPLE 0D$num D_ZONE_TYP 0X01 MEMDISKBACK;" >> tmp.STR
	else
		echo "MODIFY R_TRX_MGT TUPLE 0D$num D_ZONE_TYP 0X00 MEMDISKBACK;" >> tmp.STR
	fi
	let num=num+1
done

while [ $num -le 1400 ]
do
        i=`expr $num % 2`
        if [ $i -eq 0 ]
        then
                echo "MODIFY R_TRX_MGT TUPLE 0D$num D_ZONE_TYP 0X00 MEMDISKBACK;" >> tmp.STR 
        else
                echo "MODIFY R_TRX_MGT TUPLE 0D$num D_ZONE_TYP 0X01 MEMDISKBACK;" >> tmp.STR
        fi
        let num=num+1
done 
