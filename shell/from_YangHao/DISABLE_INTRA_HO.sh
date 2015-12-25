#!/bin/sh
set -x
echo "BSCSTEERFILE ABC/01A/321;" > DISABLE_INTRA_HO.STR
echo >> DISABLE_INTRA_HO.STR
num=301
while [ $num -le 500 ]
do
        echo "MODIFY R_CELL_IN TUPLE 0D${num} D_HND_PAR 0X2400  MEMDISKBACK;" >> DISABLE_INTRA_HO.STR
        let num=num+1
done



