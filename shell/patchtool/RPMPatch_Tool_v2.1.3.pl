#!/usr/bin/perl
############################################################################
#                                                                          #
#                                                                          #
#Last Modification:Mon Jan 23 09:20:30 CST 2006                            #
############################################################################
 #check the SW version of MXPF
 system("rpm -qa|grep SWMGT >/root/SWversionOfMXPF.txt");
 open(DH,"/root/SWversionOfMXPF.txt");
 $SWversionOfMXPF=<DH>;
 chomp($SWversionOfMXPF);
 close (DH);
 if(-e "/root/SWversionOfMXPF.txt")
{
 system("rm -f /root/SWversionOfMXPF.txt");
}
if(-e "/root/ScriptBscPackageVersion.txt")
{
 system("rm -f /root/ScriptBscPackageVersion.txt");
}
 print "The SW version of MXPF is $SWversionOfMXPF\n";
if(-e "/root/vceBscPackageVersion.txt")
{ 
system("rm -f /root/vceBscPackageVersion.txt");
}
#check if the log file exist
$logfile="/var/log/Patch_installation.log";
#$logfile="/home/jing.a.zhao/Patch_installation.log";
 @SWversionOfMXPF_array=split (/\-/,$SWversionOfMXPF);
 #if ($SWversionOfMXPF_array[1] eq "R1.2")
 #{
 #	 if($SWversionOfMXPF_array[3]<=95)
 #	 {
 #	 	print "The SW version of MXPF:$SWversionOfMXPF is old, you should install patch using RPMPath_Tool_v1.6.3.pl,#eixt\n";
 #	 	exit 1;
 #	  } 
 #}
 
 #clean the rpm db
 system("rm -f /var/lib/rpm/*db.*");
 #remove the temporary files
 
 
if(-e "/root/oldVCERPMfilename.txt")
{  
system("rm -f /root/oldVCERPMfilename.txt");
}
if(-e "/root/oldScriptRPMfilename.txt")
{
system("rm -f /root/oldScriptRPMfilename.txt");
}
if(-e "/root/MxswdfP001RpmPackageName.txt")
{
system("rm -f /root/MxswdfP001RpmPackageName.txt");
}
#This tool is to do RPM patch.
  $parametercount=$#ARGV;
  system("rm -rf /root/temp_Rpm_patch");
  if($parametercount eq "-1")
  {
   #input the argument
   print "Input the new VCE RPM filename:\n";
   chomp ($newVCERPMfilename=<STDIN>);
   print "Input the new Script RPM filename:\n";
   chomp ($newScriptRPMfilename=<STDIN>);
   print "Explanation for MXSW descriptor file: The MXSW descriptor file is stored in /common/bsc/SCPRDISK whose name is in the format of MXSWDSCR.XXY , for example:MXSWDSCR.21Z.\nInput MXSW descriptor filename:\n";
   chomp ($Mxswdf=<STDIN>);
  }
  elsif ($parametercount ne "2")
  {
    print "Usage:perl $0 <New VCE RPM filename> <new Script RPM filename> <MXSW descriptor file>\n";
    system("echo Error !!incorrect input parameter | tee -a $logfile");
    exit 1;
  }elsif($parametercount eq "2") 
   {
    $newVCERPMfilename=$ARGV[0];
    chomp($newVCERPMfilename);    
    $newScriptRPMfilename=$ARGV[1];
    chomp($newScriptRPMfilename);
    $Mxswdf=$ARGV[2];
    chomp($Mxswdf);
    }
   
   #get the directory which put the rpm files
    system("ls -lrt /common/sw |grep current > /root/a.txt");
    open(DIR,"/root/a.txt");
    $RPMdirline=<DIR>;
    chomp($RPMdirline);
    close (DIR);
    system("rm -f /root/a.txt");
    my @textitem;
    @textitem =split (/\s{1,2000}/,$RPMdirline);
    $RPMdir="/common/sw/$textitem[$#textitem]/rpm";
    $OmcpBscPatchlistDir="/common/sw/$textitem[$#textitem]";
    chomp($RPMdir);
    #check the omcp-bscpatch-rpm.lst exist or not
    if(! -e "$OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst"){
    system( "echo ERROR, There is no $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst, Please check | tee -a $logfile");
    
    }
    
   #check the rpm file exist or not
  if(! -e "$RPMdir/$newVCERPMfilename"){
  	 system( "echo $RPMdir/$newVCERPMfilename does not exist, copy $newVCERPMfilename from /root to $RPMdir. | tee -a $logfile");
  	    #Check the input for newVCERPMfile
         if (! -e "/root/$newVCERPMfilename" ){
              system("echo ERROR!There is no /root/$newVCERPMfilename and no $RPMdir/$newVCERPMfilename pls check | tee -a $logfile");
                    exit 1;
             }
  	  system("cp -f /root/$newVCERPMfilename $RPMdir/$newVCERPMfilename");
  	}
  	else
  	{
  		system("echo $RPMdir/$newVCERPMfilename has already existed, so $newVCERPMfilename will not be copyed from /root to $RPMdir | tee -a $logfile");
  	}     
 
if(($newScriptRPMfilename eq "No")or($newScriptRPMfilename eq "no")or($newScriptRPMfilename eq "NO")) 
{
   print "DO THE NEW NON VCE FILE RPM PATCH\n";
   #[]---------------------------------------------------[]*/
   ##|                                                     |*/
   ##|  DO THE NEW NON VCE FILE RPM PATCH                  |*/
   ##|                                                     |*/
   ##|                                                     |*/
   ##|                                                     |*/
   ##|                                                     |*/
   ##|                                                     |*/
   ##[---------------------------------------------------[]*/
   system("rm -rf /root/temp_Rpm_patch");
  #get the 8.3 format
  my @array;
  @array =split (/\./, $newVCERPMfilename);
  $VCERPMfilenamefirst8=$array[0];
  $VCERPMfilename =$array[0]."\.$array[1]";
  my @array_1;
  @array_1=split (/\-/,$VCERPMfilename);
  if ($#array_1 !=0)
  {   
    $VCERPMfilename=$array_1[0];
  }
  $OrignalVCERPMfilename=$VCERPMfilename."-R1.0-P1.i686.rpm";
  #check the VCE RPMfile label match with MX SDF or not
  system("sed -n -e '/^#B.LOAD/,/^#E.LOAD/p' /common/bsc/SCPRDISK/$Mxswdf >/root/vceloadsegment.txt");
  system("grep $VCERPMfilename /root/vceloadsegment.txt >/root/vcelabeltest.txt");
  system("grep $VCERPMfilenamefirst8 /root/vceloadsegment.txt >/root/vcefirst8test.txt");
  $vcelabeltestcount=(-s "/root/vcelabeltest.txt");
  $vcefirst8testcount=(-s "/root/vcefirst8test.txt");
  if($vcefirst8testcount != 0)
  {
  	if ($vcelabeltestcount == 0)
  		{
    		print "ERROR!!! The label of $newVCERPMfilename:$VERPMfilename does not match with the label in the load segment of /common/bsc/SCPRDISK/$Mxswdf, please check, exit!\n";
    		exit 1;    
  		}
  }		
  system("rm -f /root/vcelabeltest.txt");
  system("rm -f /root/vceloadsegment.txt");
  system("rm -f /root/vcefirst8test.txt");  
  

  system ("grep $VCERPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/oldVCERPMfilename.txt");
  system ("grep $VCERPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/oldVCERPMfilename.txt");
  system ("grep $VCERPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/oldVCERPMfilename.txt");

  #Check the /root/oldVCERPMfilename.txt
  $o=(-s "/root/oldVCERPMfilename.txt");
  if ($o == 0){
            print "There is no a record $VCERPMfilename* in the omcp-bscpatch-rpm.lst and ccp-bsc-rpm.lst and tpgsm-bsc-rpm.lst.\n";
            #unistall
              system("rpm -qa | grep $VCERPMfilename >>/root/esysVCERPMfilename.txt");
              open (DH, "/root/esysVCERPMfilename.txt");
              $esysVCERPMfilename=<DH>;
              chomp($esysVCERPMfilename);
              close (DH);
              $eysnumber=(-s "/root/esysVCERPMfilename.txt");
              system("rm -f /root/esysVCERPMfilename.txt");
              if ($eysnumber ==0)
              {
               print "There is no $VCERPMfilename* recorded in the rpm database\n";	    
               }
              else
              {
     	          print "Uninstall the $esysVCERPMfilename\n";
                system("rpm -e $esysVCERPMfilename");
               }
            #install      
             print "Install the $newVCERPMfilename\n";
             system("rpm -Uvh --nodeps --force $RPMdir/$newVCERPMfilename");
             if ( $? !=0){
             system ("echo Error!!! rpm $RPMdir/$newVCERPMfilename install failed | tee -a $logfile");
             exit 1;
             }
            #add the newVCERPMfilename to omcp-bscpatch-rpm.lst
            if($newVCERPMfilename eq $OrignalVCERPMfilename)
            {
            	print "$newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst .\n";
            	system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
            	open(ADD, "/root/vce.log")||die;
             	$add=<ADD>;
             	chomp($add);
             	close(ADD);
             	system("rm -f /root/vce.log");

             	system("date +%T\\ %F>>/root/adddate.txt");
             	open(ADDDATE, "/root/adddate.txt")||die;
             	$adddate=<ADDDATE>;
             	chomp($adddate);
             	close(ADDDATE);
             	system("rm -f /root/adddate.txt"); 
             	$addloginfo="$add".", $adddate.";
             	open(LOG, ">>/root/MXBSC_APP_Patch.log");
             	print LOG "$addloginfo\n"; 
            }
            else
             {
             	system("echo $newVCERPMfilename >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
	           	print "$newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst\n";
             	system("echo $newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
             	open(ADD, "/root/vce.log")||die;
             	$add=<ADD>;
             	chomp($add);
             	close(ADD);
             	system("rm -f /root/vce.log");

             	system("date +%T\\ %F>>/root/adddate.txt");
             	open(ADDDATE, "/root/adddate.txt")||die;
             	$adddate=<ADDDATE>;
             	chomp($adddate);
             	close(ADDDATE);
             	system("rm -f /root/adddate.txt"); 
             	$addloginfo="$add".", $adddate.";
             	open(LOG, ">>/root/MXBSC_APP_Patch.log");
             	print LOG "$addloginfo\n";
             }
          
             print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";     
     }
   else
   {  
       #get the information needed:oldVCERPMfilename, eoldVCERPMfilename, esysRPMfilename 

      open (PWD, "/root/oldVCERPMfilename.txt");
      $oldVCERPMfilename=<PWD>;
      chomp($oldVCERPMfilename);
      close (PWD);
     #print "oldVCERPMfilename is $oldVCERPMfilename\n";
     my @Array;
     @Array =split (/\./, $oldVCERPMfilename);
     if ($#Array == 5)
        {
         $eoldVCERPMfilename=$Array[0]."\.$Array[1]"."\.$Array[2]"."\.$Array[3]";
        }
     if ($#Array ==4)
        {
        	$eoldVCERPMfilename=$Array[0]."\.$Array[1]"."\.$Array[2]";
        }   
     system("rpm -qa | grep $VCERPMfilename >>/root/esysVCERPMfilename.txt");
     $eysnumber=(-s "/root/esysVCERPMfilename.txt");
     open (DH, "/root/esysVCERPMfilename.txt");
     $esysVCERPMfilename=<DH>;
     chomp($esysVCERPMfilename);
     close (DH);
     system("rm -f /root/oldVCERPMfilename.txt");
     system("rm -f /root/esysVCERPMfilename.txt");
     #Check the RPM installed in the system and the oldVCERPMfilename :match or not

     system("grep $VCERPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/ccpVCERPMfilename.txt ");
     system("grep $VCERPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/omcpVCERPMfilename.txt");
     system("grep $VCERPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/tpgsmVCERPMfilename.txt");
     $a=(-s "/root/ccpVCERPMfilename.txt");
     $b=(-s "/root/omcpVCERPMfilename.txt");
     $c=(-s "/root/tpgsmVCERPMfilename.txt");
     if(($a != 0)&&($b != 0)){
	     open (DY1, "/root/ccpVCERPMfilename.txt");
  	   $oldVCERPMfilename_ccplst=<DY1>;
    	 chomp($oldVCERPMfilename_ccplst);
	 # print "oldVCERPMfilename_ccplst is $oldVCERPMfilename_ccplst\n";
     	 open (DY2, "/root/omcpVCERPMfilename.txt");
     	 $oldVCERPMfilename_omcplst=<DY2>;
     	 chomp($oldVCERPMfilename_omcplst);
	 #print "oldVCERPMfilename_omcplst is $oldVCERPMfilename_omcplst\n";
       if ( $oldVCERPMfilename_ccplst ne $oldVCERPMfilename_omcplst){
          print "Error!!!The oldVCERPMfilename in ccp-bsc-rpm.lst is $oldVCERPMfilename_ccplst; the oldVCERPMfilename in omcp-bscpatch-rpm.lst is $oldVCERPMfilename_omcplst, the two do not match.\n";
          exit 1;
         }         
      }
     if (($a != 0)&&($c != 0)){
        open (DY1, "/root/ccpVCERPMfilename.txt");
        $oldVCERPMfilename_ccplst=<DY1>;
        chomp($oldVCERPMfilename_ccplst);
        open (DY3, "/root/tpgsmVCERPMfilename.txt");
        $oldVCERPMfilename_tpgsmlst=<DY3>;
        chomp($oldVCERPMfilename_tpgsmlst);
        if ($oldVCERPMfilename_ccplst ne $oldVCERPMfilename_tpgsmlst){
           print "Error!!!The oldVCERPMfilename in ccp-bsc-rpm.lst is $oldVCERPMfilename_ccplst;the oldVCERPMfilename in tpgsm-bsc-rpm.lst is $oldVCERPMfilename_tpgsmlst, the two do not match.\n";
           exit 1;
        }
      }
      if(($b != 0)&&($c != 0)){
      	open (DY2, "/root/omcpVCERPMfilename.txt");
        $oldVCERPMfilename_omcplst=<DY2>;
        chomp($oldVCERPMfilename_omcplst);
        open (DY3, "/root/tpgsmVCERPMfilename.txt");
   			$oldVCERPMfilename_tpgsmlst=<DY3>;
   			chomp($oldVCERPMfilename_tpgsmlst);
   			if ($oldVCERPMfilename_omcplst ne $oldVCERPMfilename_tpgsmlst){
    				print "Error!!!The oldVCERPMfilename in tpgsm-bsc-rpm.lst is $oldVCERPMfilename_tpgsmlst;the oldVCERPMfilename in omcp-bscpatch-rpm.lst is $oldVCERPMfilename_omcplst, the two do not match.\n";
    				exit 1;
    		}
  		}   
  		if ($eysnumber != 0){  
     			if ("$esysVCERPMfilename" ne "$eoldVCERPMfilename"){
          	if ($a != 0){
            	            print "Error!!!The RPM ($esysVCERPMfilename) installed in system and the RPM ($eoldVCERPMfilename) in the ccp-bsc-rpm.lst doesn't match!\n";
                       }
           	if ($b != 0){
                        print  "Error!!!The RPM ($esysVCERPMfilename) installed in system and the RPM ($eoldVCERPMfilename) in the omcp-bscpatch-rpm.lst doesn't match!\n";
                        }
           	if ($c != 0){
                        print "Error!!!The RPM ($esysVCERPMfilename) installed in system and the RPM ($eoldVCERPMfilename) in the tpgsm-bsc-rpm.lst doesn't match!\n";
                         } 
             exit 1;
            }
   		}	      
  		system("rm -f /root/ccpVCERPMfilename.txt");
  		system("rm -f /root/omcpVCERPMfilename.txt");
  		system("rm -f /root/tpgsmVCERPMfilename.txt");
			#grep and replace
  		#for omcp
  		system("grep $VCERPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/testomcpVCERPMfilename.txt");
  		open (FD1, "/root/testomcpVCERPMfilename.txt");
  		$omcpVCERPMfilenametest=<FD1>;
  		chomp($omcpVCERPMfilenametest);
  		#If omcp-bscpatch-rpm.lst does not have any $VCERPMfilename ,then add $newVCERPMfilename to omcp-bscpatch-rpm.lst
  		$omcpnon=(-s "/root/testomcpVCERPMfilename.txt");
  		if($omcpnon ==0){
  	      #add $newVCERPMfilename to omcp-bscpatch-rpm.lst
  	          if($newVCERPMfilename eq $OrignalVCERPMfilename)
            {
            	print "$newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst .\n";
            	system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
            	open(ADD, "/root/vce.log")||die;
             	$add=<ADD>;
             	chomp($add);
             	close(ADD);
             	system("rm -f /root/vce.log");

             	system("date +%T\\ %F>>/root/adddate.txt");
             	open(ADDDATE, "/root/adddate.txt")||die;
             	$adddate=<ADDDATE>;
             	chomp($adddate);
             	close(ADDDATE);
             	system("rm -f /root/adddate.txt"); 
             	$addloginfo="$add".", $adddate.";
             	open(LOG, ">>/root/MXBSC_APP_Patch.log");
             	print LOG "$addloginfo\n"; 
            }
            else
  	        {
  	         system("echo $newVCERPMfilename >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
		         print "$newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst\n";
             system("echo $newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
             open(ADD, "/root/vce.log")||die;
             $add=<ADD>;
             chomp($add);
             close(ADD);
             system("rm -f /root/vce.log");

             system("date +%T\\ %F>>/root/adddate.txt");
             open(ADDDATE, "/root/adddate.txt")||die;
             $adddate=<ADDDATE>;
             chomp($adddate);
             close(ADDDATE);
             system("rm -f /root/adddate.txt"); 
             $addloginfo="$add".", $adddate.";
             open(LOG, ">>/root/MXBSC_APP_Patch.log");
             print LOG "$addloginfo\n";
            }
             print "The change has been recorded in /root/MXBSC_APP_Patch.log\n"; 
  	  }	
  		system("rm -f /root/testomcpVCERPMfilename.txt");
  		#If omcp-bscpatch-rpm.lst has one $VCERPMfilename, then replace the old one with the $newVCERPMfilename
  		if ( $omcpVCERPMfilenametest eq $oldVCERPMfilename){
     		#modify the omcp-bscpatch-rpm.lst
     		 if($newVCERPMfilename eq $OrignalVCERPMfilename)
            {
            	print "$newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst .\n";
            	system("sed -e '/^$VCERPMfilename/d' $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >/root/c");
							system("cat /root/c >$OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
							system("rm -f /root/c");
							system("rm -f /root/testomcpVCERPMfilename.txt");
            	system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/c4.log");
            	open(CHANG4, "/root/c4.log")||die;
             	$change4=<CHANG4>;
     		      chomp($change4);
     		      close(CHANG4);
     		      system("rm -f /root/c4.log");

     		      system("date +%T\\ %F>>/root/date4.txt");
     		      open(DATE4, "/root/date4.txt")||die;
     		      $date4=<DATE4>;
     		      chomp($date4);
     		      close(DATE4);
     		      system("rm -f /root/date4.txt");

     		      $loginfo4="$change4".", $date4.";
     		      open(LOG, ">>/root/MXBSC_APP_Patch.log");
     		      print LOG "$loginfo4\n"; 
            }
            else
            {
     		     	system("sed -e s/$oldVCERPMfilename/$newVCERPMfilename/ $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst > /root/c");
     		      system("cat /root/c > $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
     		      system("rm -f /root/c");
     		      system("rm -f /root/testomcpVCERPMfilename.txt");
     		      print "$oldVCERPMfilename replaced by $newVCERPMfilename in the omcp-bscpatch-rpm.lst\n";
     		      system("echo $oldVCERPMfilename replaced by $newVCERPMfilename in the omcp-bscpatch-rpm.lst>>/root/c4.log");
     		      open(CHANG4, "/root/c4.log")||die;
     		      $change4=<CHANG4>;
     		      chomp($change4);
     		      close(CHANG4);
     		      system("rm -f /root/c4.log");

     		      system("date +%T\\ %F>>/root/date4.txt");
     		      open(DATE4, "/root/date4.txt")||die;
     		      $date4=<DATE4>;
     		      chomp($date4);
     		      close(DATE4);
     		      system("rm -f /root/date4.txt");

     		      $loginfo4="$change4".", $date4.";
     		      open(LOG, ">>/root/MXBSC_APP_Patch.log");
     		      print LOG "$loginfo4\n";
     		     }  
          
     		print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
  		}
    	#for ccp
    	system("grep $VCERPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/testccpVCERPMfilename.txt");
    	open (FD2, "/root/testccpVCERPMfilename.txt");
    	$ccpVCERPMfilenametest=<FD2>;
    	chomp($ccpVCERPMfilenametest);
    	system("rm -f /root/testccpVCERPMfilename.txt");
   		if ( $ccpVCERPMfilenametest eq $oldVCERPMfilename){
      		 #modify the ccp-bsc-rpm.lst
       		system("sed -e s/$oldVCERPMfilename/$newVCERPMfilename/ $RPMdir/MXPF/ccp-bsc-rpm.lst > /root/c");
       		system("cat /root/c > $RPMdir/MXPF/ccp-bsc-rpm.lst");
       		system("rm -f /root/c");
       		print "$oldVCERPMfilename replaced by $newVCERPMfilename in the ccp-bsc-rpm.lst\n";
       		system("echo $oldVCERPMfilename replaced by $newVCERPMfilename in the ccp-bsc-rpm.lst>>/root/c5.log");
     			open(CHANG5, "/root/c5.log")||die;
     			$change5=<CHANG5>;
     			chomp($change5);
     			close(CHANG5);
     			system("rm -f /root/c5.log");

     			system("date +%T\\ %F>>/root/date5.txt");
     			open(DATE5, "/root/date5.txt")||die;
     			$date5=<DATE5>;
     			chomp($date5);
     			close(DATE5);
     			system("rm -f /root/date5.txt");

     			$loginfo5="$change5".", $date5.";
     			open(LOG, ">>/root/MXBSC_APP_Patch.log");
     			print LOG "$loginfo5\n";
       
      		 print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
   			}
  			#for tpgsm
   			system("grep $VCERPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/testtpgsmVCERPMfilename.txt");
   			open (FD3, "/root/testtpgsmVCERPMfilename.txt");
   			$tpgsmVCERPMfilenametest=<FD3>;
   			chomp($tpgsmVCERPMfilenametest);
   			system("rm -f /root/testtpgsmVCERPMfilename.txt");
   			if ( $tpgsmVCERPMfilenametest eq $oldVCERPMfilename){
      		#modify the tpgsm-bsc-rpm.lst
       			system("sed -e s/$oldVCERPMfilename/$newVCERPMfilename/ $RPMdir/MXPF/tpgsm-bsc-rpm.lst > /root/c");
       			system("cat /root/c > $RPMdir/MXPF/tpgsm-bsc-rpm.lst");
       			system("rm -f c");
       			system("rm -f /root/testccpVCERPMfilename.txt");
       			print "$oldVCERPMfilename replaced by $newVCERPMfilename in the tpgsm-bsc-rpm.lst\n";
       
       			system("echo $oldVCERPMfilename replaced by $newVCERPMfilename in the tpgsm-bsc-rpm.lst>>/root/c6.log");
       			open(CHANG6, "/root/c6.log")||die;
       			$change6=<CHANG6>;
       			chomp($change6);
       			close(CHANG6);
       			system("rm -f /root/c6.log");

       			system("date +%T\\ %F>>/root/date6.txt");
       			open(DATE6, "/root/date6.txt")||die;
       			$date6=<DATE6>;
       			chomp($date6);
       			close(DATE6);
       			system("rm -f /root/date6.txt");

       			$loginfo6="$change6".", $date6.";
       			open(LOG, ">>/root/MXBSC_APP_Patch.log");
       			print LOG "$loginfo6\n";
       
       			print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
   			}
 
    		#uninstall 
    		if ($eysnumber ==0)
    		 {
     				print "There is no $VCERPMfilename* recorded in the rpm database\n";	    
    		 }
     		else
     		{
     				print "Uninstall the $eoldVCERPMfilename\n";
      			system("rpm -e $eoldVCERPMfilename");
     		} 
    		#install   
    		$eoldVCEfilename=$array[0]."\.P";
    		system("rm -f /common/bsc/SCPRDISK/$eoldVCEfilename*");
    		print "Install the $newVCERPMfilename\n";
    		system("rpm -Uvh --nodeps --force $RPMdir/$newVCERPMfilename");
    		if ( $? !=0){
                system ("echo Error!!! rpm $RPMdir/$newVCERPMfilename install failed | tee -a $logfile");
                exit 1;
                }
    		#update the SDF after installation
    		print "Update the $newVCERPMfilename in the /common/bsc/SCPRDISK/$Mxswdf\n";
	     	system("sed -e '/^#B.LOAD/,/^#E.LOAD/s/$VCERPMfilenamefirst8*.*rpm/$newVCERPMfilename/g' /common/bsc/SCPRDISK/$Mxswdf >/root/d.txt");
	     	system("cat /root/d.txt > /common/bsc/SCPRDISK/$Mxswdf");
	     	system("rm -f /root/d.txt");
   
  }
}
 #Check the format for the newScriptRPMfilename
 elsif(!($newScriptRPMfilename =~ m/^S/))
{
 system("echo Error!The filename you input is not a ScriptRPMfilename, pls check | tee -a $logfile");
 exit 1;
}
else
{
      if(! -e "$RPMdir/$newScriptRPMfilename")
        {
  	     		system( "echo $RPMdir/$newScriptRPMfilename does not exist, copy $newScriptRPMfilename from /root to $RPMdir | tee -a $logfile");
  	      	if (! -e "/root/$newScriptRPMfilename" )
				    	  {
              		  system("echo ERROR!There is no /root/$newScriptRPMfilename and no $RPMdir/$newScriptRPMfilename pls check | tee -a $logfile");
               			exit 1;
              	}
	    	  	else
	      				{
  	       					system("cp -f /root/$newScriptRPMfilename $RPMdir/$newScriptRPMfilename");
               	} 
        }
      else
        {
  	 			system ("echo $RPMdir/$newScriptRPMfilename has already existed, so $newScriptRPMfilename will not be copyed from /root to $RPMdir | tee -a $logfile");
        } 

			#[]---------------------------------------------------[]*/
			#|                                                     |*/
			#|  DO THE NEW VCE FILE RPM PATCH                        |*/
			#|                                                     |*/
			#|                                                     |*/
			#|                                                     |*/
			#|                                                     |*/
			#|                                                     |*/
			#[---------------------------------------------------[]*/
			system("rm -rf /root/temp_Rpm_patch");
			#get the 8.3 format for VCERPMfile
			my @array;
			@array =split (/\./, $newVCERPMfilename);
			$VCERPMfilenamefirst8=$array[0];
			$VCERPMfilename =$array[0]."\.$array[1]";
			my @array_1;
			@array_1=split (/\-/,$VCERPMfilename);
			if ($#array_1 !=0)
			{   
			  $VCERPMfilename=$array_1[0];
			}
			$OrignalVCERPMfilename=$VCERPMfilename."-R1.0-P1.i686.rpm";
						
		#check the version(for example 30W) match with the version on the platform or not
                      system("ls /common/bsc/SCPRDISK |grep $VCERPMfilename >/root/vceBscPackageVersion.txt");                       open (DH, "/root/vceBscPackageVersion.txt");
                      $vceBscPackageVersion=<DH>;
                      chomp($vceBscPackageVersion);
                      close (DH);
		      $vceBscPackageVersionCount=(-s "/root/vceBscPackageVersion.txt");
                      if ($vceBscPackageVersionCount == 0)
		      {
                        system("echo ERROR!There is no $VCERPMfilename* in the directory of /common/bsc/SCPRDISK, pls check,exit | tee -a $logfile");
                        exit 1;
                        	
		      }	
			                
                      system("rm -f /root/vceBscPackageVersion.txt");
                      my @vceBscPackageVersion_check_array;
		      @vceBscPackageVersion_check_array=split (/\./, $vceBscPackageVersion);
                      $vceBscPackageVersion8dot3=@vceBscPackageVersion_check_array[0]."\.$vceBscPackageVersion_check_array[1]";
                                       
		      if($VCERPMfilename ne $vceBscPackageVersion8dot3)
		      {
			 system("echo Error!!! The Bsc package version of the RPM file to be installed is $VCERPMfilename and the Bsc package version of the RPM file installed on the platform is $vceBscPackageVersion8dot3. That means in the /common/bsc/SCPRDISK there is $vceBscPackageVersion8dot3 but no any $VCERPMfilename*. So the two does not match, pls check, exit | tee -a $logfile");
                          exit 1;
		      }			 	
		      	#Check the SDF file name is right or not
		      if(! -e "/common/bsc/SCPRDISK/$Mxswdf")	{
		      	system("echo Error!!! No $Mxswdf exist on /common/bsc/SCPRDISK, please check if you use the right BSC version or check you config file | tee -a $logfile");
		      	exit 1;
		      	}
		#check the VCE RPMfile label match with MX SDF or not
		     system("sed -n -e '/^#B.LOAD/,/^#E.LOAD/p' /common/bsc/SCPRDISK/$Mxswdf >/root/vceloadsegment.txt");
		      system("grep $VCERPMfilename /root/vceloadsegment.txt >/root/vcelabeltest.txt");
		      system("grep $VCERPMfilenamefirst8 /root/vceloadsegment.txt >/root/vcefirst8test.txt");
		      $vcelabeltestcount=(-s "/root/vcelabeltest.txt");
		      $vcefirst8testcount=(-s "/root/vcefirst8test.txt");
		      if ($vcefirst8testcount != 0)
		      {
		      		if ($vcelabeltestcount == 0)
		          		{
                        			system("echo Error!!! The label of $newVCERPMfilename:$VCERPMfilename does not match with the label in the load segment of /common/bsc/SCPRDISK/$Mxswdf, please check, exit | tee -a $logfile");
                        			exit 1;
			 		 }
		      }			 
		      system("rm -f /root/vceloadsegment.txt");
                      system("rm -f /root/vcelabeltest.txt");
		      system("rm -f /root/vcefirst8test.txt");

			#remove the temp file for ScriptRPMfile
					system("rm -f /root/oldScriptRPMfilename.txt");
					system("rm -f /root/esysScriptRPMfilename.txt");
					system("rm -f /root/ccpScriptRPMfilename.txt");
					system("rm -f /root/omcpScriptRPMfilename.txt");
					system("rm -f /root/tpgsmScriptRPMfilename.txt");
					system("rm -f /root/testomcpScriptRPMfilename.txt");
					system("rm -f /root/testccpScriptRPMfilename.txt");
      		system("rm -f /root/testtpgsmScriptRPMfilename.txt");
      #get 8.3 format for ScriptRPMfile
					my @array1;
					@array1 =split (/\./, $newScriptRPMfilename);
					$ScriptRPMfilenamefirst8=$array1[0];
					$ScriptRPMfilename =$array1[0]."\.$array1[1]";
					my @array1_1;
					@array1_1=split (/\-/,$ScriptRPMfilename);
					if ($#array1_1 !=0)
					{   
					  $ScriptRPMfilename=$array1_1[0];
					}
				$OrignalScriptRPMfilename=$ScriptRPMfilename."-R1.0-P1.i686.rpm";
 		      #check the version(for example 30W) match with the version on the platform or not
                      system("ls /common/bsc/SCPRDISK |grep $ScriptRPMfilename >/root/ScriptBscPackageVersion.txt");
                      open (DH, "/root/ScriptBscPackageVersion.txt");
                      $scriptBscPackageVersion=<DH>;
                      chomp($scriptBscPackageVersion);
                      close (DH);
                      $ScriptBscPackageVersionCount=(-s "/root/ScriptBscPackageVersion.txt");
                      if ($ScriptBscPackageVersionCount == 0)
                      {
			system( "echo Error !!There is no $ScriptRPMfilename* in the directory of /common/bsc/SCPRDISK, pls check,exit | tee -a $logfile");
			exit 1;
			} 
                      system("rm -f /root/ScriptBscPackageVersion.txt");
                      my @scriptBscPackageVersion_check_array;
                      @scriptBscPackageVersion_check_array=split (/\./, $scriptBscPackageVersion);
                      $scriptBscPackageVersion8dot3=@scriptBscPackageVersion_check_array[0]."\.$scriptBscPackageVersion_check_array[1]";
                      if($ScriptRPMfilename ne $scriptBscPackageVersion8dot3)
                      {
                         system( "echo Error!!! The Bsc package version of the RPM file to be installed is $ScriptRPMfilename and the Bsc package version of the RPM file installed on the platform is $scriptBscPackageVersion8dot3. That means in the /common/bsc/SCPRDISK there is $scriptBscPackageVersion8dot3* but no any $ScriptRPMfilename*. So the two does not match, pls check, exit | tee -a $logfile");
                                                     exit 1;
                      }               
			# check the Script RPMfile label match with MX SDF or not
				  system("sed -n -e '/^#B.LOAD/,/^#E.LOAD/p' /common/bsc/SCPRDISK/$Mxswdf >/root/Scriptloadsegment.txt");
          system("grep $ScriptRPMfilename /root/Scriptloadsegment.txt >/root/Scriptlabeltest.txt");
	  system("grep $ScriptRPMfilenamefirst8 /root/Scriptloadsegment.txt >/root/Scriptfirst8test.txt");
			    $Scriptlabeltestcount=(-s "/root/Scriptlabeltest.txt");
			    $Scriptfirst8testcount=(-s "/root/Scriptfirst8test.txt");
			    if($Scriptfirst8testcount != 0)
		               {
		    		       if ($Scriptlabeltestcount == 0)
				       {
				           system( "echo ERROR!!! The label of $newScriptRPMfilename:$ScriptRPMfilename does not match with the label in the load segment of /common/bsc/SCPRDISK/$Mxswdf, please check, exit! | tee -a $logfile");	
				       exit 1;
				       }
			       }	       
				   system("rm -f /root/Scriptloadsegment.txt");
				   system("rm -f /root/Scriptlabeltest.txt");  
                                   system("rm -f /root/Scriptfirst8test.txt"); 
			#Check the /root/oldVCERPMfilename.txt
			system ("grep $VCERPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/oldVCERPMfilename.txt");
			system ("grep $VCERPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/oldVCERPMfilename.txt");
			system ("grep $VCERPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/oldVCERPMfilename.txt");
			
			$o=(-s "/root/oldVCERPMfilename.txt");
      if ($o == 0){
				       system ("echo There is no a record $VCERPMfilename* in the omcp-bscpatch-rpm.lst and ccp-bsc-rpm.lst and tpgsm-bsc-rpm.lst | tee -a $logfile");
				             
				             if(-e "/common/bsc/SCPRDISK/$VCERPMfilename")
				              {
				                system("mkdir /root/temp_Rpm_patch");
				                system("cp -f /common/bsc/SCPRDISK/$VCERPMfilename /root/temp_Rpm_patch");
				              }else
				              {
				                  system ( "echo Error!The default file:$VCERPMfilename does not exist in the directory of /common/bsc/SCPRDISK.| tee -a $logfile");
				                  exit 1;
				               }
				               #unistall
				              system("rpm -qa | grep $VCERPMfilename >>/root/esysVCERPMfilename.txt");
				              open (DH, "/root/esysVCERPMfilename.txt");
				              $esysVCERPMfilename=<DH>;
				              chomp($esysVCERPMfilename);
				              close (DH);
				              $eysnumber=(-s "/root/esysVCERPMfilename.txt");
				              system("rm -f /root/esysVCERPMfilename.txt");
				              if ($eysnumber ==0)
				              {
				               system( "echo There is no $VCERPMfilename* recorded in the rpm database | tee -a $logfile");	    
				               }
				              else
				              {
				     	         system ("echo Uninstall the $esysVCERPMfilename | tee -a $logfile");
				                system("rpm -e $esysVCERPMfilename");
				               }   
				              #install 
				              system ("echo Install the $newVCERPMfilename | tee -a $logfile");
				              system("rpm -Uvh --nodeps --force $RPMdir/$newVCERPMfilename");
				              if ( $? !=0){
             					system ("echo Error!!! rpm $RPMdir/$newVCERPMfilename install failed | tee -a $logfile");
             					exit 1;
            					 }
				                if (not -e "/common/bsc/SCPRDISK/$VCERPMfilename")
				               {
				               #print "cp -f /root/temp_Rpm_patch/$VCERPMfilename /common/bsc/SCPRDISK \n";
				               system("cp -f /root/temp_Rpm_patch/$VCERPMfilename /common/bsc/SCPRDISK");
				               }
				 
				               if(-e "/common/bsc/SCPRDISK/$VCERPMfilename")
				               {
				                system("rm -rf /root/temp_Rpm_patch");
				                }
				                #add the newVCERPMfilename to omcp-bscpatch-rpm.lst
				                if($newVCERPMfilename eq $OrignalVCERPMfilename)
                        {
            	            system ("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst .| tee -a $logfile");
            	            system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
            	            open(ADD, "/root/vce.log")||die;
             	            $add=<ADD>;
             	            chomp($add);
             	            close(ADD);
             	            system("rm -f /root/vce.log");

             	            system("date +%T\\ %F>>/root/adddate.txt");
             	            open(ADDDATE, "/root/adddate.txt")||die;
             	            $adddate=<ADDDATE>;
                          chomp($adddate);
             	            close(ADDDATE);
             	            system("rm -f /root/adddate.txt"); 
             	            $addloginfo="$add".", $adddate.";
             	            open(LOG, ">>/root/MXBSC_APP_Patch.log");
             	            print LOG "$addloginfo\n"; 
                        }
                       else
				               {  
				               system("echo $newVCERPMfilename >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
					             system( "echo $newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst | tee -a $logfile");
				               system("echo $newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
				               open(ADD, "/root/vce.log")||die;
				               $add=<ADD>;
				               chomp($add);
				               close(ADD);
				               system("rm -f /root/vce.log");
				
				               system("date +%T\\ %F>>/root/adddate.txt");
				               open(ADDDATE, "/root/adddate.txt")||die;
				               $adddate=<ADDDATE>;
				               chomp($adddate);
				               close(ADDDATE);
				               system("rm -f /root/adddate.txt"); 
				               $addloginfo="$add".", $adddate.";
				               open(LOG, ">>/root/MXBSC_APP_Patch.log");
				               print LOG "$addloginfo\n";
				              }
				               print "The change has been recorded in /root/MXBSC_APP_Patch.log\n"; 
      }
      else
      {
				    #get the information needed:oldVCERPMfilename, eoldVCERPMfilename, esysRPMfilename 
				     open (PWD, "/root/oldVCERPMfilename.txt");
				     $oldVCERPMfilename=<PWD>;
				     chomp($oldVCERPMfilename);
				     close (PWD);
				     #print "oldVCERPMfilename is $oldVCERPMfilename\n";
				     my @Array;
				     @Array =split (/\./, $oldVCERPMfilename);
				     if($#Array ==5)
				       {
				       	$eoldVCERPMfilename=$Array[0]."\.$Array[1]"."\.$Array[2]"."\.$Array[3]";
				       }
				     if($#Array == 4)
				       {
				       	$eoldVCERPMfilename=$Array[0]."\.$Array[1]"."\.$Array[2]";
				       }  	
				     system("rpm -qa | grep $VCERPMfilename >>/root/esysVCERPMfilename.txt");
				     open (DH, "/root/esysVCERPMfilename.txt");
				     $esysVCERPMfilename=<DH>;
				     chomp($esysVCERPMfilename);
				     close (DH);
				     $eysnumber=(-s "/root/esysVCERPMfilename.txt");
				     system("rm -f /root/oldVCERPMfilename.txt");
				     system("rm -f /root/esysVCERPMfilename.txt");
				     #Check the RPM installed in the system and the oldVCERPMfilename :match or not
				
				     system("grep $VCERPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/ccpVCERPMfilename.txt ");
				     system("grep $VCERPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/omcpVCERPMfilename.txt");
				     system("grep $VCERPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/tpgsmVCERPMfilename.txt");
				     $a=(-s "/root/ccpVCERPMfilename.txt");
				     $b=(-s "/root/omcpVCERPMfilename.txt");
				     $c=(-s "/root/tpgsmVCERPMfilename.txt");
				     if(($a != 0)&&($b != 0)){
				         open (DY1, "/root/ccpVCERPMfilename.txt");
				         $oldVCERPMfilename_ccplst=<DY1>;
				         chomp($oldVCERPMfilename_ccplst);
					 #print "oldVCERPMfilename_ccplst is $oldVCERPMfilename_ccplst\n";
				         open (DY2, "/root/omcpVCERPMfilename.txt");
				         $oldVCERPMfilename_omcplst=<DY2>;
				         chomp($oldVCERPMfilename_omcplst);
					 #print "oldVCERPMfilename_omcplst is $oldVCERPMfilename_omcplst\n";
				         if ( $oldVCERPMfilename_ccplst ne $oldVCERPMfilename_omcplst){
				             system( "echo Error!!!The oldVCERPMfilename in ccp-bsc-rpm.lst is $oldVCERPMfilename_ccplst;the oldVCERPMfilename in omcp-bscpatch-rpm.lst is $oldVCERPMfilename_omcplst, the two do not match.| tee -a $logfile");
				             exit 1;
				         }         
				      }
				      if (($a != 0)&&($c != 0)){
				         open (DY1, "/root/ccpVCERPMfilename.txt");
				         $oldVCERPMfilename_ccplst=<DY1>;
				         chomp($oldVCERPMfilename_ccplst);
				         open (DY3, "/root/tpgsmVCERPMfilename.txt");
				         $oldVCERPMfilename_tpgsmlst=<DY3>;
				         chomp($oldVCERPMfilename_tpgsmlst);
				         if ($oldVCERPMfilename_ccplst ne $oldVCERPMfilename_tpgsmlst){
				             system ("echo Error!!!The oldVCERPMfilename in ccp-bsc-rpm.lst is $oldVCERPMfilename_ccplst;the oldVCERPMfilename in tpgsm-bsc-rpm.lst is $oldVCERPMfilename_tpgsmlst, the two do not match.| tee -a $logfile");
				             exit 1;
				         }
				      }
				      if(($b != 0)&&($c != 0)){
				         open (DY2, "/root/omcpVCERPMfilename.txt");
				         $oldVCERPMfilename_omcplst=<DY2>;
				         chomp($oldVCERPMfilename_omcplst);
				         open (DY3, "/root/tpgsmVCERPMfilename.txt");
				         $oldVCERPMfilename_tpgsmlst=<DY3>;
				         chomp($oldVCERPMfilename_tpgsmlst);
				         if ($oldVCERPMfilename_omcplst ne $oldVCERPMfilename_tpgsmlst){
				              system ("echo Error!!!The oldVCERPMfilename in tpgsm-bsc-rpm.lst is $oldVCERPMfilename_tpgsmlst;the oldVCERPMfilename in omcp-bscpatch-rpm.lst is $oldVCERPMfilename_omcplst, the two do not match | tee -a $logfile");
				             exit 1;
				         }
				      }
				      #result of rpm -qa(esysVCERPMfilename, eold is in list)
				      if($eysnumber !=0){  
				               if ("$esysVCERPMfilename" ne "$eoldVCERPMfilename"){
				                  if ($a != 0){
				                         system ("echo Error!!!The RPM ($esysVCERPMfilename) installed in system and the RPM ($eoldVCERPMfilename) in the ccp-bsc-rpm.lst does not match! | tee -a $logfile");
				                   }
				                  if ($b != 0){
				                        system  ("echo Error!!!The RPM ($esysVCERPMfilename) installed in system and the RPM ($eoldVCERPMfilename) in the omcp-bscpatch-rpm.lst does not match! | tee -a $logfile");
				                  }
				                  if ($c != 0){
				                           system ("echo Error!!!The RPM ($esysVCERPMfilename) installed in system and the RPM ($eoldVCERPMfilename) in the tpgsm-bsc-rpm.lst does not match! | tee -a $logfile");
				                   } 
				                exit 1;
				               }
				       }	 
							system("rm -f /root/ccpVCERPMfilename.txt");
							system("rm -f /root/omcpVCERPMfilename.txt");
							system("rm -f /root/tpgsmVCERPMfilename.txt");
							
							#grep and replace
							  #for omcp
							system("grep $VCERPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/testomcpVCERPMfilename.txt");
							open (FD1, "/root/testomcpVCERPMfilename.txt");
							$omcpVCERPMfilenametest=<FD1>;
							chomp($omcpVCERPMfilenametest);
							#If omcp-bscpatch-rpm.lst does not have any $VCERPMfilename ,then add $newVCERPMfilename to omcp-bscpatch-rpm.lst
					  		$omcpvce=(-s "/root/testomcpVCERPMfilename.txt");
					  		if($omcpvce ==0){#start if no record for omcp list
					  	         #add $newVCERPMfilename to omcp-bscpatch-rpm.lst,if the patch file name is the orignal name,it is uninstall,no necessary add to patch list
					  	         if($newVCERPMfilename eq $OrignalVCERPMfilename)
                        {
            	            system( "echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst .| tee -a $logfile");
            	            system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
            	            open(ADD, "/root/vce.log")||die;
             	            $add=<ADD>;
             	            chomp($add);
             	            close(ADD);
             	            system("rm -f /root/vce.log");

             	            system("date +%T\\ %F>>/root/adddate.txt");
             	            open(ADDDATE, "/root/adddate.txt")||die;
             	            $adddate=<ADDDATE>;
                          chomp($adddate);
             	            close(ADDDATE);
             	            system("rm -f /root/adddate.txt"); 
             	            $addloginfo="$add".", $adddate.";
             	            open(LOG, ">>/root/MXBSC_APP_Patch.log");
             	            print LOG "$addloginfo\n"; 
                        }
                       else
					  	          {
					  	            system("echo $newVCERPMfilename >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
						              system("echo $newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.ls | tee -a $logfile");	 
					                system("echo $newVCERPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/vce.log");
					                open(ADD, "/root/vce.log")||die;
					                $add=<ADD>;
					                chomp($add);
					                close(ADD);
					                system("rm -f /root/vce.log");
					
					                system("date +%T\\ %F>>/root/adddate.txt");
					                open(ADDDATE, "/root/adddate.txt")||die;
					                $adddate=<ADDDATE>;
					                chomp($adddate);
					                close(ADDDATE);
					                system("rm -f /root/adddate.txt"); 
					                $addloginfo="$add".", $adddate.";
					                open(LOG, ">>/root/MXBSC_APP_Patch.log");
					                print LOG "$addloginfo\n";
					              }
					             print "The change has been recorded in /root/MXBSC_APP_Patch.log\n"; 
					  	   }	#end if no record for omcp list
  		        system("rm -f /root/testomcpVCERPMfilename.txt");
  		        #If omcp-bscpatch-rpm.lst has one $VCERPMfilename, then replace the old one with the $newVCERPMfilename
							if ( $omcpVCERPMfilenametest eq $oldVCERPMfilename){
							     #modify the omcp-bscpatch-rpm.lst
							     if($newVCERPMfilename eq $OrignalVCERPMfilename)
							     {
							       system( "echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst | tee -a $logfile");
            	       system("sed -e '/^$VCERPMfilename/d' $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >/root/c");
							       system("cat /root/c >$OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
										 system("rm -f /root/c");
										 system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/c4.log");
										 open(CHANG4, "/root/c4.log")||die;
							       $change4=<CHANG4>;
							       chomp($change4);
							       close(CHANG4);
							       system("rm -f /root/c4.log");
							
							       system("date +%T\\ %F>>/root/date4.txt");
							       open(DATE4, "/root/date4.txt")||die;
							       $date4=<DATE4>;
							       chomp($date4);
							       close(DATE4);
							       system("rm -f /root/date4.txt");
							
							       $loginfo4="$change4".", $date4.";
							       open(LOG, ">>/root/MXBSC_APP_Patch.log");
							       print LOG "$loginfo4\n";
							     }
							     else
							     {
							     system("sed -e s/$oldVCERPMfilename/$newVCERPMfilename/ $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst > /root/c");
							     system("cat /root/c > $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
							     system("rm -f /root/c");
							     system("rm -f /root/testomcpVCERPMfilename.txt");
							     system( "echo $oldVCERPMfilename replaced by $newVCERPMfilename in the omcp-bscpatch-rpm.lst | tee -a $logfile");
							      system("echo $oldVCERPMfilename replaced by $newVCERPMfilename in the omcp-bscpatch-rpm.lst>>/root/c4.log");
							     open(CHANG4, "/root/c4.log")||die;
							     $change4=<CHANG4>;
							     chomp($change4);
							     close(CHANG4);
							     system("rm -f /root/c4.log");
							
							     system("date +%T\\ %F>>/root/date4.txt");
							     open(DATE4, "/root/date4.txt")||die;
							     $date4=<DATE4>;
							     chomp($date4);
							     close(DATE4);
							     system("rm -f /root/date4.txt");
							
							     $loginfo4="$change4".", $date4.";
							     open(LOG, ">>/root/MXBSC_APP_Patch.log");
							     print LOG "$loginfo4\n";
							     }     
							     print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
							  } #end of omcp replace
							  #for ccp
							  system("grep $VCERPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/testccpVCERPMfilename.txt");
							  open (FD2, "/root/testccpVCERPMfilename.txt");
							  $ccpVCERPMfilenametest=<FD2>;
							  chomp($ccpVCERPMfilenametest);
							  system("rm -f /root/testccpVCERPMfilename.txt");
							  if ( $ccpVCERPMfilenametest eq $oldVCERPMfilename){
									       #modify the ccp-bsc-rpm.lst
									       system("sed -e s/$oldVCERPMfilename/$newVCERPMfilename/ $RPMdir/MXPF/ccp-bsc-rpm.lst > /root/c");
									       system("cat /root/c > $RPMdir/MXPF/ccp-bsc-rpm.lst");
									       system("rm -f /root/c");
									       system("rm -f /root/testccpVCERPMfilename.txt");
									       print "$oldVCERPMfilename replaced by $newVCERPMfilename in the ccp-bsc-rpm.lst\n";
									       system("echo $oldVCERPMfilename replaced by $newVCERPMfilename in the ccp-bsc-rpm.lst>>/root/c5.log");
										     open(CHANG5, "/root/c5.log")||die;
										     $change5=<CHANG5>;
										     chomp($change5);
										     close(CHANG5);
										     system("rm -f /root/c5.log");
										
										     system("date +%T\\ %F>>/root/date5.txt");
										     open(DATE5, "/root/date5.txt")||die;
										     $date5=<DATE5>;
										     chomp($date5);
										     close(DATE5);
										     system("rm -f /root/date5.txt");
										
										     $loginfo5="$change5".", $date5.";
										     open(LOG, ">>/root/MXBSC_APP_Patch.log");
										     print LOG "$loginfo5\n";
										       
										     print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
							   }
								  #for tpgsm
								  system("grep $VCERPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/testtpgsmVCERPMfilename.txt");
								  open (FD3, "/root/testtpgsmVCERPMfilename.txt");
								  $tpgsmVCERPMfilenametest=<FD3>;
								  chomp($tpgsmVCERPMfilenametest);
								  system("rm -f /root/testtpgsmVCERPMfilename.txt");
								  if ( $tpgsmVCERPMfilenametest eq $oldVCERPMfilename){
								      #modify the tpgsm-bsc-rpm.lst
								       system("sed -e s/$oldVCERPMfilename/$newVCERPMfilename/ $RPMdir/MXPF/tpgsm-bsc-rpm.lst > /root/c");
								       system("cat /root/c > $RPMdir/MXPF/tpgsm-bsc-rpm.lst");
								       system("rm -f /root/c");
								       system("rm -f /root/testccpVCERPMfilename.txt");
								       system( "echo $oldVCERPMfilename replaced by $newVCERPMfilename in the tpgsm-bsc-rpm.lst | tee -a $logfile");
								       
								       system("echo $oldVCERPMfilename replaced by $newVCERPMfilename in the tpgsm-bsc-rpm.lst>>/root/c6.log");
									     open(CHANG6, "/root/c6.log")||die;
									     $change6=<CHANG6>;
									     chomp($change6);
									     close(CHANG6);
									     system("rm -f /root/c6.log");
									
									     system("date +%T\\ %F>>/root/date6.txt");
									     open(DATE6, "/root/date6.txt")||die;
									     $date6=<DATE6>;
									     chomp($date6);
									     close(DATE6);
									     system("rm -f /root/date6.txt");
									
									     $loginfo6="$change6".", $date6.";
									     open(LOG, ">>/root/MXBSC_APP_Patch.log");
									     print LOG "$loginfo6\n";
									       
									     print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
								   }
									 
									 #uninstall
									 if(-e "/common/bsc/SCPRDISK/$VCERPMfilename")
									 {
									  system("mkdir /root/temp_Rpm_patch");
									  system("cp -f /common/bsc/SCPRDISK/$VCERPMfilename /root/temp_Rpm_patch");
									 }else
									 {
									  system ("echo Error!The default file:$VCERPMfilename does not exist in the directory of /common/bsc/SCPRDISK | tee -a $logfile");
									 exit 1;
									 }
									
									    if($eysnumber ==0)
									     {
										   system( "echo There is no $VCERPMfilename* recorded in the rpm database | tee -a $logfile"); 
									      }
									     else
									     {
									    	   system ("echo Uninstall the $eoldVCERPMfilename | tee -a $logfile");
									                system("rpm -e $eoldVCERPMfilename");
									     }  
									 $eoldVCEfilename=$array[0]."\.P";
									 system("rm -f /common/bsc/SCPRDISK/$eoldVCEfilename*");
									 #install
									 system( "echo Install the $newVCERPMfilename | tee -a $logfile");
									 system("rpm -Uvh --nodeps --force $RPMdir/$newVCERPMfilename");
									 if ( $? !=0){
            								 system ("echo Error!!! rpm $RPMdir/$newVCERPMfilename install failed | tee -a $logfile");
            								 exit 1;
            								 }
									          if (not -e "/common/bsc/SCPRDISK/$VCERPMfilename")
									            {
									               #print "cp -f /root/temp_Rpm_patch/$VCERPMfilename /common/bsc/SCPRDISK \n";
									               system("cp -f /root/temp_Rpm_patch/$VCERPMfilename /common/bsc/SCPRDISK");
									            }
									 
									         if(-e "/common/bsc/SCPRDISK/$VCERPMfilename")
									           {
									             system("rm -rf /root/temp_Rpm_patch");
									            }
									  #update SDF after installation
									  system( "echo Update the $newVCERPMfilename in the /common/bsc/SCPRDISK/$Mxswdf | tee -a $logfile");
									  system("sed -e '/^#B.LOAD/,/^#E.LOAD/s/$VCERPMfilenamefirst8*.*rpm/$newVCERPMfilename/g' /common/bsc/SCPRDISK/$Mxswdf >/root/e.txt");
									  system("cat /root/e.txt > /common/bsc/SCPRDISK/$Mxswdf");
									  system("rm -f /root/e.txt");
       }
					#[]---------------------------------------------------[]*/
					#|                                                     |*/
					#|  DO THE NEW SCRIPTFILE RPM PATCH                        |*/
					#|                                                     |*/
					#|                                                     |*/
					#|                                                     |*/
					#|                                                     |*/
					#|                                                     |*/
					#[---------------------------------------------------[]*/


					

					system ("grep $ScriptRPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/oldScriptRPMfilename.txt");
					system ("grep $ScriptRPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/oldScriptRPMfilename.txt");
					system ("grep $ScriptRPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/oldScriptRPMfilename.txt");

					#Check the /root/oldScriptRPMfilename.txt
					$o1=(-s "/root/oldScriptRPMfilename.txt");
					if ($o1 == 0){
					    print "There is no a record $ScriptRPMfilename* in the omcp-bscpatch-rpm.lst and ccp-bsc-rpm.lst and tpgsm-bsc-rpm.lst.\n";
					      #uninstall
					      system("rpm -qa | grep $ScriptRPMfilename >>/root/esysScriptRPMfilename.txt");
					      open (DH1, "/root/esysScriptRPMfilename.txt");
					      $esysScriptRPMfilename=<DH1>;
					      chomp($esysScriptRPMfilename);
					      close (DH1);
					      $esysScriptnumber=(-s "/root/esysScriptRPMfilename.txt");
					      system("rm -f /root/esysScriptRPMfilename.txt");
					      if($esysScriptnumber ==0)
					       {
					   	    system( "echo There is no $ScriptRPMfilename* recorded in the rpm database | tee -a $logfile");
					       }
					       else
					       {
					    	 system ("echo Uninstall the $esysScriptRPMfilename | tee -a $logfile");
					    	 system("rpm -e $esysScriptRPMfilename");
					       }    
					      #install 
					      system ("echo Install the $newScriptRPMfilename | tee -a $logfile");
					      system("rpm -Uvh --nodeps --force $RPMdir/$newScriptRPMfilename");
					      if ( $? !=0){
       						system ("echo Error!!! rpm $RPMdir/$newScriptRPMfilename install failed | tee -a $logfile");
       						exit 1;
             					}
					       #add the newScriptRPMfilename to omcp-bscpatch-rpm.lst
					       if( $newScriptRPMfilename eq $OrignalScriptRPMfilename)
					       {
					       	system( "echo $newScriptRPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst | tee -a $logfile");
            	    system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/script.log");
            	    open(ADD1, "/root/script.log")||die;
								  $add1=<ADD1>;
								  chomp($add1);
								  close(ADD1);
								  system("rm -f /root/script.log");
								
								  system("date +%T\\ %F>>/root/adddate1.txt");
								  open(ADDDATE1, "/root/adddate1.txt")||die;
								  $adddate1=<ADDDATE1>;
								  chomp($adddate1);
								  close(ADDDATE1);
								  system("rm -f /root/adddate1.txt"); 
								  $addloginfo1="$add1".", $adddate1.";
								  open(LOG, ">>/root/MXBSC_APP_Patch.log");
								  print LOG "$addloginfo1\n";
					       }
					       else
					       { 
				         system("echo $newScriptRPMfilename >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
					       system( "echo $newScriptRPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/script.log | tee -a $logfile");
								 system("echo $newScriptRPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/script.log");
								 open(ADD1, "/root/script.log")||die;
								 $add1=<ADD1>;
								 chomp($add1);
								 close(ADD1);
								 system("rm -f /root/script.log");
								
								 system("date +%T\\ %F>>/root/adddate1.txt");
								 open(ADDDATE1, "/root/adddate1.txt")||die;
								 $adddate1=<ADDDATE1>;
								 chomp($adddate1);
								 close(ADDDATE1);
								 system("rm -f /root/adddate1.txt"); 
								 $addloginfo1="$add1".", $adddate1.";
								 open(LOG, ">>/root/MXBSC_APP_Patch.log");
								 print LOG "$addloginfo1\n";
								}        
								 print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";  
					             
					}
				else
					{
						#get the information needed:oldScriptRPMfilename, eoldScriptRPMfilename, esysScriptRPMfilename 

								open (PWD1, "/root/oldScriptRPMfilename.txt");
								$oldScriptRPMfilename=<PWD1>;
								chomp($oldScriptRPMfilename);
								close (PWD1);
								#print "oldScriptRPMfilename is $oldScriptRPMfilename\n";
								my @Array1;
								@Array1 =split (/\./, $oldScriptRPMfilename);
								if ($#Array1 ==5)
								  {
								   $eoldScriptRPMfilename=$Array1[0]."\.$Array1[1]"."\.$Array1[2]"."\.$Array1[3]";
								  }
								if ($#Array1 ==4)
								  {
								  	$eoldScriptRPMfilename=$Array1[0]."\.$Array1[1]"."\.$Array1[2]";
								  }  
								system("rpm -qa | grep $ScriptRPMfilename >>/root/esysScriptRPMfilename.txt");
								open (DH1, "/root/esysScriptRPMfilename.txt");
								$esysScriptRPMfilename=<DH1>;
								chomp($esysScriptRPMfilename);
								close (DH1);
								$esysScriptnumber=(-s "/root/esysScriptRPMfilename.txt");
								system("rm -f /root/oldScriptRPMfilename.txt");
								system("rm -f /root/esysScriptRPMfilename.txt");
								#Check the RPM installed in the system and the oldScriptRPMfilename :match or not
								
								system("grep $ScriptRPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/ccpScriptRPMfilename.txt ");
								system("grep $ScriptRPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/omcpScriptRPMfilename.txt");
								system("grep $ScriptRPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/tpgsmScriptRPMfilename.txt");
								$a1=(-s "/root/ccpScriptRPMfilename.txt");
								$b1=(-s "/root/omcpScriptRPMfilename.txt");
								$c1=(-s "/root/tpgsmScriptRPMfilename.txt");
								if(($a1 != 0)&&($b1 != 0)){
								   open (CM1, "/root/ccpScriptRPMfilename.txt");
								   $oldScriptRPMfilename_ccplst=<CM1>;
								   chomp($oldScriptRPMfilename_ccplst);
								#  print "oldScriptRPMfilename_ccplst is $oldScriptRPMfilename_ccplst\n";
								   open (CM2, "/root/omcpScriptRPMfilename.txt");
								   $oldScriptRPMfilename_omcplst=<CM2>;
								   chomp($oldScriptRPMfilename_omcplst);
								#   print "oldScriptRPMfilename_omcplst is $oldScriptRPMfilename_omcplst\n";
								   if ( $oldScriptRPMfilename_ccplst ne $oldScriptRPMfilename_omcplst){
								       system ("echo Error!!!The oldScriptRPMfilename in ccp-bsc-rpm.lst is $oldScriptRPMfilename_ccplst,the oldScriptRPMfilename in omcp-bscpatch-rpm.lst is $oldScriptRPMfilename_omcplst, the two do not match | tee -a $logfile");
								       exit 1;
								     }         
								}
								if (($a1 != 0)&&($c1 != 0)){
								   open (CM1, "/root/ccpScriptRPMfilename.txt");
								   $oldScriptRPMfilename_ccplst=<CM1>;
								   chomp($oldScriptRPMfilename_ccplst);
								   open (CM3, "/root/tpgsmScriptRPMfilename.txt");
								   $oldScriptRPMfilename_tpgsmlst=<CM3>;
								   chomp($oldScriptRPMfilename_tpgsmlst);
								   if ($oldScriptRPMfilename_ccplst ne $oldScriptRPMfilename_tpgsmlst){
								    system ("echo Error!!!The oldScriptRPMfilename in ccp-bsc-rpm.lst is $oldScriptRPMfilename_ccplst;the oldScriptRPMfilename in tpgsm-bsc-rpm.lst is $oldScriptRPMfilename_tpgsmlst, the two do not match | tee -a $logfile");
								    exit 1;
								    }
								}
								if(($b1 != 0)&&($c1 != 0)){
								  open (CM2, "/root/omcpScriptRPMfilename.txt");
								  $oldScriptRPMfilename_omcplst=<CM2>;
								  chomp($oldScriptRPMfilename_omcplst);
								  open (CM3, "/root/tpgsmScriptRPMfilename.txt");
								  $oldScriptRPMfilename_tpgsmlst=<CM3>;
								  chomp($oldScriptRPMfilename_tpgsmlst);
								  if ($oldScriptRPMfilename_omcplst ne $oldScriptRPMfilename_tpgsmlst){
								    system ("echo Error!!!The oldScriptRPMfilename in tpgsm-bsc-rpm.lst is $oldScriptRPMfilename_tpgsmlst;the oldScriptRPMfilename in omcp-bscpatch-rpm.lst is $oldScriptRPMfilename_omcplst, the two do not match | tee -a $logfile");
								    exit 1;
								   }
								}   
								     if($esysScriptnumber !=0)
								      { 
								         if ("$esysScriptRPMfilename" ne "$eoldScriptRPMfilename"){
								             if ($a1 != 0){
								                    system ("echo Error!!!The RPM ($esysScriptRPMfilename) installed in system and the RPM ($eoldScriptRPMfilename) in the ccp-bsc-rpm.lst does not match | tee -a  $logfile");
								                          }
								             if ($b1 != 0){
								                         system ("echo Error!!!The RPM ($esysScriptRPMfilename) installed in system and the RPM ($eoldScriptRPMfilename) in the omcp-bscpatch-rpm.lst does not match | tee -a $logfile");
								                          }
								              if ($c1 != 0){
								                           system ("echo Error!!!The RPM ($esysScriptRPMfilename) installed in system and the RPM ($eoldScriptRPMfilename) in the tpgsm-bsc-rpm.lst does not match! | tee -a $logfile");
								                            } 
								                    exit 1;
								                }
								      }		
								system("rm -f /root/ccpScriptRPMfilename.txt");
								system("rm -f /root/omcpScriptRPMfilename.txt");
								system("rm -f /root/tpgsmScriptRPMfilename.txt");
								
								
								#grep and replace
								  #for omcp
								system("grep $ScriptRPMfilename $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >> /root/testomcpScriptRPMfilename.txt");
								open (CN1, "/root/testomcpScriptRPMfilename.txt");
								$omcpScriptRPMfilenametest=<CN1>;
								chomp($omcpScriptRPMfilenametest);
								# If the omco-bsc-rpm.lst does not have $ScriptRPMfilename ,add the $ScriptRPMfilename to the omcp-bscpatch-rpm.lst
								$omcpscript=(-s "/root/testomcpScriptRPMfilename.txt");
								if($omcpscript == 0)
								{
									           if( $newScriptRPMfilename eq $OrignalScriptRPMfilename)
					        					{
					       							system( "echo $newScriptRPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst | tee -a $logfile");
            	    						system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/script.log");
            	    						open(ADD1, "/root/script.log")||die;
								             	$add1=<ADD1>;
								             	chomp($add1);
								             	close(ADD1);
								             	system("rm -f /root/script.log");
								
								             	system("date +%T\\ %F>/root/adddate1.txt");
								             	open(ADDDATE1, "/root/adddate1.txt")||die;
								             	$adddate1=<ADDDATE1>;
								            	chomp($adddate1);
								             	close(ADDDATE1);
								             	system("rm -f /root/adddate1.txt"); 
								             	$addloginfo1="$add1".", $adddate1.";
								             	open(LOG, ">>/root/MXBSC_APP_Patch.log");
								             	print LOG "$addloginfo1\n"
            	     					}
            	     					else
            	     					{
									           system("echo $newScriptRPMfilename >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
								             system( "echo $newScriptRPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst | tee -a $logfile");
								             system("echo $newScriptRPMfilename is added to $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>/root/script.log");
								             open(ADD1, "/root/script.log")||die;
								             $add1=<ADD1>;
								             chomp($add1);
								             close(ADD1);
								             system("rm -f /root/script.log");
								
								             system("date +%T\\ %F>/root/adddate1.txt");
								             open(ADDDATE1, "/root/adddate1.txt")||die;
								             $adddate1=<ADDDATE1>;
								             chomp($adddate1);
								             close(ADDDATE1);
								             system("rm -f /root/adddate1.txt"); 
								             $addloginfo1="$add1".", $adddate1.";
								             open(LOG, ">>/root/MXBSC_APP_Patch.log");
								             print LOG "$addloginfo1\n";
								          	}
								             print "The change has been recorded in /root/MXBSC_APP_Patch.log\n"; 
								}
								system("rm -f /root/testomcpScriptRPMfilename.txt");
								
								#If omcp-bscpatch-rpm.lst have the $ScriptRPMfilename the tool just to replace the old one with the new one.
								if ( $omcpScriptRPMfilenametest eq $oldScriptRPMfilename){
								     #modify the omcp-bscpatch-rpm.lst
								    if( $newScriptRPMfilename eq $OrignalScriptRPMfilename)
								    {
								    	system("echo $newScriptRPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst .| tee -a $logfile");
								    	system("sed -e '/^$ScriptRPMfilename/d' $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst >/root/c");
							       	system("cat /root/c >$OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
											system("rm -f /root/c");
											system("rm -f /root/testomcpScriptRPMfilename.txt");
            	    		system("echo $newVCERPMfilename is installed into RPM base but not added into $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst>>/root/c1.log");
            	    		open(CHANG1, "/root/c1.log")||die;
								     	$change1=<CHANG1>;
								     	chomp($change1);
								     	close(CHANG1);
								     	system("rm -f /root/c1.log");
								
								     	system("date +%T\\ %F>>/root/date1.txt");
								     	open(DATE1, "/root/date1.txt")||die;
								     	$date1=<DATE1>;
								     	chomp($date1);
								     	close(DATE1);
								     	system("rm -f /root/date1.txt");
								
								     	$loginfo1="$change1".", $date1.";
								     	open(LOG, ">>/root/MXBSC_APP_Patch.log");
								     	print LOG "$loginfo1\n";
								    }
								    else
								    { 
								     system("sed -e s/$oldScriptRPMfilename/$newScriptRPMfilename/ $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst > /root/c");
								     system("cat /root/c > $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");
								     system("rm -f /root/c");
								     system("rm -f /root/testomcpScriptRPMfilename.txt");
								     print "$oldScriptRPMfilename replaced by $newScriptRPMfilename in the omcp-bscpatch-rpm.lst\n";
								     system("echo $oldScriptRPMfilename replaced by $newScriptRPMfilename in the omcp-bscpatch-rpm.lst>>/root/c1.log");
								     open(CHANG1, "/root/c1.log")||die;
								     $change1=<CHANG1>;
								     chomp($change1);
								     close(CHANG1);
								     system("rm -f /root/c1.log");
								
								     system("date +%T\\ %F>>/root/date1.txt");
								     open(DATE1, "/root/date1.txt")||die;
								     $date1=<DATE1>;
								     chomp($date1);
								     close(DATE1);
								     system("rm -f /root/date1.txt");
								
								     $loginfo1="$change1".", $date1.";
								     open(LOG, ">>/root/MXBSC_APP_Patch.log");
								     print LOG "$loginfo1\n";
								    }
								     print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
								  }
								  #for ccp
								  system("grep $ScriptRPMfilename $RPMdir/MXPF/ccp-bsc-rpm.lst >> /root/testccpScriptRPMfilename.txt");
								  open (CN2, "/root/testccpScriptRPMfilename.txt");
								  $ccpScriptRPMfilenametest=<CN2>;
								  chomp($ccpScriptRPMfilenametest);
								  system("rm -f /root/testccpScriptRPMfilename.txt");
								  if ( $ccpScriptRPMfilenametest eq $oldScriptRPMfilename){
								       #modify the ccp-bsc-rpm.lst
								       system("sed -e s/$oldScriptRPMfilename/$newScriptRPMfilename/ $RPMdir/MXPF/ccp-bsc-rpm.lst > /root/c");
								       system("cat /root/c > $RPMdir/MXPF/ccp-bsc-rpm.lst");
								       system("rm -f /root/c");
								       system("rm -f /root/testccpScriptRPMfilename.txt");
								       print "$oldScriptRPMfilename replaced by $newScriptRPMfilename in the ccp-bsc-rpm.lst\n";
								     system("echo $oldScriptRPMfilename replaced by $newScriptRPMfilename in the ccp-bsc-rpm.lst>>/root/c2.log");
								     open(CHANG2, "/root/c2.log")||die;
								     $change2=<CHANG2>;
								     chomp($change2);
								     close(CHANG2);
								     system("rm -f /root/c2.log");
								
								     system("date +%T\\ %F>>/root/date2.txt");
								     open(DATE2, "/root/date2.txt")||die;
								     $date2=<DATE2>;
								     chomp($date2);
								     close(DATE2);
								     system("rm -f /root/date2.txt");
								
								     $loginfo2="$change2".", $date2.";
								     open(LOG, ">>/root/MXBSC_APP_Patch.log");
								     print LOG "$loginfo2\n";
								       
								       print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
								   }
								  #for tpgsm
								  system("grep $ScriptRPMfilename $RPMdir/MXPF/tpgsm-bsc-rpm.lst >> /root/testtpgsmScriptRPMfilename.txt");
								  open (CN3, "/root/testtpgsmScriptRPMfilename.txt");
								  $tpgsmScriptRPMfilenametest=<CN3>;
								  chomp($tpgsmScriptRPMfilenametest);
								  system("rm -f /root/testtpgsmScriptRPMfilename.txt");
								  if ( $tpgsmScriptRPMfilenametest eq $oldScriptRPMfilename){
								      #modify the tpgsm-bsc-rpm.lst
								     system("sed -e s/$oldScriptRPMfilename/$newScriptRPMfilename/ $RPMdir/MXPF/tpgsm-bsc-rpm.lst > /root/c");
								     system("cat /root/c > $RPMdir/MXPF/tpgsm-bsc-rpm.lst");
								     system("rm -f /root/c");
								     system("rm -f testccpScriptRPMfilename.txt");
								     print "$oldScriptRPMfilename replaced by $newScriptRPMfilename in the tpgsm-bsc-rpm.lst\n";
								     system("echo $oldScriptRPMfilename replaced by $newScriptRPMfilename in the tpgsm-bsc-rpm.lst>>/root/c3.log");
								     open(CHANG3, "/root/c3.log")||die;
								     $change3=<CHANG3>;
								     chomp($change3);
								     close(CHANG3);
								     system("rm -f /root/c3.log");
								
								     system("date +%T\\ %F>>/root/date3.txt");
								     open(DATE3, "/root/date3.txt")||die;
								     $date3=<DATE3>;
								     chomp($date3);
								     close(DATE3);
								     system("rm -f /root/date3.txt");
								
								     $loginfo3="$change3".", $date3.";
								     open(LOG, ">>/root/MXBSC_APP_Patch.log");
								     print LOG "$loginfo3\n";
								     print "The change has been recorded in /root/MXBSC_APP_Patch.log\n";
								   }
								 
								 	#uninstall and install
								  
								   if($esysScriptnumber ==0)
								    {
								   	   system( "echo There is no $ScriptRPMfilename* recorded in the rpm database | tee -a $logfile");
								    }
								   else
								     {
								    	 system( "echo Uninstall the $eoldScriptRPMfilename | tee -a $logfile");
								    	 system("rpm -e $eoldScriptRPMfilename");
								     }    
								   $eoldScriptfilename=$array1[0]."\.P";
								   system("rm -f /common/bsc/SCPRDISK/$eoldScriptfilename*");
								   system("echo Install the $newScriptRPMfilename | tee -a $logfile");
								   system("rpm -Uvh --nodeps --force $RPMdir/$newScriptRPMfilename");
								   if ( $? !=0){
             								system ("echo Error!!! rpm $RPMdir/$newScriptRPMfilename install failed | tee -a $logfile");
             								exit 1;
             							    }
								    #update the SDF after installation
								     system("echo Update the $newScriptRPMfilename in the /common/bsc/SCPRDISK/$Mxswdf | tee -a $logfile");
								     system("sed -e '/^#B.LOAD/,/^#E.LOAD/s/$ScriptRPMfilenamefirst8*.*rpm/$newScriptRPMfilename/g' /common/bsc/SCPRDISK/$Mxswdf >/root/f.txt");
								     system("cat /root/f.txt > /common/bsc/SCPRDISK/$Mxswdf");
								     system("rm -f /root/f.txt");
								    
				 }
}
#make a rpm package of the new SDF, remove the old SDF rpm package and put this new rpm package in $RPMdir
   #First make a exclusive directory which contains all your files
   $inputdir="/common/bsc/SCPRDISK";
   system("who am i > $inputdir/userinfo.txt");
   if (not -e "$inputdir/userinfo.txt")
   {
    system("echo Error !Create the userinfo.txt failed ,you may have no right to creat file in this directory of $inputdir | tee -a $logfile");
   exit 1;
   }
   open(USER,"$inputdir/userinfo.txt")||die;
   $userinfo=<USER>;
   chomp($userinfo);
   close(USER);
   system("rm -f $inputdir/userinfo.txt");
   @Array =split (m"\s+",$userinfo);

   system("date > $inputdir/dateinfo.txt");
   if (not -e "$inputdir/dateinfo.txt")
   {
  system ("echo Create the dateinfo.txt failed ,you may have no right to creat file in this directory of $inputdir | tee -a $logfile");
  exit 1;
   }
  open(DATE,"$inputdir/dateinfo.txt")||die;
  $date=<DATE>;
  chomp($date);
  close($DATE);
  system("rm -f $inputdir/dateinfo.txt");
  my @array;
  @array =split (m"\s+",$date);
  $useranddate="$Array[0]"."$array[0]"."$array[1]"."$array[2]"."$array[3]"."$array[4]"."$array[5]"."$array[6]";
   chomp($useranddate);
   $newdir="$inputdir/$useranddate";
   system("mkdir -p $inputdir/$useranddate");
   #Second get the operationg system in order to choose the good RPM command
   my $os = `uname -a`;
   chomp $os;
   my $buildrpm;
   if($os =~ /^.*Linux.*$/)
   {$buildrpm = "rpmbuild -bb --target i686--linux";} # for Linux
   else {$buildrpm = "/opt/rpm/bin/rpm -bb --target i686--linux";} # for Solaris
   #third build the needed environment
    
    $version="R1.0";
    $tempinputdir="$inputdir/$useranddate";
    chomp($tempinputdir);
    $ARGV[0] =$tempinputdir;
     # print "ARGV[0] is $ARGV[0]\n";
    $outputdir="/root";
    $ARGV[1] =$outputdir;
    $destdir="/common/bsc/SCPRDISK";
    $ARGV[2] =$destdir;
    system("grep macrofiles /usr/lib/rpm/rpmrc > /root/temp.txt");
    open (DH, "/root/temp.txt");
    $macros=<DH>;
    chomp($macros);
    close (DH);
    $pos = index($macros,"~");
    $macrocFile = substr($macros,$pos+2);
    print "macros is $macrocFile\n";
    system("rm /root/temp.txt");

   `
   rm -rf $ENV{HOME}/.rpm
   mkdir $ENV{HOME}/.rpm
   mkdir $ENV{HOME}/.rpm/SRPMS
   mkdir $ENV{HOME}/.rpm/SPECS
   mkdir $ENV{HOME}/.rpm/BUILD
   mkdir $ENV{HOME}/.rpm/SOURCES
   mkdir $ENV{HOME}/.rpm/tmp
   mkdir -p $ENV{HOME}/.rpm/tmp$ARGV[2]
   mkdir $ENV{HOME}/.rpm/RPMS
   mkdir $ENV{HOME}/.rpm/RPMS/noarch
   mkdir $ENV{HOME}/.rpm/RPMS/i686
   echo " %_tmppath       $ENV{HOME}/.rpm/tmp" > $ENV{HOME}/$macrocFile
   echo " %_topdir        $ENV{HOME}/.rpm" >  $ENV{HOME}/$macrocFile
   `;
   if(! -e "$ENV{HOME}/.rpm/SPECS"){
   system ("echo Error!!! build SDF rpm error,please check tool format in unix or check if you are in root permission | tee -a $logfile");
   exit 1;
   }
   #Fourth, build the spec file
    $version="R1.0";
    $destdir="/common/bsc/SCPRDISK";
    #copy the file to the exclusive directory
    $MxswdfP001=$Mxswdf."\.P001";
    system("cp -f $inputdir/$Mxswdf $inputdir/$useranddate/$MxswdfP001");
    `
   echo "Name:             $MxswdfP001" > $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "Version:          $version" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "Release:          P1" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "Summary:          no description" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "Group:            BSC" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "License:          Alcatel" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   cp $ARGV[0]/$MxswdfP001 $ENV{HOME}/.rpm/tmp$ARGV[2]/$MxswdfP001
   echo "BuildRoot:       $ENV{HOME}/.rpm/tmp " >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "%description" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "no description" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "%files" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   echo "%attr(755,root,root) $ARGV[2]/$MxswdfP001" >> $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec
   `;
   print "$MxswdfP001\n";
   print "The file $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec was sucessfully created\n";

   open(A,"$buildrpm $ENV{HOME}/.rpm/SPECS/$MxswdfP001.spec |");
   while(<A>) {print $_;}
   close(A);
   print "\n";

   `rm -f $ENV{HOME}/.rpm/tmp$ARGV[2]/$MxswdfP001`;
   `mv $ENV{HOME}/.rpm/RPMS/i686/* $ARGV[1]`;
   system("rm -rf $inputdir/$useranddate");
    #remove the old SDF rpm package and mv new SDF rpm package to the $RPMdir
    $MxswdfP001RpmPackageName=$MxswdfP001."-R1.0-P1.i686.rpm";
    if(! -e "$RPMdir/$MxswdfP001RpmPackageName"){
       system("mv /root/$MxswdfP001RpmPackageName $RPMdir");
	}
    else{
	system("rm -f $RPMdir/$MxswdfP001RpmPackageName");
	system("mv /root/$MxswdfP001RpmPackageName $RPMdir");
	}
    #add this new $MxswdfP001RpmPackageName into the omcp-bscpatch-rpm.lst
    system("grep $MxswdfP001RpmPackageName $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst > /root/MxswdfP001RpmPackageName.txt");
    $MxswdfP001RpmPackageNameCount=(-s "/root/MxswdfP001RpmPackageName.txt");
       if($MxswdfP001RpmPackageNameCount == 0)
        {
	   print "Add the \$MxswdfP001RpmPackageName= $MxswdfP001RpmPackageName into the omcp-bscpatch-rpm.lst\n";
           system("echo $MxswdfP001RpmPackageName >> $OmcpBscPatchlistDir/omcp-bscpatch-rpm.lst");	
	}
     system("echo Installing $MxswdfP001RpmPackageName | tee -a $logfile");
     system("rpm -Uvh --nodeps --force $RPMdir/$MxswdfP001RpmPackageName"); 
     if ( $? !=0){
             system ("echo Error!!! rpm $RPMdir/$MxswdfP001RpmPackageName install failed | tee -a $logfile");
             exit 1;
     } 			   
#remove the temporary files
system("rm -f /root/MxswdfP001RpmPackageName.txt");  
system("rm -f /root/c");
system("rm -f /root/oldVCERPMfilename.txt");
system("rm -f /root/oldScriptRPMfilename.txt");
system("rm -f /root/$newVCERPMfilename");
system("rm -f /root/$newScriptRPMfilename");

if( -e "/root/permission.txt"){
system ("rm -f /root/permission.txt");
}
#Display RPM permission
system (echo " RPM file permission is printed below | tee -a $logfile");
system("rpm -qpl  /tftpboot/rpm/$newVCERPMfilename  >>/root/permission.txt");
              open (DH, "/root/permission.txt");
              $per=<DH>;
              chomp($per);
              close (DH);
system ("ls -lrt $per | tee -a $logfile");
system ("rm -f /root/permission.txt");
system("rpm -qpl  /tftpboot/rpm/$newScriptRPMfilename  >>/root/permission.txt");
              open (DH, "/root/permission.txt");
              $per=<DH>;
              chomp($per);
              close (DH);
system ("ls -lrt $per | tee -a $logfile");
system ("rm -f /root/permission.txt");

exit 0;
