#!/bin/sh
i=0
while [ $i -lt 216 ]
do
	if [ $i -le 9 ]
	then
		j="000"$i
	elif [ $i -le 99 ]
	then
		j="00"$i
	else
		j="0"$i
	fi
	touch /res/scc/ppu.2/${j}.0064
	let i=i+1
done
i=0
while [ $i -lt 183 ]
do
        if [ $i -le 9 ]
        then
                j="000"$i
        elif [ $i -le 99 ]
        then
                j="00"$i
        else
                j="0"$i
        fi
        touch /res/scc/ppu.1/${j}.0064
        let i=i+1
done

