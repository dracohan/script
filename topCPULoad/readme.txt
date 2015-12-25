How to measure CPU load on each board
- Install topCPU.sh on Active OMCP board under /root
- Perform "chmod +x topCPU.sh"
- Launch "/root/topCPU.sh 30"
This script measures the top CPU load every 5s during 0.5 hour for each board.
When the prompt comes up, following file is generated: /var/log/topCPULoad/topCPULoad.tar.gz
Summary of board/process level CPU data can be got from the file:
/var/log/topCPULoad/avgtopcpu.txt
