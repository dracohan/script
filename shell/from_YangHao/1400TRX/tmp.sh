#!/bin/sh
echo > tmp.txt
i=165
while [ $i -le 234 ]
do
	if [ $i -eq 170 ]
	then
		let i=220
	fi
	let j=2*i-1
	echo -e "Cmd_Start\t0\t'DELETE OWN CELL'\t'DELETE OWN CELL'\t'CELL'\t'${j}'\t'149'\tCmd_End" >> tmp.txt
	let j=2*i
	echo -e "Cmd_Start\t0\t'DELETE OWN CELL'\t'DELETE OWN CELL'\t'CELL'\t'${j}'\t'149'\tCmd_End" >> tmp.txt
	echo -e "Cmd_Start\t0\t'DELETE BTS'\t'DELETE BTS'\t'BSS'\t'BSS'\t'1'\t'*****'\t'${i}'\tCmd_End" >> tmp.txt
	let i=i+1
done
