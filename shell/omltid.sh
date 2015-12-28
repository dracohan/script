#! /bin/bash

BYTES=255

function usage {
  echo "Usage: ./omltid.sh <file>"
}

if (( $# !=1 ))
  then
    usage
    exit 1
fi

FILENAME=$1

# store HEX data in _D_OML_TID
grep "D_OML_TID" $FILENAME > _D_OML_TID
awk 'BEGIN {FS = ":" } {print $2 }' _D_OML_TID > D_OML_TID
awk '{print $2$1 }' D_OML_TID > _D_OML_TID

# check OML number
bytes=`wc -l _D_OML_TID | awk '{print $1}'`
if (( $bytes != $BYTES ))
  then
    echo "Only $bytes bytes but should be $BYTES bytes"
    exit 1
fi

# convert from HEX to DEC
cat _D_OML_TID | 
(
    if [ -e output.txt ]
    then
        rm output.txt
    fi

    while read line
    do
        let "dline = 16#${line}"
        echo $dline >> output.txt 
        echo >> output.txt 
    done
)

if [ -e D_OML_TID ]
then
    rm D_OML_TID
fi

if [ -e _D_OML_TID ]
then
    rm _D_OML_TID
fi
