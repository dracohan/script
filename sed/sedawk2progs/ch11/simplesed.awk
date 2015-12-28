# simplesed.awk --- do s/old/new/g using just print
#    Thanks to Michael Brennan for the idea
#
# NOTE! RS and ORS must be set on the command line

{
    if (RT == "")
        printf "%s", $0
    else
        print
}
