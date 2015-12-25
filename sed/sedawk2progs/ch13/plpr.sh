#!/bin/sh
#
#set up temp file
TMP=/tmp/printsum.$$
LASERWRITER=${LASERWRITER-ps6}
#Check to see if the default printer is free?
#
#
FREE=`lpq -P$LASERWRITER | awk '
{ if ($0 == "no entries") 
  {
	val=1
	print val
	exit 0
  }
  else
  {
	val=0
	print val
	exit 0
  }
}'`
#echo Free is $FREE
#
#If the default is free then $FREE is set, and we print and exit.
#
if [ $FREE -eq 1 ] 
then
	SELECT=$LASERWRITER
#echo selected $SELECT
	lpr -P$SELECT $*
	exit 0
fi
#echo Past the exit
#
#Now we go on to see if any of the printers in bank are free.  
#
BANK=${BANK-$LASERWRITER}
#echo bank is $BANK
#
#If BANK is the same as LASERWRITER, then we have no choice.
#otherwise, we print on the one that is free, if any are free.
#
if [ "$BANK" =  "$LASERWRITER" ] 
then
	SELECT=$LASERWRITER
	lpr -P$SELECT $*
	exit 0
fi
#echo past the check bank=laserprinter
#
#Now we check for a free printer.
#Note that $LASERWRITER is checked again in case it becomes free
#during the check.
#
#echo now we check the other for a free one
for i in $BANK $LASERWRITER
do
FREE=`lpq -P$i | awk '
{ if ($0 == "no entries") 
  {
	val=1
	print val
	exit 0
  }
  else
  {
	val=0
	print val
	exit 0
  }
}'`
if [ $FREE -eq 1 ]
then
#   echo in loop for $i
	SELECT=$i
#   echo select is $SELECT
#   if [ "$FREE" != "$LASERWRITER" ]
#   then
#          echo "Output redirected to printer $i"
#   fi
	lpr -P$SELECT $*
	exit 0
fi
done
#echo done checking for a free one
# 
#If we make it here then no printers are free.  So we 
#print on the printer with the least bytes queued.
#
#
for i in $BANK $LASERWRITER
do
val=`lpq -P$i | awk ' BEGIN {
	start=0;
}
/^Time/ {
	start=1; 
	next;
}
(start == 1){
	test=substr($0,62,20);
	print test;
} ' | awk '
BEGIN {
	summ=0;
}
{
	summ=summ+$1;
}
END {
	print summ;
}'`
echo "$i $val" >> $TMP
done

SELECT=`awk '(NR==1) {
	select=$1;
	best=$2
}
($2 < best) {
	select=$1; 
	best=$2} 
END {
	print select
}
' $TMP `
#echo $SELECT
#
rm $TMP
#Now print on the selected printer
#if [ $SELECT != $LASERWRITER ]
#then
#   echo "Output redirected to printer $i"
#fi
lpr -P$SELECT $*
trap 'rm -f $TMP; exit 99' 2 3 15
