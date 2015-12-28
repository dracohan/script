#!/bin/sh
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' omcp1_vmstat.log > omcp1_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' omcp2_vmstat.log > omcp2_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' ccp5_vmstat.log > ccp5_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' ccp6_vmstat.log > ccp6_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' ccp7_vmstat.log > ccp7_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' ccp8_vmstat.log > ccp8_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' ccp9_vmstat.log > ccp9_vmstat.txt
awk '{if($1~/[0-9]+/) {print $1"\t"$4"\t\t"(100-$15)}}' ccp10_vmstat.log > ccp10_vmstat.txt
