#!/bin/bash
set -x
echo > 1.txt
i=0
while [ $i -le 181 ]
do
	echo $i >> 1.txt
	echo >> 1.txt
	let i=i+1
done
