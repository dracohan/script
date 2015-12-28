# man.split -- split up a file containing X man pages. 
BEGIN { file = 0; i = 0; filename = "" }

# First line of new man page is ".nr X 0"
# Last line is blank
/^\.nr X 0/,/^$/ {
	# this conditional collects lines until we get a filename.
	if (file == 0)
		line[++i] = $0
	else
		print $0 > filename

	# this matches the line that gives us the filename
	if ($4 == "x}") {
		# now we have a filename
		filename = $5 
		file = 1
		# output name to screen 
		print filename 
		# print any lines collected
		for (x = 1; x <= i; ++x){
			print line[x] > filename
		}
		i = 0
	}

	# close up and clean up for next one
	if ($0 ~ /^$/) {
		close(filename)
		filename = ""
		file = 0
		i = 0
	}
} 
