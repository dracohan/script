#!/bin/bash

###################################################################################
#                                                                                 #
# Module :  AutoMerge.sh                                                          #
#                                                                                 #
# Description : Bootstrapper for merge and test commands                          #
#                                                                                 #
#                                                                                 #
#                                                                                 #
#  Date        Author            Description                                      #
# -----------  ----------------  ------------------------------------------------ #
#  2016/02/24  Baowei Han        Creation                                         #
#  2016/04/15  Baowei Han	 draft version 1 				  #
#                                                                                 #
###################################################################################

#######
# usage
#set -x
me=$(basename "$0")

usage() {
    echo -e "Usage1: AutoMerge.sh merge <branch> <from-branch> <from-cln>"
    echo -e "\t<branch>: branch for merge"
    echo -e "\t<from-branch>: from branch for merge"
    echo -e "\t<from-cln>: from which changelist\n"
    echo -e "Usage2: AutoMerge.sh test"
    echo -e "\tLaunch SVS test and sandbox test based on TOT\n"
    exit 0
}

getLogFile() {
    cbsLogFile="cbsMerge1_"$(date +%Y%m%d_%H%M%S).log
    touch ./$cbsLogFile
}

logstream() {
    if [[ "x$logFile" = "x" ]]
    then
        cat 1>&2
    else
        tee -a "$logFile" 1>&2
    fi
}

warn() {
    echo -e "$me:  WARNING:  $*" | logstream
}

errmsg() {
    echo -e "$me:  ERROR:  $*" | logstream
}

infomsg() {
    echo -e "$me:  INFO:  $*" | logstream
}

Execute(){
    if [ $1 = "source" ]
    then
        $*
    elif [ $1 = "callcmd" ]
    then
        # to be updated with final path on dbc server
        python /dbc/pa-dbc1131/hanb/script/m4ushell.py $* &> $cbsLogFile 
        infomsg "Result of cbsMerge1(last 5 lines):"
        cat $cbsLogFile | tail -5
    else
        # to be updated with final path on dbc server
        python /dbc/pa-dbc1131/hanb/script/m4ushell.py $* | tee -a $logFile
    fi
}

ExecuteSteps(){
        # use for loop to read all values and indexes
        for i in "$@"
        do
            infomsg "\n########################################################################################################################"
            if [ "$i" = "source configenv.sh" ]
            then
                infomsg "Shell cmd: "$i
                PrintConfig
            else
                infomsg "Shell cmd: ""m4ushell" $i
            fi
            Execute $i
        done
}

PrintConfig() {
    infomsg "Merge configs(content of configenv.sh):"
    while read LINE
    do
        infomsg $LINE
    done < configenv.sh
}

PerformMerge(){
    branch="$2"
    from_branch="$3"
    from_cln="$4"

    declare -a mergesteps=(
        "branch configenv --out=configenv.sh --branch=${branch} --from-branch=${from_branch} --from-cln=${from_cln}"
        "source configenv.sh"
        #"branch sync --branch=${branch}"
        "callcmd cbsMerge1"
        "branch prepare_conflict_resolution"
        "branch resolve_minus_d"
        "branch summary"
    )

    ExecuteSteps "${mergesteps[@]}"
}

LaunchTest(){
    declare -a teststeps=(
    "source configenv.sh"
    "branch perform_test"
    )

    ExecuteSteps "${teststeps[@]}"
}

#######
# main
while  getopts ql:h opt
do
    case $opt in 
        h) help=1;;
        q) quitemode=1;;
        l) logpath=$OPTARG;;
    esac
done
shift $(( OPTIND - 1 ))

[[ $help -ne 0 ]] && usage

getLogFile

if [ $1 == "-h" ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "/?" ] || [ $1 == "help" ]
then
    usage
elif [[ "$1" != "merge" && "$1" != "test" ]]
then
    errmsg "Wrong arguments given. See Usage below: \n"
    usage
elif [[ $# -eq 4 && $1 == "merge" ]]
then
    echo -e "########################################################################################################################"
    infomsg "Start merging from "$3" to "$2" based on cln "$4" ..."
    infomsg "Current time: "$(date)
    infomsg "fromBranch: "$3
    infomsg "branch: "$2
    infomsg "fromCLN: "$4
    infomsg "cbsMerge1 log file: "$cbsLogFile
    PerformMerge $*
    if [[ $? -ne 0 ]]
    then
        exst=1
    else
        exst=0
    fi
elif [[ $# -eq 1 && $1 == "test" ]]
then
    echo -e "\n########################################################################################################################"
    infomsg "Launch SVS and sandbox testing ..."
    LaunchTest
    if [[ $? -ne 0 ]]
    then
        exst=2
    else
        exst=0
    fi
elif [[ $# -gt 3 ]]
then
    errmsg "Unknown arguments given after the change number."
    usage
fi

case $exst in
0)  infomsg "AutoMerge.sh execution completed.";;
1)  errmsg "Failed to merge from "$3" to "$2".";;
2)  errmsg "Failed to launch SVS and sandbox.";;
*)  errmsg "AutoMerge failed and manual recovery is needed.";;
esac

exit $exst
