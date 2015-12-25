#!/bin/sh
#set -x
usage ()
{
        echo "Usage: ./updateBTSVersion oldVersion newVersion"
}
if [ $# -ne 2 ]
then
        echo "Invalid number of parameters!"
        usage
        exit 1
fi
oldVer=$1
newVer=$2
num=9
while [ $num -le 16 ]
do
        sed -i "s/${oldVer}/${newVer}/g" /home/mx20a_eth${num}/user/om/Abis_DbBTS_${num}.csv
        let num=num+1
done
