#!/bin/sh  
for filename in `find ./ -type f -name "*.txt"|head -n 2`  
do  
sed -n '1p' $filename>>new  
#echo $filename
done 
