#!/bin/sh

for btsid in 2 3 4 5 6 7 8 9 10 11 12 
do
	#echo $btsid
	grep ,"$btsid"_1, Nom4500_ETH_Abis_MsDb_Mx10A.csv | cut -d ',' -f3 >> tmsi.log
	grep ,"$btsid"_2, Nom4500_ETH_Abis_MsDb_Mx10A.csv | cut -d ',' -f3 >> tmsi.log
done

#if [ "1" == "0" ]; then

cp gen_A_Cn_MsDb_Prisma_Test.csv.tdm old

cat tmsi.log |
(
while read line
do 
	#echo $line
	sed '/'$line'/ s/2901230200222024000421/8901830200828084000481/' old >gen_A_Cn_MsDb_Prisma_Test.csv.mix
	cp gen_A_Cn_MsDb_Prisma_Test.csv.mix old
	#sed '/$line/ s/2901230200222024000421/8901830200828084000481/' gen_A_Cn_MsDb_Prisma_Test.csv.mix.tmp > gen_A_Cn_MsDb_Prisma_Test.csv.mix.tmp.new
done
)
rm tmsi.log old
#fi
