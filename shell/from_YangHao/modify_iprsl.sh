#!/bin/sh
echo "BSCSTEERFILE ABC/01A/321;" > tmp.STR
i=1
j=1
while [ $i -le 250 ]
do
	k=`echo "obase=16; ${i}" | bc`
	if [ $i -le 15 ]
	then
		k="0"$k
	fi
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}00C40100  MEMDISKBACK;" >> tmp.STR
	let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}01C40100  MEMDISKBACK;" >> tmp.STR
	let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}02C40100  MEMDISKBACK;" >> tmp.STR
	let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}03C40100  MEMDISKBACK;" >> tmp.STR
	let j=j+1
	let i=i+1
done
i=197
j=1001
while [ $i -le 250 ]
do
	if [ $i -eq 202 ]
	then
		let i=205
	fi
	if [ $i -eq 241 ]
	then 	
		let i=242
	fi
        k=`echo "obase=16; ${i}" | bc`
        echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}04C40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
        echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}05C40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
        echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}06C40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
        echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}07C40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}08C40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}09C40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}0AC40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
	echo "MODIFY R_RSL_LNK TUPLE 0D$j D_RSL_REP 0XAC465F${k}0BC40100  MEMDISKBACK;" >> tmp.STR
        let j=j+1
	let i=i+1
done
