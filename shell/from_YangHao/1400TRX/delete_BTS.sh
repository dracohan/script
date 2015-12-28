#!/bin/bash
cat /dev/null > tmp.txt
i=141
while [ $i -le 219 ]
do
	if [ $i -eq 146 ]
	then
		let i=155
	elif [ $i -eq 165 ]
	then
		let i=170
	elif [ $i -eq 191 ]
	then
		let i=193
	elif [ $i -eq 202 ]
	then
		let i=205
	else
		echo ""
	fi
	echo $i
	echo -e "Cmd_Start\t0\t'SBL DISABLE'\t'SBL DISABLE'\t'SBL'\t'BTS'\t'${i}'\t'OML'\t'1'\t'255'\t'0'\tCmd_End" >> tmp.txt
	echo -e "Cmd_Start\t0\t'SBL DISABLE'\t'SBL DISABLE'\t'SBL'\t'BTS'\t'${i}'\t'BTS_O&M'\t'1'\t'255'\t'0'\tCmd_End" >> tmp.txt
	echo -e "Cmd_Start\t0\t'SBL DISABLE'\t'SBL DISABLE'\t'SBL'\t'BTS'\t'${i}'\t'BTS_TEL'\t'1'\t'255'\t'0'\tCmd_End" >> tmp.txt
	echo -e "Cmd_Start\t0\t'SBL DISABLE'\t'SBL DISABLE'\t'SBL'\t'BTS'\t'${i}'\t'BTS_TEL'\t'2'\t'255'\t'0'\tCmd_End" >> tmp.txt
	let j=2*i-1
	echo -e "Cmd_Start\t0\t'DELETE OWN CELL'\t'DELETE OWN CELL'\t'CELL'\t'${j}'\t'149'\tCmd_End" >> tmp.txt
        let j=2*i
        echo -e "Cmd_Start\t0\t'DELETE OWN CELL'\t'DELETE OWN CELL'\t'CELL'\t'${j}'\t'149'\tCmd_End" >> tmp.txt
        echo -e "Cmd_Start\t0\t'DELETE BTS'\t'DELETE BTS'\t'BSS'\t'BSS'\t'1'\t'*****'\t'${i}'\tCmd_End" >> tmp.txt
	let i=i+1
done
