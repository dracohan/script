#!/bin/bash

#################################################################################################
# File Name:	readDls.sh									#
# Type:		shell script									#
# Project:	MxBSC B11									#
# Version:	1.0										#
# Author:	GUO Yan, Test Tools Team							#
#												#
# Modification History:                                                                         #
# Date		Version		Author		Description                                     #
# 2007-11-23	1.0		GUO Yan		Creation for CR 36/225109. It is used to read	#
#						DLS and get configuration for test suite. To	#
#						read DLS, some parameters are got from a user	#
#						input file, input.txt.				#
# 2012-1-18     Modified by jyliu for LRC, improve speed for 4000TRX                            #
#################################################################################################

printErrorMsg () {
    echo -e "\tError:\n\t\t$1\n\n";exit 1
}
checkSingleLine () {
    if [ `grep $1 $INPUT|grep -v "^#"|wc -l` -ne 1 ];then printErrorMsg "There should be only one $2.";fi
}
checkEmpty () {
    if [ -z "`grep $1 $INPUT|grep -v "^#"|cut -d= -f2`" ];then printErrorMsg "$2 location in the $INPUT is empty.";fi
}
checkFile () {
    checkSingleLine "$1" "$2"
    checkEmpty "$1" "$2"
    f=`grep $1 $INPUT|grep -v "^#"|cut -d= -f2`
    if [ ! -e "$f" ] || [ ! -f "$f" ];then printErrorMsg "$2: $f is not an existing $2 file.";fi
}
readSetting () {
#readSetting var parameter [default_value]
    o=`awk -F= "\\\$1==\"$2\" {print \\\$2;i++} END {exit i}" $INPUT`
    case $? in
      0)
        if (($#<3)); then
            printErrorMsg "$2 setting is not found."
        else
            eval $1="$3"
        fi
        ;;
      1)
       	eval $1="$o"
       	;;
      *)
       	printErrorMsg "There should be only one $2."
    esac
}
checkFile2 () {
    if [ ! -f "$1" ];then printErrorMsg "$2: $1 is not an existing $2 file.";fi
}
readMultiSetting () {
#readSetting array parameter [default_value]
    o=`awk -F= "\\\$1==\"$2\" {printf \"${1}[%d]='%s'\\\n\",i++,\\\$2;}" $INPUT`
    eval "$o"    
}

# --- 1) check whether $INPUT exists or not ---
INPUT=input.txt
if [ $# -gt 0 ] ; then INPUT=$1; fi
checkFile2 "$INPUT" INPUT

# --- 2) read user input ---
# --- 2.1) get locations of DLS related files ---
readSetting dls DLS
readSetting rel FDWNxxxx.REL
readSetting dom FDWNxxxx.DOM
readSetting fld FDWNxxxx.FLD
checkFile2 "$dls" "DLS"
checkFile2 "$rel" "REL"
checkFile2 "$dom" "DOM"
checkFile2 "$fld" "FLD"

# GY fixing FR 36/290164 starts, check data model version number
##ver=`echo $rel|awk -F/ '{ print $NF}'|cut -c5,6`
##verNbr=`echo $rel|awk -F/ '{ print $NF}'|cut -c7,8`
### R_EXIP_ADD.D_OMCP_TEL is removed since ZZ46 (including ZZ46)
##if [ $ver = "ZZ" ] && [ $verNbr -ge 46 ]
##then
##    domain="D_OMCP_BSS"
##else
##    domain="D_OMCP_TEL"
##fi
# for LRC
domain="D_OMCP_BSS"
# GY fixing FR 36/290164 ends

# --- 2.2) get input for sbridge ---
readSetting m2ua M2UA_TC_ID ""
readSetting tcsl TCSL_TC_ID ""

# --- 2.3) get input for lbridge ---
readSetting bts1_btsId bts1_BTS_ID ""
if [ ! -z "$bts1_btsId" ]
then
    readSetting bts1_oml bts1_OML ""
    readMultiSetting bts1_rsl bts1_RSL
    bts1_rslNb=${#bts1_rsl[*]}
    if [ -z "$bts1_oml" ]; then 
        true #if ((bts1_rslNb==0));then printErrorMsg "There is no LINK configuration for BTS 1.";fi
    else
        bts1Link[0]=$bts1_oml
        simplegps1LINK[$bts1_oml]=OML
    fi
    i=0
    while ((i<$bts1_rslNb))
    do
	if [ -z "${bts1_rsl[$i]}" ];then printErrorMsg "There is no value for \"bts1_RSL=\". Please assign a value or remove the line.";fi
	link=`echo ${bts1_rsl[$i]}|cut -d';' -f1`
	if echo ${bts1Link[*]} | grep -w $link >/dev/null ; then
            printErrorMsg "LINK number of bts1_RSL=${bts1_rsl[$i]} has already be used. Please modify it."
	fi
	bts1Link[${#bts1Link[*]}]=$link
	tei=`echo ${bts1_rsl[$i]}|cut -d';' -f2`
	simplegps1LINK[$link]="Tei=$tei,RSL"
	((i++))
    done
fi

readSetting bts2_btsId bts2_BTS_ID ""
if [ ! -z "$bts2_btsId" ]
then
    readSetting bts2_oml bts2_OML ""
    readMultiSetting bts2_rsl bts2_RSL
    bts2_rslNb=${#bts2_rsl[*]}
    if [ -z "$bts2_oml" ]; then 
        true #if ((bts2_rslNb==0));then printErrorMsg "There is no LINK configuration for BTS 2.";fi
    else
        bts2Link[0]=$bts2_oml
        simplegps2LINK[$bts2_oml]=OML
    fi
    i=0
    while ((i<$bts2_rslNb))
    do
	if [ -z "${bts2_rsl[$i]}" ];then printErrorMsg "There is no value for \"bts2_RSL=\". Please assign a value or remove the line.";fi
	link=`echo ${bts2_rsl[$i]}|cut -d';' -f1`
	if echo ${bts2Link[*]} | grep -w $link >/dev/null ; then
            printErrorMsg "LINK number of bts2_RSL=${bts2_rsl[$i]} has already be used. Please modify it."
	fi
	bts2Link[${#bts2Link[*]}]=$link
	tei=`echo ${bts2_rsl[$i]}|cut -d';' -f2`
	simplegps2LINK[$link]="Tei=$tei,RSL"
	((i++))
    done
fi

# --- 2.4) get input for gslbrdige ---
gslNb=`grep "GSL=" $INPUT|grep -v "^#"|wc -l`
i=0
while ((i<$gslNb))
do
    gsl[$i]=`grep "GSL=" $INPUT|grep -v "^#"|sed -n $((i+1))'p'|cut -d= -f2`
    if [ -z "${gsl[$i]}" ];then printErrorMsg "There is no value for \"GSL=\". Please assign a value or remove the line.";fi
    link=`echo ${gsl[$i]}|cut -d';' -f1`
    if ((i>0))
    then
	for j in ${gsl[*]}
	do
	    if ((link==j));then printErrorMsg "LINK number of ${gsl[$i]} has already be used. Please modify it.";fi
	done
    fi
    gslLink[$i]=$link
    ((i=i+1))
done

# --- 2.5) get input for btssnmpagent ---
readSetting snmp btssnmpagent_BTS_ID ""

# --- 2.6) get input for btssnmpagent ---
readSetting mscid M3UA_MSC_ID ""

# --- 3) create sql file and generate configuration file for test suite ---
# --- The configuration file is defined as testsuite.conf. ---
sqlHeader="#message reading from DLS $dls\nDESCRIPTOR\n'$rel'\n'$dom'\n'$fld';\nDATABASE DLS '$dls';\n\n#option -uc\n"

cat <<EEEEEEEEEEEEEEEEEEEEEEEEEEEEEOF >$INPUT.dlsReading
#message reading from DLS $dls
DESCRIPTOR
'$rel'
'$dom'
'$fld';
DATABASE DLS '$dls';

#option -uc

#message get BTS list
select d_beq_nbr id,
  raw_to_num(d_oml_udp) omlport, 
  raw_to_num(d_rsl_ui) rslport 
  from r_beq_stat, r_bsc_info
  where d_bts_om!=15
  order by 1
  into temp btsidlist;

#message get CCP IP list
select format('%d.',raw_to_num(d_ccp_ip(0,1)))||format('%d.',raw_to_num(d_ccp_ip(1,1)))||format('%d.',raw_to_num(d_ccp_ip(2,1)))||format('%d',raw_to_num(d_ccp_ip(3,1))) ip, 
  d_lce_id
  from r_cp_log,r_conf_ce 
  where r_conf_ce.d_cpl_idx==r_cp_log.d_cpl_idx 
    and r_conf_ce.d_ce_funct==6
  into temp ccpiplist;

#message generate BTS IP
select '#Total BTS=', count(*) from btsidlist;
select 'BTS_',id, 
  ': bts_ip_addr=',raw_to_num(d_oml_rep(0,1)),'.',raw_to_num(d_oml_rep(1,1)),'.',raw_to_num(d_oml_rep(2,1)),'.',raw_to_num(d_oml_rep(3,1)),
  '\nBTS_',id,': bsc_ip_addr=',ip
  from btsidlist, r_oml_lnk, ccpiplist
  where r_oml_lnk.d_beq_nbr==btsidlist.id
    and r_oml_lnk.d_tcu_id==ccpiplist.d_lce_id;

#message generate BTS OML
select 'BTS_',id,
  ': Tei=',d_tei_nbr,
  ',OML,SUBSCRIBER,bts_port=',raw_to_num(d_oml_rep(4,2)),
  ',bts_tid=',raw_to_num(d_oml_rep(6,2)),
  ',bsc_port=',omlport,
  ',bsc_tid=',raw_to_num(d_oml_tid)
  from r_oml_lnk, btsidlist
  where btsidlist.id==r_oml_lnk.d_beq_nbr;

#message generate BTS RSL
select 'BTS_',id,
  ': Tei=',d_tei_nbr, 
  ',RSL,SUBSCRIBER,bts_port=',raw_to_num(d_rsl_rep(4,2)),
  ',bts_tid=',raw_to_num(d_rsl_rep(6,2)),
  ',bsc_port=',rslport,
  ',bsc_tid=',raw_to_num(d_rsl_tid)
  from r_rsl_lnk, btsidlist
  where btsidlist.id==r_rsl_lnk.d_beq_nbr;

#message get MSC list
select d_msc_sbl mscidx, d_spc opc, d_trf_mode trafficmode, d_loc_port bscport
  from r_msc_mgt
  where r_msc_mgt.d_msc_mst!=15
  order by 1
  into temp msclist;

#message get ASL list  
select mscidx, d_sub_sbl aslidx, d_sctp_ep
  from r_asl_lnk asllist, msclist
  where asllist.d_sbl_nbr == mscidx
    and raw_to_hex(d_sctp_ep)!='00000000000000000000'
    and raw_to_hex(d_sctp_ep)!='FFFFFFFFFFFFFFFFFFFF'
  order by 1, 2
  into temp asllist;
  
#message generate MSC MU3A
select '#Total MSC=', count(*) from msclist;
select 'MSC_', mscidx, 
  ': BSC_IP=', raw_to_num(d_omcp_asi(0,1)), '.', raw_to_num(d_omcp_asi(1,1)), '.', raw_to_num(d_omcp_asi(2,1)), '.', raw_to_num(d_omcp_asi(3,1)),
  ',BSC_PORT=', raw_to_num(bscport),
  ',DPC=', raw_to_num(d_own_spc(0, 2)),
  ',OPC=', opc,
  ',TrafficMode=', ((trafficmode-1)*(trafficmode-1)*3+1+trafficmode)/2
  from msclist, r_exip_add, r_n7l3_par;
select 'MSC_', mscidx,
  ': ASL', aslidx, '_IP1=', raw_to_num(d_sctp_ep(0,1)), '.', raw_to_num(d_sctp_ep(1,1)), '.', raw_to_num(d_sctp_ep(2,1)), '.', raw_to_num(d_sctp_ep(3,1)),
  ',ASL', aslidx, '_IP2=', raw_to_num(d_sctp_ep(4,1)), '.', raw_to_num(d_sctp_ep(5,1)), '.', raw_to_num(d_sctp_ep(6,1)), '.', raw_to_num(d_sctp_ep(7,1)),
  ',ASL', aslidx, '_PORT=', raw_to_num(d_sctp_ep(8,2))
  from asllist;

#message END.
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEOF

./sqld10 $INPUT.dlsReading > $INPUT.all.conf

echo
cat <<EOF |tee $INPUT.testsuite.conf
# The following values are read from DLS: $dls.
# Please make sure they are correct before configuring test suite.
# Notice:
#	The lines of OML/RSL/GSL, containing 'LINK', correspond to related links below respectively.
#	The numbers in [] correspond to the numbers in 'rsl_' or 'gpu_'.
#	Please make sure they are mapped correctly.
EOF


# --- 3.1) for sbridge parameters ---
if [ ! -z "$m2ua" ]
then
    echo -e "$sqlHeader" > dlsReading
    echo "#message sbridge m2ua configuration:" >> dlsReading
    # GY fixing FR 36/290164 starts, R_EXIP_ADD.D_OMCP_TEL is removed since ZZ46 (including ZZ46)
    #echo "select 'asp ip=',raw_to_num(d_omcp_tel(0,1)),'.',raw_to_num(d_omcp_tel(1,1)),'.',raw_to_num(d_omcp_tel(2,1)),'.',raw_to_num(d_omcp_tel(3,1)) from r_exip_add;" >> dlsReading
    echo "select 'asp ip=',raw_to_num($domain(0,1)),'.',raw_to_num($domain(1,1)),'.',raw_to_num($domain(2,1)),'.',raw_to_num($domain(3,1)) from r_exip_add;" >> dlsReading
    # GY fixing FR 36/290164 ends
    echo "select 'asp port=',d_asp_port from r_tc_mgt where d_tc_id==$m2ua;" >> dlsReading
    echo "select 'sgp ip=',raw_to_num(d_ss7sg_ep(0,1)),'.',raw_to_num(d_ss7sg_ep(1,1)),'.',raw_to_num(d_ss7sg_ep(2,1)),'.',raw_to_num(d_ss7sg_ep(3,1)) from r_tc_mgt where d_tc_id==$m2ua;" >> dlsReading
    echo "select 'sgp port=',raw_to_num(d_ss7sg_ep(4,2)) from r_tc_mgt where d_tc_id==$m2ua;" >> dlsReading
    echo -e "\n# M2UA parameters:\n" >> testsuite.conf
    ./sqld10 dlsReading >> testsuite.conf;#cat testsuite.conf
    aspIp=`grep "asp ip=" testsuite.conf|cut -d= -f2`
    # GY fixing FR 36/290164 starts, R_EXIP_ADD.D_OMCP_TEL is removed since ZZ46 (including ZZ46)
    #if [ -z $aspIp ];then printErrorMsg "Cannot get R_EXIP_ADD.D_OMCP_TEL from DLS. Please check!";fi
    if [ -z "$aspIp" ];then printErrorMsg "Cannot get R_EXIP_ADD.$domain from DLS. Please check!";fi
    # GY fixing FR 36/290164 ends
    aspPort=`grep "asp port=" testsuite.conf|cut -d= -f2`
    if [ -z "$aspPort" ];then printErrorMsg "Cannot get R_TC_MGT.D_ASP_PORT from DLS. Please check!";fi
    sgpIp=`grep "sgp ip=" testsuite.conf|cut -d= -f2`
    if [ -z "$sgpIp" ];then printErrorMsg "Cannot get R_TC_MGT.D_SS7SG_EP.B_IP_ADDR from DLS. Please check!";fi
    sgpPort=`grep "sgp port=" testsuite.conf|cut -d= -f2`
    if [ -z "$sgpPort" ];then printErrorMsg "Cannot get R_TC_MGT.D_SS7SG_EP.B_SCTP_PORT from DLS. Please check!";fi
fi
if [ ! -z "$tcsl" ]
then
    echo -e "$sqlHeader" > dlsReading
    echo "#message sbridge tcsl configuration:" >> dlsReading
    # GY fixing FR 36/290164 starts, R_EXIP_ADD.D_OMCP_TEL is removed since ZZ46 (including ZZ46)
    #echo "select 'tcslmr_ip=',raw_to_num(d_omcp_tel(0,1)),'.',raw_to_num(d_omcp_tel(1,1)),'.',raw_to_num(d_omcp_tel(2,1)),'.',raw_to_num(d_omcp_tel(3,1)) from r_exip_add;" >> dlsReading
    echo "select 'tcslmr_ip=',raw_to_num($domain(0,1)),'.',raw_to_num($domain(1,1)),'.',raw_to_num($domain(2,1)),'.',raw_to_num($domain(3,1)) from r_exip_add;" >> dlsReading
    # GY fixing FR 36/290164 ends
    echo "select 'tcslmr_port=',d_tcsl_prt from r_tcsl_lnk where d_tc_id==$tcsl;" >> dlsReading
    echo "select 'tcsl_adapter_ip=',raw_to_num(d_tcsl_rep(0,1)),'.',raw_to_num(d_tcsl_rep(1,1)),'.',raw_to_num(d_tcsl_rep(2,1)),'.',raw_to_num(d_tcsl_rep(3,1)) from r_tcsl_lnk where d_tc_id==$tcsl;" >> dlsReading
    echo "select 'tcsl_adapter_port=',raw_to_num(d_tcsl_rep(4,2)) from r_tcsl_lnk where d_tc_id==$tcsl;" >> dlsReading
    echo -e "\n# TCSL parameters:\n" >> testsuite.conf
    ./sqld10 dlsReading >> testsuite.conf;#cat testsuite.conf
    tcslmrIp=`grep "tcslmr_ip=" testsuite.conf|cut -d= -f2`
    # GY fixing FR 36/290164 starts, R_EXIP_ADD.D_OMCP_TEL is removed since ZZ46 (including ZZ46)
    #if [ -z $tcslmrIp ];then printErrorMsg "Cannot get R_EXIP_ADD.D_OMCP_TEL from DLS. Please check!";fi
    if [ -z "$tcslmrIp" ];then printErrorMsg "Cannot get R_EXIP_ADD.$domain from DLS. Please check!";fi
    # GY fixing FR 36/290164 ends
    tcslmrPort=`grep "tcslmr_port=" testsuite.conf|cut -d= -f2`
    if [ -z "$tcslmrPort" ];then printErrorMsg "Cannot get R_TCSL_LNK.D_TCSL_PRT from DLS. Please check!";fi
    tcslAdapterIp=`grep "tcsl_adapter_ip=" testsuite.conf|cut -d= -f2`
    if [ -z "$tcslAdapterIp" ];then printErrorMsg "Cannot get R_TCSL_LNK.D_TCSL_REP.B_IP_ADDR from DLS. Please check!";fi
    tcslAdapterPort=`grep "tcsl_adapter_port=" testsuite.conf|cut -d= -f2`
    if [ -z "$tcslAdapterPort" ];then printErrorMsg "Cannot get R_TCSL_LNK.D_TCSL_REP.B_TCP_PORT from DLS. Please check!";fi
fi

# --- 3.2) for lbridge parameters ---
if [ ! -z "$bts1_btsId" ]
then 
    echo -e "\n# bts1 parameters:\n" |tee -a $INPUT.testsuite.conf
    if ((${#bts1Link[*]}==0)); then
        for i in `grep -w BTS_$bts1_btsId $INPUT.all.conf|grep RSL|sed "s/.\{1,\}\(Tei=[0-9]\{1,\},RSL\).\{1,\}/\1/"`; do
            simplegps1LINK[${#simplegps1LINK[*]}]="$i"
        done
        simplegps1LINK[${#simplegps1LINK[*]}]=OML
    fi
    grep -w BTS_$bts1_btsId $INPUT.all.conf | grep _ip_addr | sed "s/BTS_\([0-9]\{1,\}\)/bts1(\1)/" |tee -a $INPUT.testsuite.conf
    for i in `seq 0 31`; do
        if [ ! -z "${simplegps1LINK[$i]}" ]; then
            grep -w BTS_$bts1_btsId $INPUT.all.conf | grep "${simplegps1LINK[$i]}" | sed -e "s/BTS_\([0-9]\{1,\}\)/bts1(\1)/" -e "s/Tei=/LINK,$i = PORT=A,TS=1,Tei=/" |tee -a $INPUT.testsuite.conf
        fi
    done
fi

if [ ! -z "$bts2_btsId" ]
then 
    echo -e "\n# bts2 parameters:\n" |tee -a $INPUT.testsuite.conf
    if ((${#bts2Link[*]}==0)); then
        for i in `grep -w BTS_$bts2_btsId $INPUT.all.conf|grep RSL|sed "s/.\{1,\}\(Tei=[0-9]\{1,\},RSL\).\{1,\}/\1/"`; do
            simplegps2LINK[${#simplegps2LINK[*]}]="$i"
        done
        simplegps2LINK[${#simplegps2LINK[*]}]=OML
    fi
    grep -w BTS_$bts2_btsId $INPUT.all.conf | grep _ip_addr | sed "s/BTS_\([0-9]\{1,\}\)/bts2(\1)/" |tee -a $INPUT.testsuite.conf
    for i in `seq 0 31`; do
        if [ ! -z "${simplegps2LINK[$i]}" ]; then
            grep -w BTS_$bts2_btsId $INPUT.all.conf | grep "${simplegps2LINK[$i]}" | sed -e "s/BTS_\([0-9]\{1,\}\)/bts2(\1)/" -e "s/Tei=/LINK,$i = PORT=A,TS=1,Tei=/" |tee -a $INPUT.testsuite.conf
        fi
    done
fi


# --- 3.3) for gslbridge parameters ---
if ((gslNb>0))
then
    echo -e "$sqlHeader" > dlsReading
    echo "#message gslbridge configuration:" >> dlsReading
    echo -e "\n# GSL parameters:\n" >> testsuite.conf
    gslIdx=`echo ${gsl[0]}|cut -d';' -f2`
    echo "select 'mfs ip=',raw_to_num(d_gsl_rep(0,1)),'.',raw_to_num(d_gsl_rep(1,1)),'.',raw_to_num(d_gsl_rep(2,1)),'.',raw_to_num(d_gsl_rep(3,1)) from r_ip_gsl where d_gsl_idx==$gslIdx;" >> dlsReading
    echo "select 'gslmr_ip=',raw_to_num(d_ccp_ip(0,1)),'.',raw_to_num(d_ccp_ip(1,1)),'.',raw_to_num(d_ccp_ip(2,1)),'.',raw_to_num(d_ccp_ip(3,1)) from r_cp_log,r_conf_ce,r_ip_gsl where r_ip_gsl.d_dtc_id==r_conf_ce.d_lce_id and r_conf_ce.d_cpl_idx==r_cp_log.d_cpl_idx and r_ip_gsl.d_gsl_idx==$gslIdx;" >> dlsReading
    echo "select 'gslmr_port=',raw_to_num(d_gsl_port) from r_ip_gsl where d_gsl_idx==$gslIdx;" >> dlsReading
    i=0
    while ((i<$gslNb))
    do
	echo "GSL [$i] LINK number=`echo ${gsl[$i]}|cut -d';' -f1`" >> testsuite.conf
	gslIdx=`echo ${gsl[$i]}|cut -d';' -f2`
	echo "select 'gpu_$i port=',raw_to_num(d_gsl_rep(4,2)) from r_ip_gsl where d_gsl_idx==$gslIdx;" >> dlsReading
	((i=i+1))
    done
    ./sqld10 dlsReading >> testsuite.conf;#cat testsuite.conf
    mfsIp=`grep "mfs ip=" testsuite.conf|cut -d= -f2`
    if [ -z "$mfsIp" ];then printErrorMsg "Cannot get R_IP_GSL.D_GSL_REP.B_IP_ADDRESS from DLS. Please check!";fi
    bscIp=`grep "gslmr_ip=" testsuite.conf|cut -d= -f2`
    if [ -z "$bscIp" ];then printErrorMsg "Cannot get R_CP_LOG.D_CCP_IP from DLS. Please check!";fi
    bscPort=`grep "gslmr_port=" testsuite.conf|cut -d= -f2`
    if [ -z "$bscPort" ];then printErrorMsg "Cannot get R_IP_GSL.D_GSL_PORT from DLS. Please check!";fi
    i=0
    while ((i<$gslNb))
    do
	link=`echo ${gsl[$i]}|cut -d';' -f1`
	gpuPort=`grep "gpu_$i port=" testsuite.conf|cut -d= -f2`
	if [ -z "$gpuPort" ];then printErrorMsg "Cannot get R_IP_GSL.D_GSL_REP.B_TCP_PORT from DLS. Please check!";fi
	((i=i+1))
    done
fi

# --- 3.4) for btssnmpagent parameters ---
if [ ! -z "$snmp" ]
then
    echo -e "\n# btssnmpagent parameters:\n" |tee -a $INPUT.testsuite.conf
    grep -w BTS_$snmp $INPUT.all.conf | grep _ip_addr | sed "s/BTS_\([0-9]\{1,\}\)/btssnmpagent(\1)/" |tee -a $INPUT.testsuite.conf
    grep -w BTS_$snmp $INPUT.all.conf | grep OML | sed -e "s/BTS_\([0-9]\{1,\}\)/btssnmpagent(\1)/" -e "s/Tei=/LINK,0 = PORT=A,TS=1,Tei=/"|tee -a $INPUT.testsuite.conf    
fi

# GY fixing CR 36/281408 starts, add a part for reading MSC and ASL parameters for sbridge
# --- 3.5) for M3UA parameters ---
echo -e "\n# M3UA parameters:\n" |tee -a $INPUT.testsuite.conf
if [ ! -z "$mscid" ]; then
    grep -w MSC_$mscid $INPUT.all.conf | tee -a $INPUT.testsuite.conf
else
    grep MSC $INPUT.all.conf | sort -t : -k1.5n,1 -k2.2,2.2r | tee -a $INPUT.testsuite.conf
fi



# GY fixing CR 36/281408 ends
#rm -f dlsReading

