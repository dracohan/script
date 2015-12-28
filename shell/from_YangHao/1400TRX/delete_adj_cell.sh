#!/bin/bash
i=$1
echo $i
let c0=2*i-1
let c1=2*i
let c2=2*i+1
let c3=2*i+2
let c4=2*i+3
let c5=2*i+4
let c6=2*i+5
let c7=2*i+6
let c8=2*i+7
let c9=2*i+8
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c0}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c1}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c0}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c2}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c0}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c3}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c0}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c4}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c0}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c5}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c0}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c6}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c0}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c7}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c0}'\t'149'\t'${c8}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c8}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c0}'\t'149'\t'${c9}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt
echo -e "Cmd_Start\t0\t'DELETE ADJACENCY'\t'DELETE ADJACENCY'\t'CELL'\t'${c9}'\t'149'\t'1'\t'TRUE'\t'9'\t'9'\t'9'\t'15'\t'7'\t'7'\t'${c1}'\t'149'\t'${c2}'\t'149'\t'${c3}'\t'149'\t'${c4}'\t'149'\t'${c5}'\t'149'\t'${c6}'\t'149'\t'${c7}'\t'149'\t'${c8}'\t'149'\t'${c0}'\t'149'\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\t''\tCmd_End" >> tmp.txt

