/^@define[ \t]/ {
	name = $2
	$1 = $2 = ""; sub(/^[ \t]+/, "")
	symtab[name] = $0
	next
}
{
	for (i in symtab)
		gsub("@" i "@", symtab[i])
	print
}
