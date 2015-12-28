#!/bin/bash

# Configure the port Mirroring on the F300 Switch
# Copyright (c) 2007 by Motorola ECC
# 
# Version History


#   1.0 24Aug2007- Initial version 
#                  Author: Claudio Gregorio 
#

#Global declarations
PING=ping
AWK=awk
CUT=cut
SED=sed
GREP=grep

#SNMP related declarations
SNMPOPT=" -v2c -Ov -Oe -c public"
SNMPOPT2=" -v2c -On -c public" #Display the OID in numeric form
SNMPSET=snmpset
SNMPGET=snmpget
SNMPWALK=snmpwalk


#Mirroring MIBS OIDs
TMS_MIRROR_MTP=".1.3.6.1.4.1.731.2.2.1.9.1"
TMS_MIRROR_VID=".1.3.6.1.4.1.731.2.2.1.9.2"
TMS_MIRROR_INGRESS=".1.3.6.1.4.1.731.2.2.1.9.3"
TMS_MIRROR_EGRESS=".1.3.6.1.4.1.731.2.2.1.9.4"

#Vlan setup OIDs
SNMP_SMI=".1.3.6.1.2.1"
IEEE_VER=".1.3.6.1.2.1.17.7.1.1.1"
VLAN_NB=".1.3.6.1.2.1.17.7.1.1.4.0"
VLAN_STABLE=".1.3.6.1.2.1.17.7.1.4.3.1"
VLAN_ID_ASSIGNED=".1.3.6.1.2.1.17.7.1.4.5.1.1"
VLAN_STATUS=".1.3.6.1.2.1.17.7.1.4.3.1.5"
VLAN_NAME=".1.3.6.1.2.1.17.7.1.4.3.1.1"
VLAN_EGRESS_PORTS=".1.3.6.1.2.1.17.7.1.4.3.1.2"
VLAN_EGRESS_PORTS_OID=".1.3.6.1.2.1.17.7.1.4.3.1.2"
VLAN_FORBIDDEN_EGRESS_PORTS=".1.3.6.1.2.1.17.7.1.4.3.1.3"
VLAN_UNTAGGED_PORTS=".1.3.6.1.2.1.17.7.1.4.3.1.4"
VLAN_PVID=".1.3.6.1.2.1.17.7.1.4.5.1.1"
SAVE_TO_NVM=".1.3.6.1.4.1.731.2.2.1.6.1.0"



#Script variables

REV=1.0
TOOLNAME="F300PortMirroring.sh"


GETVALUEERR="ERROR"
GETVALUE="ERROR"

SETVALUEERR="ERROR"
SETVALUE="ERROR"
SETMTPORT="MTP_PORT"
SETINGRESS="INGRESS"
SETEGRESS="EGRESS"

MASK=0


#Default Values
FORCE_EXEC=0
MTP=0
INGRESSPORTS="1 2 3 4 5 6 7 8 9 10 11 12 13 14"
EGRESSPORTS="1 2 3 4 5 6 7 8 9 10 11 12 13 14"
MIRRORVID=4094 


#Helper functions


#Output functions

myPrint()
{
    txt=${1:-""}  
    nline=${2:-0}
    format=${3:-0}    

    if [ "$txt" != "" ];	
	then
	case $format in
	    0) 
		printf "%s" "$txt";; #Plain text
	    1) 
		printf "%s\t-->\t" "${txt}";;#Progress indicator start
	    2)  printf "%s\n" "-------------------------------"	;
		printf "%s" "${txt}"; #Header	    
		printf "\n%s" "-------------------------------"	;;
	
	    *) printf "%s" "$txt";; #Plain text
	
	esac

	if [ $nline -ne 0 ];
	    then
	    printf "\n"
	fi
    fi
}

#Controlled exit functions

myExit()
{   
    txt=${1:-""}
    exitStatus=${2:-0}
    echo $txt
    exit $exitStatus    
}

toolUsage()
{
    myPrint "HELP" 1 2
    myPrint "$TOOLNAME <SWITCH_IP> <OPT1> [<ARGS1>] ... <OPTn> [ARGSn]" 1 0
    echo ""
    myPrint "<SWITCH_IP>: Mandatory IP address of one switch" 1 0
    myPrint "<OPT>: -m <MTP>" 1 0
    myPrint "       <MTP>:  Mandatory Mirror To port (0->Disable Mirror, 1..24 -> Enable MTP as port <MTP>" 1 0
    myPrint "<OPT>: -i \"<PortList>\"" 1 0
    myPrint "       <PortList>:  List of ports (i.e. \"3 5 7\") that should be ingress mirrored." 1 0    
    myPrint "                    If no ports are given, the ingress sources are not modified." 1 0
    myPrint "                    Enter the port list using \" \" as delimiters." 1 0
    myPrint "<OPT>: -e \"<PortList>\"" 1 0
    myPrint "       <PortList>:  List of ports (i.e. \"4 5 8\") that should be egress mirrored." 1 0    
    myPrint "                    If no ports are given, the egress sources are not modified." 1 0
    myPrint "                    Enter the port list using \" \" as delimiters." 1 0 
    myPrint "<OPT>: -s <VID>" 1 0
    myPrint "       Specify the VID to use for the Dedicated Mirror VLAN." 1 0
    myPrint "       If not given 4094 is the default one." 1 0
    myPrint "       If zero the setup of the VLAN is by-passed." 1 0
    myPrint "<OPT>: -f " 1 0
    myPrint "       Disable the user ask-for-confirm steps." 1 0   
    myPrint "Type $TOOLNAME without arguments to display this help." 1 0
}

cleanUp()
{
    ret=${1:-1}
    txt=${2:-""}   
    myExit "$txt" $ret 
}

trapHandler()
{
    cleanUp -1 'Exit on Abort' 
}

#General functions


myPing()
{
    address=$1
    $PING -c 1 -w 1  $1  2>/dev/null 1>/dev/null    
    if  [ $? -ne 0 ]; #Ping is failed
	then 	
	return -1
    fi    
    return 0
}

pingCheck()
{
    addr=${1}
    exOnFail=${2:-0}   
    myPrint "TRY TO REACH TARGET($addr)" 0 1
    myPing $addr
    ret=$?
    if [ $ret -ne 0 ];
	then
	myPrint "NOT OK" 1 0
	helpOnFailure "ping"
	if [ $exOnFail -ne 0 ];
	    then
	    myExit  "Exit on failure." -1
	fi
    fi
    myPrint "OK" 1 0
    return $ret
}

helpOnFailure()
{
    if [ $# -eq 1 ];
	then
	case $1 in
	    "ping") 
		myPrint "IP address $addr is not reachable." 0;
		myPrint "Check given address and/or network connectivity." 1; 
		;;	   
	    "snmp")
		 myPrint "Check whether you have installed net-snmp package in the right directory" 1
		 myPrint "Check network connectivity and/or switch agent healthy". 1
		;;
	    "failedConfirm")
		myPrint "Enter <y> to proceed or <n> to stop" 1
		;;
	esac
    fi
}

askForConfirm()
{
    if [ $# -ne 2 ]; then
	echo "Usage: askForConfirm "Text to display" [Force confirm]"
	exit
    fi
    
    txt=$1
    force=$2

    if [ $force -eq 1 ];then
	myPrint "${txt} [y/n]<ENTER>" 0
	myPrint ".Skipped" 1
	return 1
    fi
    
    myPrint "${txt} [y/n]<ENTER>?" 1
    confirm='n'
    read confirm   
    if [[ $confirm == "y" ]] || [[ $confirm == "Y" ]] ;then
	return 1
    elif [[ $confirm == "n" ]] || [[ $confirm == "N" ]];then
	return 0
    else
	return -1
    fi    
}



#Snmp set/get/walk modified functions.
ssnmpset()
{    
    if [ $# -lt 4 ];
	then
	myPrint "Usage: $0 <IP_ADDR> <OID> <VALUE_TYPE> <VALUE> [Exit on Fail]" 1
    fi    

   
    EXITONFAIL=0
    IPADDR=$1
    OID=$2
    VALTYPE=$3
    VALUE=$4
    if [ $# -gt 4 ];
	then
	EXITONFAIL=$5
    fi
        
    #perform non stressing set
    sleep 0.1
    SETVALUE=`($SNMPSET $SNMPOPT $IPADDR $OID $VALTYPE "$VALUE"  2>/dev/null || echo "0:$SETVALUEERR") |$CUT -d":" -f2`
        
    if [ "$SETVALUE" == $SETVALUEERR ];
	then
	if [ $EXITONFAIL -ne 0 ];
	    then	   	 
	    myPrint "NOT OK" 1
	    myPrint "$SNMPSET operation on $OID at $IPADDR (Value=$4, Type= $VALTYPE) failed." 1	  
	    helpOnFailure "snmp"
	    myExit  "Exit on failure" -1	    
	else	   
	    return -1
	fi
    fi
    return 0
}

ssnmpget()
{    
    if [ $# -lt 2 ];
	then
	myPrint "Usage: $0 <IP_ADDR> <OID> [Exit on Fail]" 1
    fi    
   
    EXITONFAIL=0
    IPADDR=$1
    OID=$2

    if [ $# -gt 2 ];
	then
	EXITONFAIL=$3
    fi
    
    if [ $# -gt 3 ];
	then
	STRIPBLANK=$4
    fi
      
    #perform non stressing get
    sleep 0.1

    GETVALUE=`($SNMPGET $SNMPOPT $IPADDR $OID  2>/dev/null || echo "0:$GETVALUEERR") | $CUT -d":" -f2 | $SED  's/^ //g' | $SED 's/"//g'`
    
    if [ $STRIPBLANK -ne 0 ];then
	GETVALUE=`echo $GETVALUE | sed 's/ //g'`
    fi
       
    OIDISPRESENT=`(echo ${GETVALUE} | $GREP "Such") || echo "OBJPRESENT"`   
    
    if [ "$GETVALUE" == $GETVALUEERR -o "$OIDISPRESENT" != "OBJPRESENT" ];
	then
	if [ $EXITONFAIL -ne 0 ];
	    then
	    myPrint "NOT OK" 1
	    myPrint "$SNMPGET operation on $OID at $IPADDR  failed." 1	  
	    helpOnFailure "snmp"
	    myExit  "Exit on failure" -1	    
	else
	    return -1
	fi
    fi    
    return 0
}

ssnmpwalk()
{    
    if [ $# -lt 2 ];
	then
	myPrint "Usage: $0 <IP_ADDR> <OID> [Exit on Fail]" 1
    fi    
   
    EXITONFAIL=0
    IPADDR=$1
    OID=$2

    if [ $# -gt 2 ];
	then
	EXITONFAIL=$3
    fi

    #perform non stressing walk
    sleep 0.1
        
    $SNMPWALK $SNMPOPT $IPADDR $OID  2>/dev/null 1>/dev/null

    if [ $? -ne 0 ];
	then
	if [ $EXITONFAIL -ne 0 ];
	    then
	    myPrint "$SNMPWALK operation on $OID at $IPADDR failed." 1	  
	    helpOnFailure "snmp"
	    myExit  "Exit on failure" -1	    
	else
	    return -1
	fi
    fi
    return 0
}


#created the wanted mask in MASK
createMask()
{   
    numports=$#
    bitmask=$*

    if [ $numports -lt 1 ];then
	return 0
    fi
    
    #Initialize
    tmp=0
    MASK=0
    for bit in $bitmask;
      do     
      let " bit = $bit - 1"
      let " tmp = 1 << $bit "     
      let " MASK |= $tmp "
    done        
    return 0
}


saveTMSConf()
{
    myPrint "SAVE CONFIGURATION" 0 1
    sleep 3
    ssnmpset $SWITCHIP ${SAVE_TO_NVM} i 2 1 #Save to NVRAM
    myPrint "OK" 1
}


removePortAllVLAN()
{
    if [ $# -lt 1 ];then
	myPrint "RemovePortAllVLAN requires at least one parameter" 1 0
	exit -1
    fi
    port_to_remove=$1   

    VLAN_PRESENT=`$SNMPWALK $SNMPOPT2 $SWITCHIP $VLAN_EGRESS_PORTS_OID |cut -d"=" -f1 |cut -d"." -f15`


    #Remove the MTP from all the VLANs
    for vlan in $VLAN_PRESENT
      do
      myPrint "Remove port $port_to_remove from VLAN $vlan" 0 1
      
      ssnmpget $SWITCHIP ${VLAN_EGRESS_PORTS}.$vlan 1 1
      taggedMask=$GETVALUE
     
      
      ssnmpget $SWITCHIP ${VLAN_UNTAGGED_PORTS}.$vlan 1 1
      untaggedMask=$GETVALUE
     
      
      ssnmpget $SWITCHIP ${VLAN_FORBIDDEN_EGRESS_PORTS}.$vlan 1 1
      forbiddenMask=$GETVALUE
      
      #Compute the new bitmasks
      MTPMemberMask="ffffff"
      MTPForbidMask="000000"
      for i in `seq 1 24`
	do	  
	let " port = 25 - $i "
	createMask $port
	if [ $i -eq $port_to_remove ]; then #this port should be removed
	    let "MTPMemberMask &= ~$MASK "
	    let "MTPForbidMask |= $MASK "
	else
	    let "MTPMemberMask |= $MASK "
	fi
      done
     
      MTPMemberMask=`printf "%06x" $MTPMemberMask`
      MTPForbidMask=`printf "%06x" $MTPForbidMask`
      
      let " newtaggedMask = 0x$taggedMask & 0x$MTPMemberMask "
      let " newuntaggedMask = 0x$untaggedMask & 0x$MTPMemberMask "
      let " newforbiddenMask = 0x$forbiddenMask | 0x$MTPForbidMask "

      newtaggedMask=`printf "%06x" $newtaggedMask`
      newuntaggedMask=`printf "%06x" $newuntaggedMask`
      newforbiddenMask=`printf "%06x" $newforbiddenMask`

      #Adapt the VLAN      
      ssnmpset $SWITCHIP ${VLAN_FORBIDDEN_EGRESS_PORTS}.${vlan} x "00 00 00" 1 #Set forbidden mask to none to avoid errors
      ssnmpset $SWITCHIP ${VLAN_EGRESS_PORTS}.${vlan} x $newtaggedMask 1 #Set egress mask
      ssnmpset $SWITCHIP ${VLAN_UNTAGGED_PORTS}.${vlan} x $newuntaggedMask 1 #Set untagged mask
      ssnmpset $SWITCHIP ${VLAN_FORBIDDEN_EGRESS_PORTS}.${vlan} x $newforbiddenMask 1 #Set forbidden mask  
      myPrint "OK" 1
    done
}

createOnePortVLAN()
{
    if [ $# -lt 2 ];then
	myPrint "createMirrorVLAN requires at least two parameter" 1 0
	exit -1
    fi
    
    vid=$1
    port_m=$2
    
    myPrint "Create Mirror VLAN: VID=$vid. Port Member(MTP)=$MTP" 0 1	
	    
    taggedMask=0
    untaggedMask=0
    forbiddenMask=0
    for i in `seq 1 24`
      do	  
      let " port = 25 - $i "
      createMask $port
      if [ $i -eq $port_m ]; then #uplink port should be member	     
	  let " taggedMask |= $MASK "
      else #build forbidden mask
	  let " forbiddenMask |= $MASK "
      fi
    done		    
	#remove interlink
   
    taggedMask=`printf "%06x" $taggedMask`
    forbiddenMask=`printf "%06x"  $forbiddenMask`
    untaggedMask="000000"	
    

    ssnmpset $SWITCHIP ${VLAN_STATUS}.${vid} i 6 0 #Set VLAN status to destroy
    ssnmpset $SWITCHIP ${VLAN_STATUS}.${vid} i 4 0 #Set VLAN status to create and wait
    ssnmpset $SWITCHIP ${VLAN_FORBIDDEN_EGRESS_PORTS}.${vid} x "00 00 00" 1 #Set forbidden mask to none to avoid errors
    ssnmpset $SWITCHIP ${VLAN_EGRESS_PORTS}.${vid} x $taggedMask 1 #Set egress mask
    ssnmpset $SWITCHIP ${VLAN_UNTAGGED_PORTS}.${vid} x $untaggedMask 1 #Set untagged mask
    ssnmpset $SWITCHIP ${VLAN_FORBIDDEN_EGRESS_PORTS}.${vid} x $forbiddenMask 1 #Set forbidden mask
    ssnmpset $SWITCHIP ${VLAN_NAME}.$vid s "Mirror VLAN" 1 #Set the vlan name
    ssnmpset $SWITCHIP ${VLAN_STATUS}.${vid} i 1 1 #Set VLAN status to active
    myPrint "OK" 1 
#    saveTMSConf
}

enableMirroring()
{
    if [ $# -lt 3 ];then
	myPrint "enableMirroring requires at least three parameter" 1 0
	exit -1
    fi
    mtp=$1
    ingressports=$2
    egressports=$3
       
    
         #Enable or disable the mirroring
    if [ $mtp  -gt 0 2>/dev/null -a $mtp -le 24 2>/dev/null ];then
	myPrint "Enabling Mirroring with MTP ($MTP)" 0 1
	ssnmpset $SWITCHIP ${TMS_MIRROR_MTP}.0 i $mtp 1 
	myPrint "OK" 1
    elif  [ $mtp -eq 0 2>/dev/null ]; then
	myPrint "Disabling Mirroring (MTP=$mtp)" 0 1
	ssnmpset $SWITCHIP ${TMS_MIRROR_MTP}.0 i 0 1 
	myPrint "OK" 1
    else    
	myExit "Given MTP($MTP) is not valid. Exit" 0
    fi

    #Setup the Ingress ports if needed
    if [ $mtp  -gt 0 2>/dev/null -a $mtp -le 24 2>/dev/null ];then
	ingressMask=0
	if [ $OPTINGRESSOK -eq 1 2>/dev/null ];then
	    myPrint "Set Ingress Mirrored Ports ($ingressports)" 0 1
	    for i in $ingressports
	      do	  
	      if [ $i -gt 0 2>/dev/null -a $i -le 24 2>/dev/null ];then
		  let "port = 25 - $i "
		  createMask $port	  
		  let " ingressMask |= $MASK "	 
	      else
		  myExit "Given Ingress port($i) is not valid. Exit" 0
	      fi
	    done
	    ingressMask=`printf "%06x" $ingressMask`	
	    ssnmpset $SWITCHIP ${TMS_MIRROR_INGRESS}.0 x $ingressMask 1	 
	    myPrint "OK" 1
	fi
	egressMask=0
    #Setup the Egress ports if needed
	if [ $OPTEGRESSOK -eq 1 2>/dev/null ];then
	    myPrint "Set Egress Mirrored Ports ($egressports)" 0 1
	    for i in $egressports
	      do	  
	      if [ $i -gt 0 2>/dev/null -a $i -le 24 2>/dev/null ];then
		  let "port = 25 - $i "
		  createMask $port	  
		  let " egressMask |= $MASK "	 
	      else
		  myExit "Given Egress port($i) is not valid. Exit" 0
	      fi
	    done
	    egressMask=`printf "%06x" $egressMask`	 
	    ssnmpset $SWITCHIP ${TMS_MIRROR_EGRESS}.0 x $egressMask 1	 
	    myPrint "OK" 1
	fi
    fi   
 
}

setupPortMirroring()
{
    #Enable the port Mirroring
    if [ $MTP -gt 0 2>/dev/null -a $MTP -le 24 2>/dev/null ];then
	if [ $MIRRORVID -ne 0 2>/dev/null ];then	    
	    askForConfirm "Remove the MirrorToPort from all VLAN. Are you sure?" $FORCE_EXEC
	    confirm=$?
	    if [ $confirm -eq 1 ]; then
		removePortAllVLAN $MTP	  
	    fi  
	    askForConfirm "Create a dedicated VLAN for the Mirror To Port (VID=$MIRRORVID). Are you sure?" $FORCE_EXEC
	    confirm=$?
	    if [ $confirm -eq 1 ]; then
		createOnePortVLAN $MIRRORVID $MTP
	    fi		   
	else
	    myPrint "Special Mirror VLAN configuration by-passed (VID=0)" 1 0
	fi
	#Perform settings on the Mirror MIBS
	enableMirroring $MTP "$INGRESSPORTS" "$EGRESSPORTS"
    elif [ $MTP -eq 0 2>/dev/null ]; then
	#Perform settings on the Mirror MIBS
	enableMirroring $MTP "$INGRESSPORTS" "$EGRESSPORTS"
    else
	myExit "Given MTP($MTP) is not valid. Exit" 0
    fi    
}


#Here we start

trap trapHandler 1 2 3

LINEPARAMETERS=$*
NUMPARAMETERS=$#

#Print Header
myPrint "F300 PORT MIRRORING TOOL REV $REV" 1 2

#Variable initialization
SWITCHIP=${1:-"h"}
OPTERROR=0
OPTVALUEERROR=0
OPTOK=0
OPTMTPOK=0
OPTINGRESSOK=0
OPTEGRESSOK=0
OPT=0



if [ $SWITCHIP == "-h" ];
    then
    toolUsage
    myExit "" 0
fi


#At least one parameter (IP address) should be always present
if [ $NUMPARAMETERS -le 2 ];
    then
    toolUsage 
    myExit "IP address and Mirror To Port are mandatory arguments. Exit" 0
fi

#Connectivity check
pingCheck $SWITCHIP  1

shift 
while [ $# -ne 0 ]
do

  case "$1" in
      -m) 
	  if [ $2 -lt 0 2>/dev/null -o $2 -gt 24 2>/dev/null  ];then
	      OPTVALUEERROR=1
	      INVOPT=$1	   
	      INVVALUE=$2	      
	      break;
	  fi	  
	  shift
	  MTP=$1
	  OPTMTPOK=1
	  ;;
      -i) INGRESSPORTS=$2
	  OPTINGRESSOK=1
	  shift
	  ;;
      -e) EGRESSPORTS=$2
	  OPTEGRESSOK=1	  
	  shift
	  ;;      
      -f) FORCE_EXEC=1	 
	  ;;
      -s) if [ $2 -lt 0 2>/dev/null -o $2 -gt 4094 2>/dev/null  ];then
	      OPTVALUEERROR=1
	      INVOPT=$1	   
	      INVVALUE=$2	      
	      break;
	  fi	  
	  MIRRORVID=$2
	  shift
	  ;;
      *)  OPTERROR=1; 
	  INVOPT=$1;
	  break;
	  ;;	   
  esac
  shift
done

#Parameters check
if [ $OPTERROR -ne 0 ];
    then
    toolUsage
    myExit "Option ($INVOPT) is not valid. Exit" -2
fi

if [ $OPTVALUEERROR -ne 0 ];
    then
    toolUsage
    myExit "Option ($INVOPT) has value not valid argument ($INVVALUE). Exit" -2
fi

if [ $OPTMTPOK -ne 1 ]; then
    toolUsage
    myExit "The Mirror To Port is a mandatory option. Exit" -2
fi

#Execute the desired script operation

setupPortMirroring 

myExit "Finished." 0
    

    






