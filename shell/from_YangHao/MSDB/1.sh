#!/bin/bash
i=1
declare -a pool_bsic
for bsic in `awk '{if($4~/[0-9]+/) {print $4, $5}}' configuration.txt | uniq | awk '{print $2}'`
do
	pool_bsic[$i]=$bsic
	let i=i+1
done
echo "${pool_bsic[@]}"
