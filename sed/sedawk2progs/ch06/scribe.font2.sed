# Scribe font change script.  New and Improved.
:begin
/@f1(\([^)]*\))/{
s//\\fB\1\\fR/g
b begin
}
/@f1(.*/{
N
s/@f1(\([^)]*\n[^)]*\))/\\fB\1\\fR/g
t again
b begin
}
:again
P
D
