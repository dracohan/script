#!/bin/bash

File=./test.txt

{
    read line1
    read line2
} < $File

echo "First line: " 
echo "$line1"
echo 
echo "Second line: "
echo "$line2"

exit 0
