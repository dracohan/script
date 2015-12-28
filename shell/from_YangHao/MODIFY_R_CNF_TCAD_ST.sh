#!/bin/sh
#set -x
echo "BSCSTEERFILE ABC/01A/321;" > MODIFY_R_CNF_TCAD_ST.STR
echo >> MODIFY_R_CNF_TCAD_ST.STR
num=1
while [ $num -le 120 ]
do
        echo "MODIFY R_CNF_TCAD TUPLE 0D${num} D_TCAD_ST 0X09  MEMDISKBACK;" >> MODIFY_R_CNF_TCAD_ST.STR
        let num=num+1
done

num=233
while [ $num -le 304 ]
do
        echo "MODIFY R_CNF_TCAD TUPLE 0D${num} D_TCAD_ST 0X09  MEMDISKBACK;" >> MODIFY_R_CNF_TCAD_ST.STR
        let num=num+1
done

