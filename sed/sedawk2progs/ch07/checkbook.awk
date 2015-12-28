# checkbook.awk
BEGIN { FS = "\t" }
#1 Expect the first record to have the starting balance.
NR == 1 { print "Beginning Balance: \t" $1
	balance = $1
	next		# get next record and start over
}
#2 Apply to each check record, subtracting amount from balance.
{	print $1, $2, $3
	print balance -= $3
}
