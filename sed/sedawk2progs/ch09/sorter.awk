# sorter.awk -- sort list of related commands
# requires sort.awk as function in separate file
BEGIN { relcmds = 0 } 

#1 Match related commands; enable flag x 
/\.SH "Related Commands"/ {
	print
	relcmds = 1
	next
}

#2 Apply to lines following "Related Commands" 
(relcmds == 1) {
	commandList = commandList $0
}

#3 Print all other lines, as is.
(relcmds == 0) { print }

#4 now sort and output list of commands 
END {
# remove leading blanks and final period.
	gsub(/, */, ",", commandList)
	gsub(/\. *$/, "", commandList)
# split list into array
	sizeOfArray = split(commandList, comArray, ",")
# sort
	sort(comArray, sizeOfArray)
# output elements
	for (i = 1; i < sizeOfArray; i++)
		printf("%s,\n", comArray[i])  
	printf("%s.\n", comArray[i])
}
