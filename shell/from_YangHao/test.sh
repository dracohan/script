#!/bin/bash
set -x
echo > 1.txt
i=1
while [ $i -le 117 ]
do
	j=1
	while [ $j -le 6 ]
	do
		echo $i >> 1.txt
		let j=j+1
	done
	let i=i+1
done
