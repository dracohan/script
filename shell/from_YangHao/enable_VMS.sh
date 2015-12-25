#!/bin/sh
echo "BSCSTEERFILE ABC/01A/321;" > ENABLE_VAMOS.STR
echo >> ENABLE_VAMOS.STR
num=1
while [ $num -le 500 ]
do
        echo "MODIFY R_CELL_IN TUPLE 0D${num} D_EN_VAMOS 0X01  MEMDISKBACK;" >> ENABLE_VAMOS.STR
        let num=num+1
done
