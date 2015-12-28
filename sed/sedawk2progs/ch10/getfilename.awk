# getFilename function -- prompts user for filename,
#   verifies that file exists and returns absolute pathname. 
function getFilename(	file) { 
    while (! file) {
	printf "Enter a filename: "
	getline < "-" # get response
	file = $0
	# check that file exists and is readable
	# test returns 1 if file does not exist.
	if (system("test -r " file)) {
		print file " not found"
		file = ""
	}
    }
    if (file !~ /^\//) {
	"pwd" | getline # get current directory 
 	close("pwd")
	file = $0 "/" file
    }
    return file
}
