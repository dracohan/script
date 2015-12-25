#!/bin/sh
DEFA="PMRES110."
DEFB=".1.ATCA24_LOAD.2010-09-22.08_04_51.6624.236"

for i in `ls PMRES???.???`; do
	echo $i
	NEW=`echo $i | sed "s/PMRES....\(...\)/$DEFA\1$DEFB/g"`
	mv $i $NEW
done
