function dofile(fname) {
	while (getline <fname > 0) {
		if (/^@define[ \t]/) {		# @define name value
			name = $2
			$1 = $2 = ""; sub(/^[ \t]+/, "")
			symtab[name] = $0
		} else if (/^@include[ \t]/)	# @include filename
			dofile($2)
		else {				# Anywhere in line @name@
			for (i in symtab)
				gsub("@" i "@", symtab[i])
			print
		}
	}
	close(fname)
}

BEGIN {
	if (ARGC == 2)
		dofile(ARGV[1])
	else
		dofile("/dev/stdin")
}
