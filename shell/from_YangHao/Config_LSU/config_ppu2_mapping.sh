#!/bin/sh
set -x
TS1=13
TS2=22
TS3=31
p=1
s=0
echo > /res/switch/Connect
while [ ${p} -le 67 ]
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
	echo "PCM ${p} ${TS1} From SCC 2 ${j}.0064" >> /res/switch/Connect
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
        echo "PCM ${p} ${TS2} From SCC 2 ${j}.0064" >> /res/switch/Connect
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
        echo "PCM ${p} ${TS3} From SCC 2 ${j}.0064" >> /res/switch/Connect
	let s=s+1
	let p=p+1
done

echo "PCM 124 13 From SCC 2 0201.0064" >> /res/switch/Connect
echo "PCM 124 22 From SCC 2 0202.0064" >> /res/switch/Connect
echo "PCM 124 31 From SCC 2 0203.0064" >> /res/switch/Connect
echo "PCM 125 13 From SCC 2 0204.0064" >> /res/switch/Connect
echo "PCM 125 22 From SCC 2 0205.0064" >> /res/switch/Connect
echo "PCM 125 31 From SCC 2 0206.0064" >> /res/switch/Connect
echo "PCM 126 13 From SCC 2 0207.0064" >> /res/switch/Connect
echo "PCM 126 22 From SCC 2 0208.0064" >> /res/switch/Connect
echo "PCM 126 31 From SCC 2 0209.0064" >> /res/switch/Connect
echo "PCM 127 13 From SCC 2 0210.0064" >> /res/switch/Connect
echo "PCM 127 22 From SCC 2 0211.0064" >> /res/switch/Connect
echo "PCM 127 31 From SCC 2 0212.0064" >> /res/switch/Connect
echo "PCM 128 13 From SCC 2 0213.0064" >> /res/switch/Connect
echo "PCM 128 22 From SCC 2 0214.0064" >> /res/switch/Connect
echo "PCM 128 31 From SCC 2 0215.0064" >> /res/switch/Connect


p=1
s=0
while [ ${p} -le 67 ]
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
	echo "SCC 2 ${j}.0064 From PCM ${p} ${TS1}" >> /res/switch/Connect
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
	echo "SCC 2 ${j}.0064 From PCM ${p} ${TS2}" >> /res/switch/Connect
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
	echo "SCC 2 ${j}.0064 From PCM ${p} ${TS3}" >> /res/switch/Connect
	let s=s+1
        let p=p+1
done


echo "SCC 2 0201.0064 From PCM 124 13" >> /res/switch/Connect
echo "SCC 2 0202.0064 From PCM 124 22" >> /res/switch/Connect
echo "SCC 2 0203.0064 From PCM 124 31" >> /res/switch/Connect
echo "SCC 2 0204.0064 From PCM 125 13" >> /res/switch/Connect
echo "SCC 2 0205.0064 From PCM 125 22" >> /res/switch/Connect
echo "SCC 2 0206.0064 From PCM 125 31" >> /res/switch/Connect
echo "SCC 2 0207.0064 From PCM 126 13" >> /res/switch/Connect
echo "SCC 2 0208.0064 From PCM 126 22" >> /res/switch/Connect
echo "SCC 2 0209.0064 From PCM 126 31" >> /res/switch/Connect
echo "SCC 2 0210.0064 From PCM 127 13" >> /res/switch/Connect
echo "SCC 2 0211.0064 From PCM 127 22" >> /res/switch/Connect
echo "SCC 2 0212.0064 From PCM 127 31" >> /res/switch/Connect
echo "SCC 2 0213.0064 From PCM 128 13" >> /res/switch/Connect
echo "SCC 2 0214.0064 From PCM 128 22" >> /res/switch/Connect
echo "SCC 2 0215.0064 From PCM 128 31" >> /res/switch/Connect







