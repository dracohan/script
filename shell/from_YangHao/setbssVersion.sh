#!/bin/sh
num=9
while [ $num -le 16 ]
do
        sed -i 's/B11/B12/g' /home/mx20a_eth${num}/user/Nom4500_ETH_Mx10A_${num}.tsm
        let num=num+1
done
