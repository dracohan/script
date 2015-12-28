# Program: 
#   This is a script to change (readLink, startMasterATstm, startSlaveATstm) /usr/local/bin
# Program:
#   This is a script to change (readLink, startMasterATstm, startSlaveATstm) /usr/local/bin
# History:
#   2011/12/13 HBW First release
# Usage:
#   ./versionch.sh <version name>, eg ./versionch.sh A_Tm-4.0.10_beta5_PVM-multiprocess_Cn-IP

if [ "$1" == "" ]; then
	echo "You must input a LSU version as parameter! Usage:"
	echo "./versionch.sh <version name>, eg ./versionch.sh A_Tm-4.0.10_beta5_PVM-multiprocess_Cn-IP"
else
	echo "This version you're going to  is ==> a$1a"
	echo y | rm readLink
	echo y | rm startMasterATstm
	echo y | rm startSlaveATstm
	ln -s "../$1/bin/rdl" readLink
	ln -s "../$1/bin/startMasterATstm" startMasterATstm
	ln -s "../$1/bin/startSlaveATstm" startSlaveATstm
fi
