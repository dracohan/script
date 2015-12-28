#!/bin/bash

#-----------------------------------------------------------------
# Description: generate script to build LRC SDP 
# $Id: prepare_sdp.sh,v 1.3 2012-05-03 07:42:07 jyliu Exp $
#-----------------------------------------------------------------

OPPABIN=LrOPPL

#if [[ $0 != bash ]]; then
#	echo This script need run in current shell.
#	echo . $0
#	exit 1
#fi

SDPBASE=`pwd`

a=$(find $SDPBASE -name $OPPABIN)
if [[ ! -f "$a" ]] ; then 
	echo ERROR: $OPPABIN is not found.
	exit 1
fi
OPPA=${a%/$OPPABIN}

cat <<EOF >makesdp.sh
#!/bin/bash

# for SIL
cd $SDPBASE/BTSdelivery/IP &&  $OPPA/sil_sh/tr_bts_sil.sh
cd $SDPBASE/MT120delivery/si_tc && $OPPA/sil_sh/tr_mt120_sil.sh
EOF

a=$(find $SDPBASE/BSCdelivery -name "BSXM*" \! -name "*rpm")
if [[ ! -f "$a" ]] ; then 
	echo ERROR: BSXM\* is not found.
	exit 1
fi
BSC=${a%/*}

cd $BSC
SDLS=$(ls SD*|sed "2,$ d")
VER=$(ls BSXM* |cut -c10-12)
REL=$(ls BSXM* |cut -c6)
cd $SDPBASE
cat <<EOF >>makesdp.sh
cd $BSC && $OPPA/sil_sh/sil_mxbsc8.sh $VER $SDLS
cd $SDPBASE
EOF

a=$(find $SDPBASE/BTSdelivery -name "*.SIL")
if [[ ! -f "$a" ]] ; then 
        echo ERROR: BTSdelivery SIL is not found.  
	exit 1
fi
btssil=$a

a=$(find $SDPBASE/MT120delivery -name "*.SIL")
if [[ ! -f "$a" ]] ; then 
        echo ERROR: MT120delivery SIL is not found.  
	exit 1
fi
mt120sil=$a

a=$(find $SDPBASE/MT120delivery -name "MTT*")
if [[ ! -f "$a" ]] ; then 
        echo ERROR: MT120delivery MTT is not found.  
	exit 1
fi
mt120mf=${a##*/}

a=$(find $SDPBASE/BSCdelivery -name "*.TAR")
if [[ ! -f "$a" ]] ; then 
        echo ERROR: BSCdelivery TAR is not found.  
	exit 1
fi
bsctar=$a

cat <<EOF >>makesdp.sh

# for npf
bscsil=\$(find $SDPBASE/BSCdelivery -name "*.SIL")
[[ ! -f "\$bscsil" ]] && { echo ERROR: BSCdelivery SIL is not found; exit 1; }
sed "s%__BSCdelivery_SIL__%\$bscsil%;s%__BTSdelivery_IP_SIL__%$btssil%;s%__MT120delivery_SIL__%$mt120sil%;s%__BSCdelivery_TAR__%$bsctar%;s%__SDPBASE__%$SDPBASE%;s%__NPF_FILE__%$SDPBASE/bsc_fat.npf%;s%__MT120_MTOF__%$mt120mf%;s%__RELEASE_CHAR__%$REL%" template.npf |tee bsc_fat.npf

# generate SDP
rm -rf package; mkdir package
$OPPA/$OPPABIN bsc_fat.npf $SDPBASE/package
EOF

cat <<EOF
Prepare done.
Please check makesdp.sh and run "bash makesdp.sh" to build SDP package.
EOF
