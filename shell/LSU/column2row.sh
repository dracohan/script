####################################################################
# ./column2row.sh <csv filename>
# Display column in rows
# Orginal Input:
# 	r1c1 r1c2 r1c3
# 	r2c1 r2c2 r2c3
# 	r3c1 r3c2 r3c3
# Expect Output:
#	r1c1 r2c1 r3c1
#	r1c2 r2c2 r3c2
#	r1c3 r2c3 r3c3
# 2012/11/28 version 1.0
####################################################################

#!/bin/bash 

# declare artrithm variables
declare -a lines 
declare -i columnnum=18 i=1 index=0 cutindex=1

# argument check
filename=$1
filename=${filename:?" is missing!"}

# reset the index to beginning of the row
function f_index_reset()
{
    index=0
    cutindex=1
}

# read lines from file
while read; do
    lines[$i]=$REPLY
    ((i++))
done < $filename

# assign column values to array line by line
for line in "${lines[@]}"; do
    #echo -e "Now processing line: \n$line"
    while (( $index < $columnnum )); do
	column[$index]=${column[$index]}"|""$(echo $line | cut -d\; -f $cutindex)"
	#echo -e "Now column value is ${column[$index]}"
    index=index+1
	cutindex=cutindex+1
    done
	f_index_reset
done

# display columns
if [ -e ${filename}_column ]
then
	rm ${filename}_column
fi

#for column in ${column[@]}; do
while (( $index < $columnnum )); do
	#echo -e "index $index column\[$index\] ${column[$index]}"
    echo -e "${column[$index]}" 
    ((index++))
done
