#!/bin/sh
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' omcp1_mxcpu.log | uniq -W 1 > omcp1_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' omcp2_mxcpu.log | uniq -W 1 > omcp2_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' ccp5_mxcpu.log | uniq -W 1 > ccp5_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' ccp6_mxcpu.log | uniq -W 1 > ccp6_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' ccp7_mxcpu.log | uniq -W 1 > ccp7_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' ccp8_mxcpu.log | uniq -W 1 > ccp8_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' ccp9_mxcpu.log | uniq -W 1 > ccp9_mxcpu.txt
awk '{if($(NF-1)~/[0-9]+/) {print substr($1,1,5)"\t"$(NF-1)}}' ccp10_mxcpu.log | uniq -W 1 > ccp10_mxcpu.txt
