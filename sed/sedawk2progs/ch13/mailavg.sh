#! /bin/sh
#
# mailavg - average size of files in /usr/mail
#
# Written by Wes Morgan, morgan@engr.uky.edu, 2 Feb 90
ls -Fs /usr/mail | awk '
   { if(NR != 1) {
       total += $1; 
       count += 1;
       size = $1 + 0; 
       if(size == 0) zercount+=1;
       if(size > 0 && size <= 10) tencount+=1;
       if(size > 10 && size <= 19) teencount+=1;
       if(size > 20 && size <= 50) uptofiftycount+=1;
       if(size > 50) overfiftycount+=1;
       }
   }
   END { printf("/usr/mail has %d mailboxes using %d blocks,", count,total) 
         printf("average is %6.2f blocks\n", total/count)
         printf("\nDistribution:\n")
         printf("Size      Count\n")
         printf(" O           %d\n",zercount)
         printf("1-10         %d\n",tencount)
         printf("11-20        %d\n",teencount)
         printf("21-50        %d\n",uptofiftycount)
         printf("Over 50      %d\n",overfiftycount)
       }'
exit 0
