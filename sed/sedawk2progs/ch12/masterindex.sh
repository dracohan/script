#! /bin/sh
# 1.1 -- 7/9/90
MASTER=""
FILES=""
PAGE=""
FORMAT=1
INDEXDIR=/work/sedawk/awk/index
#INDEXDIR=/work/index
INDEXMACDIR=/work/macros/current
# Add check that all dependent modules are available.
sectNumber=1
useNumber=1
while [ "$#" != "0" ]; do
   case $1 in
	-m*)	MASTER="TRUE";;
	[1-9])	sectNumber=$1;;
	*,*) 	sectNames=$1; useNumber=0;;
	-p*)	PAGE="TRUE";;
	-s*)	FORMAT=0;;
	-*)	echo $1 " is not a valid argument";;
	*)	if [ -f $1 ]; then
			FILES="$FILES $1"
		else 
			echo "$1: file not found"
		fi;;
   esac
   shift
done
if [ "$FILES" = "" ]; then
	echo "Please supply a valid filename."
	exit
fi
if [ "$MASTER" != "" ]; then
	for x in $FILES
	do
	if [ "$useNumber" != 0 ]; then
		romaNum=`$INDEXDIR/romanum $sectNumber`
		awk '-F\t' '
			NF == 1 { print $0 } 
			NF > 1 { print $0 ":" volume }
		' volume=$romaNum $x >>/tmp/index$$ 
		sectNumber=`expr $sectNumber + 1`
	else
		awk '-F\t' '
			NR==1 { split(namelist, names, ","); 
			volname=names[volume]}
			NF == 1 { print $0 } 
			NF > 1 { print $0 ":" volname }
		' volume=$sectNumber namelist=$sectNames $x >>/tmp/index$$ 
		sectNumber=`expr $sectNumber + 1`
	fi
	done 
	FILES="/tmp/index$$"
fi
if [ "$PAGE" != "" ]; then
	$INDEXDIR/page.idx $FILES
	exit
fi
$INDEXDIR/input.idx $FILES | 
sort -bdf -t:  +0 -1 +1 -2 +3 -4 +2n -3n | uniq | 
$INDEXDIR/pagenums.idx | 
$INDEXDIR/combine.idx | 
$INDEXDIR/format.idx FMT=$FORMAT MACDIR=$INDEXMACDIR
if [ -s "/tmp/index$$" ]; then
	rm /tmp/index$$
fi
