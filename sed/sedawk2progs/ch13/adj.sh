#! /bin/sh
#
# adj - adjust text lines
#
# usage: adj [-l|c|r|b] [-w n] [-i n] [files ...]
#
# options:
#    -l    - lines are left adjusted, right ragged (default)
#    -c    - lines are centered
#    -r    - lines are right adjusted, left ragged
#    -b    - lines are left and right adjusted
#    -w n  - sets line width to <n> characters (default: 70)
#    -i n  - sets initial indent to <n> characters (default: 0)
#
# note:
#    output line width is -w setting plus -i setting
#
# author:
#    Norman Joseph (amanue!oglvee!norm)

adj=l
wid=70
ind=0

set -- `getopt lcrbw:i: $*`
if test $? != 0
then
    printf 'usage: %s [-l|c|r|b] [-w n] [-i n] [files ...]' $0
    exit 1
fi

for arg in $*
do
    case $arg in
    -l) adj=l;  shift;;
    -c) adj=c;  shift;;
    -r) adj=r;  shift;;
    -b) adj=b;  shift;;
    -w) wid=$2;  shift 2;;
    -i) ind=$2;  shift 2;;
    --) shift;  break;;
    esac
done

exec nawk -f adj.nawk type=$adj linelen=$wid indent=$ind $*
