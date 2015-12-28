#!/bin/bash

#-----------------------------------------------------------------
# Description: download the auto patch maker tool. 
# $Id: download_patchtool.sh,v 1.4 2012-04-28 02:54:09 jyliu Exp $
#-----------------------------------------------------------------

if [[ $# -ne 1 ]]; then
	echo Usage: $0 patchtool_url
	echo "	Please find latest autoPatchMaker in /home/lzhua001/autoPatchMaker/"
	echo example: $0 /home/lzhua001/autoPatchMaker/autoPatchMaker.LRC.V2.3.tar
	exit 1
fi

a=$1
headtmp=download_patchtool.tmp
output=./${a##*/}

if cp $1 $output; then
	echo
	echo Download OK. The file is saved as $output.
	echo Please unpack it for further use.
	echo Please copy corresponding blddef file from /project/gsmdel/mxlr/bss/bsc/rD1/blddef-files/
else
	echo
	echo ERROR: download error.
	echo Please check it.
fi
