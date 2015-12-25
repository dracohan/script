#!/bin/bash

#-----------------------------------------------------------------
# Description: download the POLO tool. 
# $Id: download_polotool.sh,v 1.2 2012-04-28 02:54:09 jyliu Exp $
#-----------------------------------------------------------------

if [[ $# -ne 1 ]]; then
	echo Usage: $0 polo_url
	echo "	Please find polo_url in Data Tool's website http://172.24.231.163/datatool/"
	echo example: $0 http://172.24.231.163/datatool/polo/download/polxan01d.tar
	exit 1
fi

a=$1
headtmp=download_polotool.tmp
output=installdir/${a##*/}

if curl --compressed --create-dirs -D $headtmp --output $output $1; then
	if grep -s "200 OK" $headtmp > /dev/null; then
		echo
		echo Download OK. The file is saved as $output.
		echo Please unpack it for further use.
	else
		echo
		echo ERROR: Download error.
		cat $headtmp
	fi
else
	echo
	echo ERROR: download error.
	echo Please check it.
fi
rm -f $headtmp