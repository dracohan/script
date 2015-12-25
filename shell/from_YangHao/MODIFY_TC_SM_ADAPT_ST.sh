#!/bin/sh
set -x
echo "BSCSTEERFILE ABC/01A/321;" > MODIFY_TC_SM_ADAPT_ST.STR
echo >> MODIFY_TC_SM_ADAPT_ST.STR
num=1
while [ $num -le 30 ]
do
        echo "MODIFY R_CNF_SMAT TUPLE 0D${num} D_SMAD_ST 0X09  MEMDISKBACK;" >> MODIFY_TC_SM_ADAPT_ST.STR
        let num=num+1
done

num=59
while [ $num -le 76 ]
do
        echo "MODIFY R_CNF_SMAT TUPLE 0D${num} D_SMAD_ST 0X09  MEMDISKBACK;" >> MODIFY_TC_SM_ADAPT_ST.STR
        let num=num+1
done


