#! /bin/sh
# Copyright 1990 by EDV-Beratung Martin Weitzel, D-6100 Darmstadt
# ==================================================================
# PROJECT:	Printing Tools
# SH-SCRIPT:	Source to Troff Pre-Formatter
# ==================================================================

#!
# ------------------------------------------------------------------
# This programm is a tool to preformat source files, so that they
# can be included (.so) within nroff/troff-input. Problems when
# including arbitrary files within nroff/troff-input occur on lines,
# starting with dot (.) or an apostrophe ('), or with the respective
# chars, if these are changed, furthermore from embedded backslashes.
# While changing the source so that non of the above will cause
# any problems, some other usefull things can be done, including
# line numbering and selecting interesting parts.
# ------------------------------------------------------------------
#!
  USAGE="$0 [-x d] [-n] [-b pat] [-e pat] [-p pat] [file ...]"
#
# SYNOPSIS:
# The following options are supported:
#	-x d	expand tabs to "d" spaces
#	-n 	number source lines (see also: NFMT)
#	-b pat	start output on a line containing "pat",
#		including this line (Default: from beginning)
#	-e pat	end output on a line containing "pat"
#		excluding this line (Default: upto end)
#	-p pat	before lines containing "pat", page breaks
#		may occur (Default: no page breaks)
# "pat" may be an "extended regular expression" as supported by awk.
# The following variables from the environment are used:
#	NFMT	specify format for line numbers (Default: see below)
#	PBRK	string, to mark page breaks. (Default: see below)
#!
# PREREQUISITS:
# Common UNIX-Environment, including awk.
#
# CAVEATS:
# "pat"s are not checked before they are used (processing may have
# started, before problems are detected).
# "NFMT" must contain exactly one %d-format specifier, if -n
# option is used.
# In "NFMT" and "PBRK", embedded doublequotes must be guarded with
# a leading backslash.
# In "pat"s, "NFMT" and "PBRK" embedded TABs and NLs must be written
# as \t and \n. Backslashes that should "go thru" to the output as
# such, should be doubled. (The latter is only *required* in a few
# special cases, but it does no harm the other cases).
# 
# Must run from Bourne shell [dpd]
#!
# BUGS:
# Slow - but may serve as prototype for a faster implementation.
# (Hint: Guarding backslashes the way it is done by now is very
# expensive and could also be done using sed 's/\\/\\e/g', but tab
# expansion would be much harder then, because I can't imagine how
# to do it with sed. If you have no need for tab expansion, you may
# change the program. Another option would be to use gsub(), which
# would limit the program to environments with nawk.)
# 
# Others bugs may be, please mail me.
#!
# AUTHOR:	Martin Weitzel, D-6100 DA (martin@mwtech.UUCP)
#
# RELEASED: 	25. Nov 1989, Version 1.00
# ------------------------------------------------------------------

#! CSOPT
# ------------------------------------------------------------------
# 	check/set options
# ------------------------------------------------------------------

xtabs=0 nfmt= bpat= epat= ppat=
for p
do
case $sk in
1) shift; sk=0; continue
esac
case $p in
-x)	shift;
	case $1 in
	[1-9]|1[0-9]) xtabs=$1; sk=1;;
	*) { >&2 echo "$0: bad value for option -x: $1"; exit 1; }
	esac
	;;
-n)	nfmt="${NFMT:-<%03d>\	}"; shift ;;
-b)	shift; bpat=$1; sk=1 ;;
-e)	shift; epat=$1; sk=1 ;;
-p)	shift; ppat=$1; sk=1 ;;
--)	shift; break ;;
*)	break
esac
done

#! MPROC
# ------------------------------------------------------------------
# 	now the "real work"
# ------------------------------------------------------------------

nawk '
#. prepare for tab-expansion, page-breaks and selection
BEGIN {
	if (xt = '$xtabs') while (length(sp) < xt) sp = sp " ";
	PBRK = "'"${PBRK-'.DE\n.DS\n'}"'"
	'${bpat:+' skip = 1; '}'
}
#! limit selection range
{
	'${epat:+' if (!skip && $0 ~ /'"$epat"'/) skip = 1; '}'
	'${bpat:+' if (skip && $0 ~ /'"$bpat"'/) skip = 0; '}'
	if (skip) next;
}
#! process one line of input as required
{
	if ( xt && $0 ~ "\t" )
		gsub(/\t/, sp)
	if ($0 ~ "\\") 
		gsub(/\\/, "\\e")
}
#! finally print this line
{
	'${ppat:+' if ($0 ~ /'"$ppat"'/) printf("%s", PBRK); '}'
	'${nfmt:+' printf("'"$nfmt"'", NR) '}'
	printf("\\&%s\n", $0);
}
' $*
