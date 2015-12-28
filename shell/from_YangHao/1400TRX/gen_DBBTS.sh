#!/bin/sh
cat /dev/null > Abis_DbBTS.csv
i=1
while [ $i -le 250 ]
do
	echo "Value,${i},${i},BMOSALA2.02A,,4,ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,tdm,," >> Abis_DbBTS.csv
	let i=i+1
done
