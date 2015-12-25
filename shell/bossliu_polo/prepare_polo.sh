#!/bin/bash

#-----------------------------------------------------------------
# Description: generate script to build LRC POLO 
# $Id: prepare_polo.sh,v 1.4 2012-05-03 07:41:35 jyliu Exp $
#-----------------------------------------------------------------

POLOBASE=`pwd`
a=$(find $POLOBASE -name polo)
if [[ ! -f "$a" ]] ; then 
        echo ERROR: polo is not found.
        exit 1
fi
POLO_INSTDIR=${a%/bin/polo}

if [[ ! -d basedir ]]; then
	mkdir basedir
fi
POLO_BASEDIR=$POLOBASE/basedir

a=$(find $POLOBASE -name polo)
if [[ ! -f "$a" ]] ; then 
        echo ERROR: polo is not found.
        exit 1
fi
POLO_INSTDIR=${a%/bin/polo}

cat <<EOF >makepolo.sh
#!/bin/bash
# if [[ \$0 != bash ]]; then
# 	echo This script need run in current shell:
# 	echo . \$0
# 	exit 1
# fi

if [ -z \$DISPLAY ] ; then
	echo ERROR: DISPLAY is not set.
	return 1 2>/dev/null || exit 1
fi
export POLO_INSTDIR=$POLO_INSTDIR
export POLO_BASEDIR=$POLO_BASEDIR

EOF

a=$(find ${POLOBASE%/*}/SDP/package -type d -name "SDP_*")
if [[ ! -d "$a" ]] ; then 
        echo ERROR: SDP is not found.
        exit 1
fi
sdp=$a
sdp_ln=`echo ${a##*/}|sed "s/_BSS//"`

a=$(find $sdp -name "CDE*")
if [[ ! -f "$a" ]] ; then 
        echo ERROR: CDE is not found.
        exit 1
fi
cde=${a##*/}
cde_cp=${cde%???}CDE

if [[ ! -d $POLO_BASEDIR/cde ]] ; then mkdir $POLO_BASEDIR/cde; fi
if [[ ( -d $POLO_BASEDIR/$sdp_ln || -f $POLO_BASEDIR/$sdp_ln ) && ! -h $POLO_BASEDIR/$sdp_ln  ]] ; then
	echo ERROR: $POLO_BASEDIR/$sdp_ln is not a link.
	exit 1
fi

cat <<EOF >>makepolo.sh
echo link SDP...
if [[ -h \$POLO_BASEDIR/$sdp_ln ]] ; then rm \$POLO_BASEDIR/$sdp_ln ; fi
ln -s $sdp \$POLO_BASEDIR/$sdp_ln

echo copy CDE...
cp \$POLO_BASEDIR/$sdp_ln/$cde \$POLO_BASEDIR/cde/$cde_cp

echo modify all bssdef.csv under \"$POLO_BASEDIR\"...
conf_list=""
for i in \`find \$POLO_BASEDIR/*/hw_conf -name bssdef.csv\` ; do
	echo \$i:
	cp \$i \$i.bak
	sed "2 s/CDE.\{1,5\}\.CDE/$cde_cp/;s/SDP.\{1,5\}\..../$sdp_ln/" \$i.bak |tee \$i
	echo
	a=\${i##\$POLO_BASEDIR/}
	conf_list="\$conf_list \${a%%/hw_conf/bssdef.csv}"
done

if [ -z "\$conf_list" ] ; then
	echo ERROR: No configuration is found under "\$POLO_BASEDIR".
	return 1 2>/dev/null || exit 1
fi
echo Following configurations are found:
PS3="Which configuration do you want to use? "
select conf in \$conf_list; do break; done
if [ -z "\$conf" ] ; then
	echo You select nothing.
	return 1 2>/dev/null || exit 1
fi
a=\`sed -n "2 p" \$POLO_BASEDIR/\$conf/hw_conf/bssdef.csv | cut -f 3 -d\\\;\`
echo 
echo You choose the configuration \"\$conf\".
echo The BscConfig is \$a.
echo The Correction_script to be used is \"\`sed -n "2 p" \$POLO_BASEDIR/\$conf/hw_conf/bssdef.csv | cut -f 9 -d\\\;\`\".
echo Start run: \"\$POLO_INSTDIR/bin/polo \$conf \$((a+1))\" ...
\$POLO_INSTDIR/bin/polo \$conf \$((a+1))
#echo "Please examine the basedir/cde, basedir/corr, basedir/(case)/hw_conf and basedir/(case)/logical_conf."
#echo "Then run: \\\$POLO_INSTDIR/bin/polo (case)"
EOF

cat <<EOF
Prepare done.
Please check makepolo.sh, hw_conf, logical_conf, then run "bash makepolo.sh" to continue.
EOF
