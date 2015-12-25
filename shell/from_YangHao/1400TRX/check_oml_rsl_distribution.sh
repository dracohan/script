#!/bin/sh
awk '{$2=$3$2} {print}' $1 | awk '{print $1,$2}' > rsl1.txt
awk '{$2=strtonum("0x"$2)}{print}' rsl1.txt > rsl2.txt
awk '{
        if($2<235){$3="error"}
        else if($2<285) {$3="CCP3"}
        else if($2<335) {$3="CCP4"}
        else if ($2<385) {$3="CCP5"}
        else if($2<435) {$3="CCP6"}
        else if ($2<485) {$3="CCP7"}
        else if($2<705) {$3="error"}
        else if($2<755){$3="CCP8"}
        else if($2<805) {$3="CCP9"}
        else {$3="error"}
      }
      {print}' rsl2.txt  > rsl3.txt
echo "CCP3: "`cat rsl3.txt | grep CCP3 | wc -l`
echo "CCP4: "`cat rsl3.txt | grep CCP4 | wc -l`
echo "CCP5: "`cat rsl3.txt | grep CCP5 | wc -l`
echo "CCP6: "`cat rsl3.txt | grep CCP6 | wc -l`
echo "CCP7: "`cat rsl3.txt | grep CCP7 | wc -l`
echo "CCP8: "`cat rsl3.txt | grep CCP8 | wc -l`
echo "CCP9: "`cat rsl3.txt | grep CCP9 | wc -l`
