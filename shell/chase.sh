#!/bin/bash
 
FACE_GIRL="?^_^?"
FACE_BOY="?^O^?"
N_COLS=`tput cols`
N_LINES=`tput lines`
 
BLANK80=`seq -s "" 100 | head -c100`
LINES_ARRAY[0]="Hello baby,xixi"
LINES_ARRAY[1]="Are you feeling lonely over there?"
LINES_ARRAY[2]="Is there someone loving you out there?"
LINES_ARRAY[3]="Sorry,I'm actually a decent gentleman,hehe"
LINES_ARRAY[4]="Hmmm.."
LINES_ARRAY[5]="?(¡ã?¨F?¡ä??)"
 
if [ $N_COLS -lt 80 ] || [ $N_LINES -lt 20 ]; then
   echo "Your terminal needs to be 80 in colums and 20 in lines"
   exit 0;
fi
 
function change_color()
{
        echo -e "\E[$1;$2m"
}
 
function draw_face()
{
        tput cup $1 $2
        if [ "$3" -eq 0 ];then
                echo "                    $FACE_GIRL"
        else
                echo "        $FACE_BOY"
                tput cup `expr $1 + 1` $2
                sleep 1 
                if [ $4 -le 5 ];then
                        echo "           ${LINES_ARRAY[$4]}                               "
                else
 
                        echo "           ${LINES_ARRAY[5]}                               "
                fi
 
        fi
 
}
 
clear
 
tput cup 0 0
change_color 37 47
for i in `seq 8`;do
        echo $BLANK80        
#       echo "                                                                                                  "
done
j=2
change_color 30 47
for i in `seq 20 40`;do
                draw_face $j `expr $i + 1` 0
                draw_face `expr $j + 1` `expr $i - 8` 1 `expr $i - 20`
                sleep 1
 
done
 
tput sgr0
