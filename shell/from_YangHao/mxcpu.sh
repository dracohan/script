#/bin/sh
ssh 172.17.3.30 "rm /root/omcp1_mxcpu.log" 
ssh 172.17.3.40 "rm /root/omcp2_mxcpu.log"
ssh 172.17.3.50 "rm /root/ccp5_mxcpu.log"
ssh 172.17.3.60 "rm /root/ccp6_mxcpu.log"
ssh 172.17.3.70 "rm /root/ccp7_mxcpu.log"
ssh 172.17.3.80 "rm /root/ccp8_mxcpu.log"
ssh 172.17.3.90 "rm /root/ccp9_mxcpu.log"
ssh 172.17.3.100 "rm /root/ccp10_mxcpu.log"

ssh 172.17.3.30 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/omcp1_mxcpu.log" &
ssh 172.17.3.40 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/omcp2_mxcpu.log" &
ssh 172.17.3.50 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/ccp5_mxcpu.log" &
ssh 172.17.3.60 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/ccp6_mxcpu.log" &
ssh 172.17.3.70 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/ccp7_mxcpu.log" &
ssh 172.17.3.80 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/ccp8_mxcpu.log" &
ssh 172.17.3.90 "/usr/local/pms/bin/mxCPU  60 10000 >> /root/ccp9_mxcpu.log" &
ssh 172.17.3.100 "/usr/local/pms/bin/mxCPU 60 10000 >> /root/ccp10_mxcpu.log" &
