#!/bin/sh
set -x
echo "BSCSTEERFILE ABC/01A/321;" > MODIFY_CONCENTRIC_MS_PW.STR
echo >> MODIFY_CONCENTRIC_MS_PW.STR
num=301
while [ $num -le 500 ]
do
        echo "MODIFY R_NPREP_PA TUPLE 0D${num} D_MSTXP_MX 0X06  MEMDISKBACK;" >> MODIFY_CONCENTRIC_MS_PW.STR
        let num=num+1
done

num=301
while [ $num -le 500 ]
do
        echo "MODIFY R_NPREP_PA TUPLE 0D${num} D_MS_PW_IN 0X01  MEMDISKBACK;" >> MODIFY_CONCENTRIC_MS_PW.STR
        let num=num+1
done
