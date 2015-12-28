function printerr (message) {
	# print message, record number and record
	printf("ERROR:%s (%d) %s\n", message, NR, $0) > "/dev/tty"
}
