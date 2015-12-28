#!/bin/sh
echo "BSCSTEERFILE ABC/01A/321;" > tmp.STR
echo >> tmp.STR
num=1
while [ $num -le 250 ]
do
	hex_num=`echo "obase=16; ${num}" | bc`
	if [ $num -le 15 ]
	then
		echo "MODIFY R_BEQ_MGT TUPLE 0D$num D_BTS_IPAD 0XAC465F0${hex_num}  MEMDISKBACK;" >> tmp.STR
	else
		echo "MODIFY R_BEQ_MGT TUPLE 0D$num D_BTS_IPAD 0XAC465F${hex_num}  MEMDISKBACK;" >> tmp.STR
	fi
	let num=num+1
done
