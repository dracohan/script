#/bin/sh
ssh 172.17.3.30 "rm /root/omcp1_vmstat.log" 
ssh 172.17.3.40 "rm /root/omcp2_vmstat.log" 
ssh 172.17.3.50 "rm /root/ccp5_vmstat.log" 
ssh 172.17.3.60 "rm /root/ccp6_vmstat.log"
ssh 172.17.3.70 "rm /root/ccp7_vmstat.log"
ssh 172.17.3.80 "rm /root/ccp8_vmstat.log"
ssh 172.17.3.90 "rm /root/ccp9_vmstat.log"
ssh 172.17.3.100 "rm /root/ccp10_vmstat.log"

ssh 172.17.3.30 "vmstat 60 10000  >> /root/omcp1_vmstat.log" &
ssh 172.17.3.40 "vmstat  60 10000 >> /root/omcp2_vmstat.log" &
ssh 172.17.3.50 "vmstat  60 10000 >> /root/ccp5_vmstat.log" &
ssh 172.17.3.60 "vmstat  60 10000 >> /root/ccp6_vmstat.log" &
ssh 172.17.3.70 "vmstat  60 10000 >> /root/ccp7_vmstat.log" &
ssh 172.17.3.80 "vmstat  60 10000 >> /root/ccp8_vmstat.log" &
ssh 172.17.3.90 "vmstat  60 10000 >> /root/ccp9_vmstat.log" &
ssh 172.17.3.100 "vmstat 60 10000 >> /root/ccp10_vmstat.log" &
