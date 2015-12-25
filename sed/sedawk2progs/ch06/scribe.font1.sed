# Scribe font change script.
s/@f1(\([^)]*\))/\\fB\1\\fR/g
/@f1(.*/{
	N
	s/@f1(\(.*\n[^)]*\))/\\fB\1\\fR/g
	P
	D
}
