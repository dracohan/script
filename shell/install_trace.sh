#!/bin/sh
# AUTHOR : Ly Chau
# Date : 10/04/2001
# Description :  Install the OMC trace tools from packed TAR file
# <MOD 04/06/03>  create the symbolic link between /usr/bin/perl
# and /usr/local/bin/perl directories in order to be forward 
# compatible with B7 version 
if [ "$1" != "" ]
then
	mkdir -p $HOME/trace > /dev/null 2>&1
	mkdir -p $HOME/TOOLS_DIR > /dev/null 2>&1
	mv $1 $HOME/TOOLS_DIR
	su - root -c "cd $HOME/TOOLS_DIR; gzip -dc $1 | tar xvf -"
	mv $HOME/TOOLS_DIR/$1 $HOME
	if [ -f /usr/bin/perl ] 
	then
	su - root -c "ln -s /usr/bin/perl /usr/local/bin/perl > /dev/null 2>&1"
	fi
else
	echo "Usage : install_trace.sh <Gzipped TAR file>\n"
fi
