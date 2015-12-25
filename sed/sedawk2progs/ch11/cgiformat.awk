# cgiformat --- process CGI logs
# data format is user:host:timestamp

#1
BEGIN {	FS = ":"; SUBSEP = "@" }

#2
{
# make data more obvious
	user = $1; host = $2; time = $3
# store first contact by this user
	if (! ((user, host) in first))
		first[user, host] = time
# count contacts
	count[user, host]++
# save last contact
	last[user, host] = time
}

#3
END {
# print the results
	for (contact in count) {
		i = strftime("%y-%m-%d %H:%M", first[contact])
		j = strftime("%y-%m-%d %H:%M", last[contact])
		printf "%s -> %d times between %s and %s\n",
			contact, count[contact], i, j
	}
}
