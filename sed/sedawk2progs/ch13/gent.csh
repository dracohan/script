#!/bin/csh -f

set argc = $#argv


set noglob
set dollar = '$'
set squeeze = 0
set noback="" nospace=""

rescan:
    if ( $argc > 0 && $argc < 3 ) then
        if ( "$1" =~ -* ) then
            if ( "-squeeze" =~ $1* ) then
                set noback='s/\\//g' nospace='s/^[  ]*//'
                set squeeze = 1
                shift
                @ argc --
                goto rescan 
            else 
                echo "Bad switch: $1"
                goto usage
            endif
        endif

        set entry = "$1"
        if ( $argc == 1 ) then
            set file = /etc/termcap
        else
            set file = "$2"
        endif
    else
        usage:
            echo "usage: `basename $0` [-squeeze] entry [termcapfile]"
            exit 1
    endif


sed -n -e \
"/^${entry}[|:]/ {\
    :x\
    /\\${dollar}/ {\
    ${noback}\
    ${nospace}\
    p\
    n\
    bx\
    }\
    ${nospace}\
    p\
    n\
    /^  / {\
        bx\
    }\
    }\
/^[^    ]*|${entry}[|:]/ {\
    :y\
    /\\${dollar}/ {\
    ${noback}\
    ${nospace}\
    p\
    n\
    by\
    }\
    ${nospace}\
    p\
    n\
    /^  / {\
        by\
    }\
    }" < $file		
