#!/bin/bash

#-----------------------------------------------------------------
# Description: fork directory tree for certain package from current directory. 
# $Id: fork_package_tree.sh,v 1.2 2012-05-09 02:41:37 jyliu Exp $
#-----------------------------------------------------------------

if [[ $# -lt 2 ]]; then
	echo Usage: $0 [target_base_dir] version subversion
	echo example: $0 an01a 003
	exit 1
fi
targetdir=..
if [[ $# -gt 2 ]]; then
	targetdir=$1
	targetdir=${targetdir%/}
	if [ ! -d $targetdir ]; then
		echo ERROR: $targetdir don\'t exist.
		exit 1
	fi
	shift
fi
bscpackage=/project/gsmdel/mxlr/bss/bsc/$1/$2
targetdir=$targetdir/$1.$2

if [[ -d $targetdir ]]; then
	echo "ERROR: $targetdir has already existed."
	exit 1
fi

mkdir $targetdir

# for READDLS
echo "copying READDLS start ..."
READDLSFILES="input.txt group.sh readDls.sh sqld sqld10"
mkdir $targetdir/READDLS
for f in $READDLSFILES; do
	cp READDLS/$f $targetdir/READDLS/$f
done
echo "copying READDLS finish."

# for PATCH
echo "copying PATCH start ..."
PATCHFILES="download_patchtool.sh"
mkdir $targetdir/PATCH
for f in $PATCHFILES ; do
	cp PATCH/$f $targetdir/PATCH/$f
done
echo "copying PATCH finish."

# for SDP
echo "copying SDP start ..."
SDPFILES="download_oppatool.sh prepare_sdp.sh template.npf"
mkdir -p $targetdir/SDP/BSCdelivery
cp -r SDP/BTSdelivery $targetdir/SDP/
find $targetdir/SDP/BTSdelivery -name "*.SIL.BAK" |xargs rm -f
cp -r SDP/MT120delivery $targetdir/SDP/
find $targetdir/SDP/MT120delivery -name "*.SIL.BAK" |xargs rm -f
mkdir $targetdir/SDP/oppatool
for f in $SDPFILES ; do
	cp SDP/$f $targetdir/SDP/$f
done
echo "copying SDP finish."

# for POLO
echo "copying POLO start ..."
POLOFILES="download_polotool.sh prepare_polo.sh"
mkdir -p $targetdir/POLO/installdir
mkdir $targetdir/POLO/basedir
cp -r POLO/basedir/corr $targetdir/POLO/basedir
for d in `find POLO/basedir \( -name hw_conf -o -name logical_conf \) -type d`; do
	mkdir -p $targetdir/$d
	cp -r $d $targetdir/$d/..
done	
for f in $POLOFILES ; do
	cp POLO/$f $targetdir/POLO/$f
done
echo "copying POLO finish."

# copy BSC Package
echo "copying BSC Package related files start ..."
if [[ ! -d $bscpackage ]]; then
	echo "ERROR: $bscpackage doesn't exist."
	echo "You can copy it manually later."
else
	mkdir $targetdir/SDP/BSCdelivery/$2
	find $bscpackage/* -type d -prune -o -print |xargs -I {} cp {} $targetdir/SDP/BSCdelivery/$2

# input.txt
	rel=`find $bscpackage -name "*.REL"`
	dom=`find $bscpackage -name "*.DOM"`
	fld=`find $bscpackage -name "*.FLD"`
	perl -pe "s%^(FDWNxxxx.REL=).*%\$1$rel%;s%^(FDWNxxxx.DOM=).*%\$1$dom%;s%^(FDWNxxxx.FLD=).*%\$1$fld%" -i $targetdir/READDLS/input.txt

# blddef.csv
	ver=`echo $1$2|tr '[:lower:]' '[:upper:]'`
	cp /project/gsmdel/mxlr/bss/bsc/rD1/blddef-files/blddef-$ver.csv $targetdir/PATCH
fi

# itself
cp fork_package_tree.sh $targetdir
echo "copying BSC Package related files finish."

cat <<EOF

Now you can go to $targetdir/SDP to build SDP, go to $targetdir/POLO to build POLO, go to $targetdir/PATCH to build PATCH.

Before build SDP, please copy latest patch of BSC package if any from Data teams to $targetdir/SDP/BSCdelivery/$2.

For example, For an01a/002:
The updated SDLS (SDAN0202.01B) can be found at : /home/ftp/sw/tools/bscdata/rD/bf/an02ed02
-rwxrwxrwx   1 fren     SEC_CN_RES_asb_wspd_lrc1 2419200 Dec 16 13:59 SDAN0202.01B
-rwxrwxrwx   1 fren     SEC_CN_RES_asb_wspd_lrc1 2419200 Dec 16 14:06 DBD00502.01B
For an01a/003:
The update CDEUAN03.03A can be found at : /home/data_user/deliveries/cde_table/CDEUAN03.03A 

EOF
