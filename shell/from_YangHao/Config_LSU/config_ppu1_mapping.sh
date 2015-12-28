#!/bin/sh
set -x
TS1=13
TS2=22
TS3=31
p=68
s=0
echo > /res/switch/Connect
while [ ${p} -le 123 ]
do
	if [ $s -le 9 ]
        then
                j="000"$s
        elif [ $s -le 99 ]
        then
                j="00"$s
        else
                j="0"$s
        fi
	echo "PCM ${p} ${TS1} From SCC 1 ${j}.0064" >> /res/switch/Connect
	let s=s+1
	if [ $s -le 9 ]
        then
                j="000"$s
        elif [ $s -le 99 ]
        then
                j="00"$s
        else
                j="0"$s
        fi
        echo "PCM ${p} ${TS2} From SCC 1 ${j}.0064" >> /res/switch/Connect
        let s=s+1
        if [ $s -le 9 ]
        then
                j="000"$s
        elif [ $s -le 99 ]
        then
                j="00"$s
        else
                j="0"$s
        fi
        echo "PCM ${p} ${TS3} From SCC 1 ${j}.0064" >> /res/switch/Connect
	let s=s+1
	let p=p+1
done

p=68
s=0
while [ ${p} -le 123 ]
do
        if [ $s -le 9 ]
        then
                j="000"$s
        elif [ $s -le 99 ]
        then
                j="00"$s
        else
                j="0"$s
        fi
	echo "SCC 1 ${j}.0064 From PCM ${p} ${TS1}" >> /res/switch/Connect
        let s=s+1
        if [ $s -le 9 ]
        then
                j="000"$s
        elif [ $s -le 99 ]
        then
                j="00"$s
        else
                j="0"$s
        fi
	echo "SCC 1 ${j}.0064 From PCM ${p} ${TS2}" >> /res/switch/Connect
        let s=s+1
        if [ $s -le 9 ]
        then
                j="000"$s
        elif [ $s -le 99 ]
        then
                j="00"$s
        else
                j="0"$s
        fi
	echo "SCC 1 ${j}.0064 From PCM ${p} ${TS3}" >> /res/switch/Connect
	let s=s+1
        let p=p+1
done
