#!/bin/sh
echo CLEAN > /res/.Command
i=1
while [ $i -le 128 ]
do
	if [ $i -le 9 ]
	then
		j="00"$i
	elif [ $i -le 99 ]
	then
		j="0"$i
	else
		j=$i
	fi
	touch /res/pcm/cfg/${j}.E1
	let i=i+1
done
