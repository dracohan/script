#!/usr/local/bin/perl
$| = 1;

#################################################################################
# COPYRIGHT (C) 2004 by Alcatel. All Rights Reserved		       		#
# FILENAME : PatchGenTool.pl					       		# 
# Project : B9 GA					       			#
# Team Responsible : DATA					       		#
# Author : LAKSHMINARAYANA PUTCHA (LAK)				       		#
#################################################################################

#################################################################################
#			HISTORY                                        		#
#                      ---------                                       		#
# 12/02/2004		Lak		Created                        		#
# 12/10/2004		Lak		CR: Change in input from VCE to		# 
#					    4chars of VCEname.         		#
# 12/13/2004		Lak		ER: Blank Input for SUB-VERSION		#
# 12/13/2004		Lak		OR: Remove temp files from VOBS		#
# 01/15/2005		Lak		CR: Remove libposixtime.so     		#
# 01/31/2005 		Fukai		CR: Copy *.link to vobs/.../obj		#
#                                       Copy blddef.csv, patch_delnotes		#
#                                       to Patch Folder.               		#
# 10/02/2005		Lak		CR: Erdie Cristian Reset Patch 		#
# 				        PatchNumber to 001 for each pkg.	#
#			Lak		Remove step to create vosconf.c		#
#								       		#	
# 28/02/2005            Lak         Add delivery/obj/patch folder to obtain 	#
#                                   Patched Modules.                        	#
# 18/03/2005		Lak	    Add TSC VCE Patch Generation Steps 		#
# 24/05/2005		YYJ	    To include the Environment Name in generated#
#			   	    blddef and patch delivery note;		#
#				    To replace the spaces in the mail subject   #
#				    with the underscore to avoid strange        #
#				    characters in CC list sent by sbardx4b      # 
# 07/06/2005		YYJ	    Remove suffix of patch name, blddef and     #
#				    delivery note				#
# 07/06/2005		YYJ	    Add libposixtimer before LIBRT according to #
#				    GXM's CR5217				#
# 08/06/2005		YYJ	    Add reference info into delivery mail	#
# 23/06/2005		YYJ	    Update corresponding info for MxB9		#
# 11/11/2005		YYJ	    Add libmp_spm.so for GA package, add patch  #
#				    module version in generated delivery note   #
#				    and get the reason automatically from blddef#
#                                   Include ShowVersion.pl in this script       #
# 11/16/2005            YYJ         Update DB location                          #
# 17/04/2006		YYJ	    Update according to B10 MX MR2 patch 	#
#				    production					#
#################################################################################


use DBI;
#use warnings;

$ENV{'ORACLE_HOME'} = "/opt/oracle/product/8.0.5";

my $blddefFile     = "blddef.csv";
my ($numModAns, $delNoteAns, $patchDelNote);
my $numModules     = 0;
my (@ModulesPatched, @PatchedVersion, @Reason4Patch) = ();

# Update for new release ... BEGIN
my $delDir         = "/project/gsmdel/mxb12/bss/bsc/";
my $patchToolDir   = $delDir."rC4/patch-tool/";
# Update for new release ... END

my $VOSCONFFILE    = "/vobs/g2bsc/src/kernel/VOS/src/vosconf.c";
my $objDir         = "/vobs/g2bsc/delivery/obj/";
my $patchSrcDir    = "/vobs/g2bsc/delivery/obj/patch/";
my ($label, $dataModel, $pos,$isRepeat);
my $NumModulesWNOREASON = 0;
my $rows1 = 0; my $numRows = 0; my $patchModRows = 0;
my $TESTCASE = 0;
my ($VCE_NAME, $cfgFile, $cfgContent, $inpDataAns, $OwnerMailId, $UserReasonForPatch);
my ($numModules, $LAST_PATCH_NUMBER);
$numModules = 0;
$isRepeat = 0;
$cfgFile = "";
undef $OwnerMailId;

my %attr = (
	PrintError => 0,
	RaiseError => 0,
	AutoCommit => 0
);
     

$VCE_NAME = uc($ARGV[0]);
chomp($VCE_NAME);
if ($#ARGV < 0) {
	Usage();
}

if (!(($VCE_NAME =~ /VTCU/) || ($VCE_NAME =~ /VDTC/) || 
      ($VCE_NAME =~ /VSYS/) || ($VCE_NAME =~ /VOSI/) || ($VCE_NAME =~ /VTSC/))
      || (length($VCE_NAME) > 4)) 
{
	Usage();
}

$cfgFile = $ARGV[1];
chomp($cfgFile);

$target = substr($VCE_NAME, 0, 4);

print "$target IS BEING Patched \n";

$link = "basicroute_" . $target .".link";

my $dbhPatch = DBI->connect("dbi:Oracle:host=sbardx4b;sid=MOL", "mcddata", "mcddata", \%attr) || die "Can't Connect: $DBI::errstr \n";

$pos = -1;

undef $numModules;

	open(BLDDEF, $blddefFile) or die "can't open $blddefFile $!";
	while(<BLDDEF>) {
		$data = $_;
		next if $data =~ /^\*/; next if $data =~ /^\s$/;
		last if $data =~ /^END_HEADER/;
		if ($data =~ /$target/) { 
			$VCESPSFILE = substr($data, 8, 6).substr($data, 15, 3); 
		}
		if ($data =~ /^DATA/) {
			if (($pos = index($data, "YTL", -1)) > -1) {
				 $dataModel = substr($data, $pos);
				 chomp($dataModel);
				 $dataModel =~ s/\s+$//;
			}
		}
		
	}
	close(BLDDEF);
	
	$logf = $patchToolDir.$VCESPSFILE.".log";
#	system("rm $logf");
	
	while (-e $logf)
	{
		$isRepeat=$isRepeat+1;
		system("rm $logf");
	}
	open(LOGF, ">$logf") or die "can't open $logf $!";

	print "Datamodel = $dataModel	BUILD_VERSION MUST BE:" . substr($VCESPSFILE,4,5) . "\n";
	 $VCENAME = substr($VCESPSFILE,0,8). "." . substr($VCESPSFILE,6,3);
	if (length($cfgFile) != 0) {
		#GET INPUT FROM <filename.cfg>
		print "Content of the $cfgFile File is as Below:\n";
		open (CFGFILE, $cfgFile) or die "can't open $cfgFile: $!\n";
		while (<CFGFILE>) {
			$cfgContent = $_;
			chomp ($cfgContent);
			next if ($cfgContent =~ /^#/);
			print " $cfgContent \n";
			($buildVersion, $buildSubVersion, $OwnerMailId) = split/,/, $cfgContent;
			#Remove all spaces before data.
			$buildVersion     =~ s/^\s+//;
			$buildSubVersion  =~ s/^\s+//;
			$OwnerMailId      =~ s/^\s+//;
			
			#Remove all space after the data.
			$buildVersion     =~ s/\s+$//;
			$buildSubVersion  =~ s/\s+$//;
			$OwnerMailId      =~ s/\s+$//;
			
			if ($OwnerMailId =~ /[^.*\@alcatel.*]/) {
				$OwnerMailId = $OwnerMailId . "\@alcatel-sbell.com.cn";
			}
			#Make patch-vce-name using the input build-version and blddef File.
			$buildVersion = lc($buildVersion);
			$variant = uc(substr($buildVersion, 0, 2));
			$vv = substr($buildVersion, 2, 2);
		        $pcs = uc(substr($buildVersion, 2, 3));
			
			($sec, $min, $hr, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time);
			$year=$year+1900;
             #		open(LOGF, ">$logf") or die "can't open $logf $!";
			print LOGF "$year-$mon-$day\n";
			print LOGF "$VCESPSFILE\n";
			print LOGF "$OwnerMailId\n";
			close(LOGF);
		}
		
	} else {	
		#Get Complete Email ID from StdInput
		print "Please  Enter your complete Email ID [PUTCHA.LAKSHMINARAYANA] : ";
		$OwnerMailId = <STDIN>;
		chomp($OwnerMailId);
		if ($OwnerMailId =~ /[^.*\@alcatel.*]/) {
			$OwnerMailId = $OwnerMailId . "\@alcatel-sbell.com.cn";
		}
		
		#print length($testEnvName) . "	 " . length($OwnerMailId) . "\n";
		
		#if ( (length($testEnvName) == 0) || (length($OwnerMailId) == 0) ) {
		if(length($OwnerMailId) == 0) {
			print "YOU MUST INPUT YOUR Correct/Complete Email ID\n";
			exit(1);
		}
#		open(LOGF, ">$logf") or die "can't open $logf \n";
		($sec, $min, $hr, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time);
		$year=$year+1900;
		print LOGF "$year-$mon-$day\n";
		print LOGF "$VCESPSFILE\n";
		print LOGF "$OwnerMailId\n";
		close(LOGF);
		
		print "PLEASE ENTER THE BUILD VERSION \t\t\t [AX05A]   : \t";
		$buildVersion = <STDIN>;
		chomp($buildVersion);
		if ( (length ($buildVersion) < 5) || ($buildVersion =~ /^[0-9]/) ) {
			print "Either the blddef.csv is wrong OR Wrong input for Build Version\n";
			print "Run Again \n";
			system("rm $logf");
			exit (0);
		}
		
		#Make patch-vce-name using the input build-version and blddef File.
		$buildVersion = lc($buildVersion);
		$variant = uc(substr($buildVersion, 0, 2));
		$vv = substr($buildVersion, 2, 2);
	        $pcs = uc(substr($buildVersion, 2, 3));
	
		#Ask user to enter all the required input
		print "\nPLEASE ENTER THE BUILD SUB VERSION \t\t [001]     : \t";
		$buildSubVersion = <STDIN>;
		chomp($buildSubVersion);
	
		if (length ($buildSubVersion) == 0) { 
			print "CHOSING DEFAULT BUILD-SUB-VERSION AS 001\n";
			$buildSubVersion = "001"; 
		}
	
		#Get Test Environment Name from StdInput
		#print "Please  Enter the Environment Name [TPSIM\/TP\/LIU_SPIxx\/NRT\/FAT ] : ";
		#$testEnvName = <STDIN>;
		#chomp($testEnvName);
		
	} #END OF #GET INPUT FROM <filename.cfg>
	
		$basePkg = $buildVersion . "/" . $buildSubVersion;
	        my $pkgDir = $delDir . $basePkg;

		$basePkg = "'" . $basePkg . "'";
		$patchDir = $delDir . $buildVersion . "/" . $buildSubVersion . "/patch";		
		if (!(-e $patchDir)) {
			print "$patchDir Does not exist \n";
			print "Check input and Run Again or Contact Build/Patch Manager \n";
			system("rm $logf");
			exit (0);
		}

	#print "\n\n\t\tPATCH-VCENAME WILL BE LIKE $VCENAME" . ".P***" . "_" . $testEnvName . "\n";
	print "\n\n\t\tPATCH-VCENAME WILL BE LIKE $VCENAME" . ".P***\n";
	print "\t\tBUILD_VERSION WILL BE  	   $buildVersion\n";
	print "\t\tBUILD_SUB_VERSION WILL BE  $buildSubVersion\n";
	print "\t\tYour Email ID is           $OwnerMailId\n";
	print "\t\tACCEPT [Y/N]:  ";
	$inpDataAns = <STDIN>;
	chomp($inpDataAns);
	
	if ($inpDataAns =~ /N/i) {
		print "Chose Proper blddef.csv, Enter proper input like AV50A and then 001\n\n\n";
		system("rm $logf");
		exit (0);
	}
	
	print "Please Enter the Reason for making this patch: \t";
	$UserReasonForPatch = <STDIN>;
	chomp($UserReasonForPatch);

	if ((length($UserReasonForPatch) == 0) ) {
		print "WARNING: YOU HAVE NOT ENTERED ER/CR/INFO OR REASON WHY YOU ARE MAKING PATCH\n";
		print "HISTORY SAYS THERE HAVE BEEN UNTOLD PROBLEMS FOR PATCHES WITHOUT REASON\n\n";
		print "CONTINUING ANYWAY .....\n\n\n";
	}

	$buildVersion = uc($buildVersion);	
	$buildVersion = "'" . $buildVersion . "'";
	$buildSubVersion = "'" . $buildSubVersion . "'";
	
	if (!(-e "$VOSCONFFILE")) {
		print "Please set your view and config spec for VOS: Refer User Manual\n";
		system("rm $logf");
		exit (0);
	}
	
	if (!(-e "/vobs/Tools/data/genVersion.pl")) {
		print "Get genVersion.pl from Build/Patch MNGR and save it in the current Directory \n";
		system("rm $logf");
		exit (0);
	}
	
	open (VCESPSFILE, ">$VCESPSFILE") or die "can't open $VCESPSFILE : $! \n";
	open(BLDDEF, $blddefFile) or die "can't open $blddefFile $!";
		while ($blddef=<BLDDEF>) {
			next if !(($blddef =~ /^MLO/) || ($blddef =~ /^LIB/));
			undef $newLbl; undef $oldLbl;
			undef $vtcu; undef $vdtc; undef $vsys; undef $vosi; 
			undef $vtsc; undef $Reason;			
			
			($moduleName, $cypher1, $cypher2, $newLbl, $vtcu, 
			$vdtc, $vsys, $vosi, $vtsc, $Reason) = split /,/, $blddef;
			
			$oldLbl = substr($cypher2, 4);
			
			#cleanup the space mess
			$moduleName =~ s/^\s+//; $moduleName =~ s/\s+$//;
 			$oldLbl =~ s/\s+$//; $newLbl =~ s/\s+$//;
  			$newLbl =~ s/^\s+//;	
			$vtcu =~ s/\s+$//; $vdtc =~ s/\s+$//; $vsys =~ s/\s+$//; 
  			$vosi =~ s/\s+$//; $vtsc =~ s/\s+$//;
 			$Reason =~ s/\s+$//;
 			
 			if ($vtcu ne "" && $vtcu ne "B") 
 			{
 				print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 				system("rm $logf");
 				exit(1);
 			}
 			if ($vdtc ne "" && $vdtc ne "C") 
 			{
 				print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 				system("rm $logf");
 				exit(1);
 			}
 			if ($vsys ne "" && $vsys ne "D") 
 			{
 				print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 				system("rm $logf");
 				exit(1);
 			}
 			if ($vosi ne "" && $vosi ne "E") 
 			{
 				print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 				system("rm $logf");
 				exit(1);
 			} 			
 			if ($vtsc ne "" && $vtsc ne "F") 
 			{
 				print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 				system("rm $logf");
 				exit(1);
 			}
		  	if ($moduleName =~ /^MLO/) {
		  		$moduleName = substr($moduleName, 4) . ".o";
		  	} elsif ($moduleName =~ /^LIB/) {
		  		$moduleName = substr($moduleName, 4) . ".a";
		  	}
	
	
			#Modified by fukai to display module name reason at STDOUT

			if ((length($newLbl) != 0)){
				printf "Module:$moduleName\n";
	  			if ((length($Reason) != 0) ) {
					printf "Reason:$Reason\n";
				} else {
					$NumModulesWNOREASON++;
					printf "Reason: NO Reason for this patch!!\n";
				}	  		
	  		}

			if (length($newLbl) != 0) {
				$numModules += 1;
				$label = $newLbl;
				@ModulesPatched = (@ModulesPatched, $moduleName);
				@PatchedVersion = (@PatchedVersion, $newLbl);
				@Reason4Patch   = (@Reason4Patch, $Reason);
				$moduleName = $patchSrcDir.$moduleName;
				$moduleName = $moduleName . "@@/" . $newLbl;
			} elsif (length($oldLbl) != 0) {
				$moduleName = $moduleName . "@@/" . $oldLbl;
				$label = $oldLbl;
			} 
			
			if ((length($newLbl) == 0) && (length($oldLbl) == 0)) {
				$moduleName = $moduleName;
				@ModulesPatched = (@ModulesPatched, $moduleName);
				@Reason4Patch   = (@Reason4Patch, $Reason);
				$numModules += 1;
				$label = "";
				@PatchedVersion = (@PatchedVersion, $label);
				printf "Module:$moduleName is a private file\n";
		  		if ((length($Reason) != 0) ) {
					printf "Reason:$Reason\n";
				} else {
					$NumModulesWNOREASON++;
					printf "Reason: NO Reason for this patch!!\n";
				}	  		
			}
			
			#modified by Lak /2005/04/30 to put modules(patched, and reason) per VCE	  		

			if ( ($target =~ /^VTCU/) && ($vtcu =~ /B{1}/i) ) {

				@VTCUDEPS = (@VTCUDEPS, $moduleName);
				print VCESPSFILE $moduleName . "," . $label . "\n";				
			}
			if ( ($target =~ /^VDTC/) && ($vdtc =~ /C{1}/i) ) {
				@VDTCDEPS = (@VDTCDEPS, $moduleName);
				print VCESPSFILE $moduleName . "," . $label . "\n";								
			}
			if ( ($target =~ /^VSYS/) && ($vsys =~ /D{1}/i)){
				@VSYSDEPS = (@VSYSDEPS, $moduleName);
				print VCESPSFILE $moduleName . "," . $label . "\n";				
			}
			
			if (($target =~ /^VOSI/) && ($vosi =~ /E{1}/i) ) {
				@VOSIDEPS = (@VOSIDEPS, $moduleName);
				print VCESPSFILE $moduleName . "," . $label . "\n";								
			}
			if (($target =~ /^VTSC/) && ($vtsc =~ /F{1}/i) ) {
				@VTSCDEPS = (@VTSCDEPS, $moduleName);
				print VCESPSFILE $moduleName . "," . $label . "\n";								
			}						
		}
	
	close(BLDDEF);
	close(VCESPSFILE);
	
	if ($numModules > 0) {
		print "$numModules modules are being patched [Y/N]:  ";
		$numModAns = <STDIN>;
		chomp($numModAns);
	
		if ($numModAns =~ /N/i) {
			print "check blddef file \n";
			system("rm $logf");
			exit (0);
		}
	} else {
		print "CASE: Test Run For Patch\n";
		$TESTCASE = 1;
	}
	
	if ($NumModulesWNOREASON > 0) {
		printf ("You have not provided input (Reasons) for %d modules \n", $NumModulesWNOREASON);
		print "Provide Input at the last column of the inputFile! Run again \n";
		system("rm $logf");
		exit (0);
	}
	
	$tempfile = "/vobs/g2bsc/delivery/obj/" . "tempmake_" . $VCENAME;

	open(TEMPMAKE, ">$tempfile") or die "can't open tempmake: $! \n";

	print TEMPMAKE "#****************************************************************************#\n";
	print TEMPMAKE "# MX BUILD TOP MAKE FILE \n";
	print TEMPMAKE "#****************************************************************************# \n\n";

	print TEMPMAKE "GCC_DIR       = /vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin\n";
	print TEMPMAKE "GCC           = \$(GCC_DIR)/pentium3-gcc \n";
	print TEMPMAKE "LOCAL_LDFLAGS = /vobs/pcsoft/mvlcge40/devkit/x86/pentium3/target/usr/lib/libposixtime.so\n";
	print TEMPMAKE "LIBRT         = /vobs/pcsoft/mvlcge40/devkit/x86/pentium3/target/lib/librt.so.1\n";
	print TEMPMAKE "DELIVERY_OBJ  = /vobs/g2bsc/delivery/obj\n";
	print TEMPMAKE "PATCH_OBJ     = \$(DELIVERY_OBJ)/patch\n";
	print TEMPMAKE "PF_LIBS       = /usr/local/trace/sdk/lib\n";
	
	print TEMPMAKE "\n\n################################################################\n";
	print TEMPMAKE "#DEPENDENCIES							\n";
	print TEMPMAKE "################################################################\n\n";

	print TEMPMAKE "BASIC_RT_TABLE_SYS = basicroute_VSYS.link\n";
	print TEMPMAKE "BASIC_RT_TABLE_DTC = basicroute_VDTC.link\n";
	print TEMPMAKE "BASIC_RT_TABLE_TCU = basicroute_VTCU.link\n";
	print TEMPMAKE "BASIC_RT_TABLE_OSI = basicroute_VOSI.link\n\n";
	print TEMPMAKE "BASIC_RT_TABLE_TSC = basicroute_VTSC.link\n\n";

	$vceDepList = $VCESPSFILE;
	
	print TEMPMAKE $vceDepList . " := ";
	print TEMPMAKE "VERSION.o  ";
	
	if ($target =~ /VTCU/i ) {
		for ($i = 0; $i <= $#VTCUDEPS ; $i++) {
			print TEMPMAKE "$VTCUDEPS[$i] ";
			if (($i%3) == 0) {
				print TEMPMAKE " \\\n";
				print TEMPMAKE "	";
			}
		}
	}
	
	if ($target =~ /VDTC/i ) {
		for ($i = 0; $i <= $#VDTCDEPS ; $i++) {
			print TEMPMAKE "$VDTCDEPS[$i] ";
			if (($i%3) == 0) {
				print TEMPMAKE " \\\n";
				print TEMPMAKE "	";
			}
		}
	}
	
	if ($target =~ /VSYS/i ) {
		for ($i = 0; $i <= $#VSYSDEPS ; $i++) {
			print TEMPMAKE "$VSYSDEPS[$i] ";
			if (($i%3) == 0) {
				print TEMPMAKE " \\\n";
				print TEMPMAKE "	";
			}
		}
	}
	
	if ($target =~ /VOSI/i ) {
		for ($i = 0; $i <= $#VOSIDEPS ; $i++) {
			print TEMPMAKE "$VOSIDEPS[$i] ";
			if (($i%3) == 0) {
				print TEMPMAKE " \\\n";
				print TEMPMAKE "	";
			}
		}
	}
	
	if ($target =~ /VTSC/i ) {
		for ($i = 0; $i <= $#VTSCDEPS ; $i++) {
			print TEMPMAKE "$VTSCDEPS[$i] ";
			if (($i%3) == 0) {
				print TEMPMAKE " \\\n";
				print TEMPMAKE "	";
			}
		}
	}
	
	
	my $sql_PATCH_NUMBER = qq{ SELECT MAX(PATCH_NUMBER) AS LAST_PATCH_NUMBER FROM PATCH_INFO WHERE substr(PATCH_NAME,0,12)='$VCENAME'};
	my $sth_PATCH_NUMBER = $dbhPatch->prepare( $sql_PATCH_NUMBER );
	$sth_PATCH_NUMBER->execute();
	$sth_PATCH_NUMBER->bind_columns(undef, \$LAST_PATCH_NUMBER);

	if ($sth_PATCH_NUMBER->fetch()) {
		$LAST_PATCH_NUMBER = $LAST_PATCH_NUMBER + 1+ $isRepeat ;
	} else {
		$LAST_PATCH_NUMBER = 1+$isRepeat;
	}
	$sth_PATCH_NUMBER->finish();
		
	if ($LAST_PATCH_NUMBER < 10) {
		$targetName = $VCENAME . ".P00" . $LAST_PATCH_NUMBER;
	} elsif (($LAST_PATCH_NUMBER >= 10) && ($LAST_PATCH_NUMBER < 100)) {
	 	$targetName = $VCENAME . ".P0" . $LAST_PATCH_NUMBER;
	} else {
		$targetName = $VCENAME . ".P" . $LAST_PATCH_NUMBER;
	}
	
	print TEMPMAKE "\nPHONY		: ALL\n";
	print TEMPMAKE "ALL 		: $targetName \n\n";

	if ($target =~ /^VTCU/) {
		$returnVal2 = system ("/vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin/pentium3-gcc -g -mpreferred-stack-boundary=2 -D VTCU -I/vobs/g2bsc/src/kernel/VOS/inc -I/vobs/g2bsc/src/context -I/vobs/g2bsc/src/inc -c -o /vobs/g2bsc/delivery/obj/VOSCONF.o  $VOSCONFFILE");
		$returnVal3 = system ("perl /vobs/Tools/data/genVersion.pl $targetName");
		print TEMPMAKE "$targetName	: \$(BASIC_RT_TABLE_TCU) \$($vceDepList) \n";
		print TEMPMAKE	"	\@echo TCU\n";
		print TEMPMAKE	"	\$(GCC) -o \$@ \$(BASIC_RT_TABLE_TCU) -Wl,--start-group,-R/usr/local/pms/lib,-R\$(PF_LIBS),-R/usr/local/spm/sdk/lib -L\$(DELIVERY_OBJ) -L\$(PATCH_OBJ) -lpmsapilinux -lmx_log_tra -lmp_spm VOSCONF.o \$($vceDepList) --end-group -lpthread \$(LOCAL_LDFLAGS) \$(LIBRT)\n\n";
	} elsif ($target =~ /^VDTC/) {
		$returnVal2 = system ("/vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin/pentium3-gcc -g -mpreferred-stack-boundary=2 -D VDTC -I/vobs/g2bsc/src/kernel/VOS/inc -I/vobs/g2bsc/src/context -I/vobs/g2bsc/src/inc -c -o /vobs/g2bsc/delivery/obj/VOSCONF.o  $VOSCONFFILE");
		$returnVal3 = system ("perl /vobs/Tools/data/genVersion.pl $targetName");
		print TEMPMAKE "$targetName	: \$(VOSCONF) \$(BASIC_RT_TABLE_DTC) \$($vceDepList) \n";	
		print TEMPMAKE "	\@echo DTC\n";
		print TEMPMAKE "	\$(GCC) -o \$@ \$(BASIC_RT_TABLE_DTC) -Wl,--start-group,-R/usr/local/pms/lib,-R\$(PF_LIBS),-R/usr/local/spm/sdk/lib -L\$(DELIVERY_OBJ) -L\$(PATCH_OBJ) -lpmsapilinux -lmx_log_tra -lmp_spm VOSCONF.o \$($vceDepList) --end-group -lpthread \$(LOCAL_LDFLAGS) \$(LIBRT)\n\n";
	} elsif ($target =~ /^VSYS/) {
		$returnVal2 = system ("/vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin/pentium3-gcc -g -mpreferred-stack-boundary=2 -D VSYS -I/vobs/g2bsc/src/kernel/VOS/inc -I/vobs/g2bsc/src/context -I/vobs/g2bsc/src/inc -c -o /vobs/g2bsc/delivery/obj/VOSCONF.o  $VOSCONFFILE");
		$returnVal3 = system ("perl /vobs/Tools/data/genVersion.pl $targetName");
		print TEMPMAKE "$targetName	: \$(VOSCONF) \$(BASIC_RT_TABLE_SYS) \$($vceDepList) \n";	
		print TEMPMAKE "	\@echo SYS\n";
		print TEMPMAKE "	\$(GCC) -o \$@ \$(BASIC_RT_TABLE_SYS) -Wl,--start-group,-R/usr/local/pms/lib,-R\$(PF_LIBS),-R/usr/local/spm/sdk/lib -L\$(DELIVERY_OBJ) -L\$(PATCH_OBJ) -lpmsapilinux -lmx_log_tra -lmp_spm VOSCONF.o \$($vceDepList) --end-group -lpthread \$(LOCAL_LDFLAGS) \$(LIBRT)\n\n";
	} elsif ($target =~ /^VOSI/) {
		$returnVal2 = system ("/vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin/pentium3-gcc -g -mpreferred-stack-boundary=2 -D VOSI -I/vobs/g2bsc/src/kernel/VOS/inc -I/vobs/g2bsc/src/context -I/vobs/g2bsc/src/inc -c -o /vobs/g2bsc/delivery/obj/VOSCONF.o  $VOSCONFFILE");
		$returnVal3 = system ("perl /vobs/Tools/data/genVersion.pl $targetName");
		print TEMPMAKE "$targetName	: \$(VOSCONF) \$(BASIC_RT_TABLE_OSI) \$($vceDepList) \n";	
		print TEMPMAKE "	\@echo OSI\n";
		print TEMPMAKE "	\$(GCC) -o \$@ \$(BASIC_RT_TABLE_OSI) -Wl,--start-group,-R/usr/local/pms/lib,-R\$(PF_LIBS),-R/usr/local/spm/sdk/lib -L\$(DELIVERY_OBJ) -L\$(PATCH_OBJ) -lpmsapilinux -lmx_log_tra -lmp_spm VOSCONF.o \$($vceDepList) --end-group -lpthread \$(LOCAL_LDFLAGS) \$(LIBRT)\n\n";
	} elsif ($target =~ /^VTSC/) {
		$returnVal2 = system ("/vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin/pentium3-gcc -g -mpreferred-stack-boundary=2 -D VTSC -I/vobs/g2bsc/src/kernel/VOS/inc -I/vobs/g2bsc/src/context -I/vobs/g2bsc/src/inc -c -o /vobs/g2bsc/delivery/obj/VOSCONF.o  $VOSCONFFILE");
		$returnVal3 = system ("perl /vobs/Tools/data/genVersion.pl $targetName");
		print TEMPMAKE "$targetName	: \$(VOSCONF) \$(BASIC_RT_TABLE_TSC) \$($vceDepList) \n";	
		print TEMPMAKE "	\@echo TSC\n";
		print TEMPMAKE "	\$(GCC) -o \$@ \$(BASIC_RT_TABLE_TSC) -Wl,--start-group,-R/usr/local/pms/lib,-R\$(PF_LIBS),-R/usr/local/spm/sdk/lib -L\$(DELIVERY_OBJ) -L\$(PATCH_OBJ) -lpmsapilinux -lmx_log_tra -lmp_spm  VOSCONF.o \$($vceDepList) --end-group -lpthread \$(LOCAL_LDFLAGS) \$(LIBRT)\n\n";
	}
	
close(TEMPMAKE);

	if ($returnVal2 || $returnVal3) {
		print "Error Could not preprocess some of the files check line #335 On \n";
		system("rm $logf");
		exit (0);
	}
	#
	#Modified by Fukai 01/31/2005
	#
	printf "Copy the basicroute link files ....\n\n";
#	$returnValLink = system("cp $pkgDir/*.link $objDir");
	system("rm -f /vobs/g2bsc/delivery/obj/$link");

	system ("cp /vobs/g2bsc/src/context/$link  /vobs/g2bsc/delivery/obj/$link");

	#Added by Lak
	#Return Error if *.link files donot exist in Package Dir
#	if ($returnValLink) {
#		print "*.link FILES DONOT EXIST AT $pkgDir OR YOU HAVE NOT SET YOUR VIEW\n";
#		print "Contact Build/Patch Manager\n";
#		system("rm $logf");
#		exit(0);
#	}
		
	$genTime = "'" . localtime(time) . "'";
	$patchName = "'" . $targetName . "'";
	$DMD = "'" . $dataModel . "'";
	#$patchVCEName = $targetName . "_" . $testEnvName;
	$patchVCEName = $targetName;
	print "PatchVCEName = $patchVCEName \n";
			
	my $sql_PATCH_VERSION_INDEX = qq{ SELECT MAX(PATCH_VERSION) AS LAST_PATCH_VERSION_INDEX FROM PATCH_INFO };
	my $sth_PATCH_VERSION_INDEX = $dbhPatch->prepare( $sql_PATCH_VERSION_INDEX );
	$sth_PATCH_VERSION_INDEX->execute();
	$sth_PATCH_VERSION_INDEX->bind_columns(undef, \$LAST_PATCH_VERSION_INDEX);
	$sth_PATCH_VERSION_INDEX->fetch();
	$LAST_PATCH_VERSION_INDEX = $LAST_PATCH_VERSION_INDEX + 1;
	$sth_PATCH_VERSION_INDEX->finish();
	my $sql_PATCH_INSERT = qq{INSERT INTO PATCH_INFO (PATCH_VERSION) VALUES ($LAST_PATCH_VERSION_INDEX)};
	print "sql_PATCH_INSERT = $sql_PATCH_INSERT \n";
        unless ($rows1 = $dbhPatch->do($sql_PATCH_INSERT)) {
                        $dbhPatch->rollback;
                        die "can't INSERT INTO PATCH_INFO : $DBI::errstr \n";
         }
         $numRows = $numRows + $rows1;
         print "$numRows rows inserted in PATCH_INFO TABLE\n";
	unless ($dbhPatch->commit) {
        die "Could not commit: $DBI::errstr \n";
        $dbhPatch->rollback;
	}

	
	my $sql_PATCH_UPDATE = qq{UPDATE PATCH_INFO SET  PATCH_NAME=$patchName, DMD=$DMD, GEN_TIME=$genTime, BASE_PKG=$basePkg, PATCH_NUMBER='$LAST_PATCH_NUMBER' where PATCH_VERSION='$LAST_PATCH_VERSION_INDEX'};
	print "sql_PATCH_UPDATE = $sql_PATCH_UPDATE \n";
	 unless ($rows1 = $dbhPatch->do($sql_PATCH_UPDATE)) {
                        $dbhPatch->rollback;
                        die "can't UPDATE  INTO PATCH_INFO : $DBI::errstr \n";
                }
	#
	#RUN THE MAKE FILE
	#
	print "clearmake -C gnu -f $tempfile $targetName \n";
	$returnVal4 = system("cd /vobs/g2bsc/delivery/obj; clearmake -C gnu -f $tempfile $targetName");

	if (!($returnVal4)) {
			  
		$returnVal5 = system ("cp /vobs/g2bsc/delivery/obj/$targetName $patchDir/$patchVCEName");
		if (!($returnVal5)) {
			print "Patch $patchVCEName is located at $patchDir \n";
			$str = substr($patchVCEName,1);
                        print "str is $str\n";
                        $scriptFile = "S". $str;
                        $script = substr($scriptFile,0,12);
                        $scriptFile = "$patchDir/" .$scriptFile;
                        print "The script file is $scriptFile\n";
                        print "The script is $script\n";
                        $vce = substr($patchVCEName,0,12);
                        system("cp $pkgDir/$script  $scriptFile");
                        system(" sed s'/$vce/$patchVCEName/g' $scriptFile >tempscript");
                        system("cp tempscript  $scriptFile");
                        system("rm tempscript");

		} else {
			print "RESOLVE ERROR DISPLAYED AT YOUR TERMINAL \n";
		}
	
		#
		#Remove ALL Stray Files from VOBS
		#
		$linkName = "basicroute_" . $target . ".link";
		$returnVal6 = system ("rm /vobs/g2bsc/delivery/obj/$linkName ");
		$returnVal7 = system ("rm $tempfile ");
		$returnVal8 = system ("rm /vobs/g2bsc/delivery/obj/VERSION.o ");			
		$returnVal9 = system ("rm /vobs/g2bsc/delivery/obj/VOSCONF.o ");
		$returnVal10 = system ("rm /vobs/g2bsc/delivery/obj/$targetName");
	
		if ( ($returnVal6) || ($returnVal7) ||($returnVal8) || ($returnVal9) || ($returnVal10)){
			print "COULD NOT DELETE FILE LOCAL TO YOUR VIEW. FOR SWE SAKE PLEASE DELETE ALL UNUSED FILES\n";
		}
	
		#
		#Generate Patch Delivery Note and Save it to Patch to Directory
		#blddef.csv is also saved to Patch Directory and renamed as blddef.csv.VCE_FULL_NAME.
		#
		print "\n\nGenerating Delivery Note.......\n";

		$patchDelNote = $patchVCEName . ".txt";
		open (PATCHDELNOTES, ">$patchDelNote") or die "Can't open $patchDelNote : $! \n";
		print PATCHDELNOTES "Patch: $targetName \n";
		print PATCHDELNOTES "DMD: $dataModel \n";
		print PATCHDELNOTES "Generate Time: " . localtime(time)  . "\n\n";
		
		for ($i = 0; $i < $numModules; $i++) {
			print PATCHDELNOTES $i+1 . "  Patched Module :";
			if (length($PatchedVersion[$i])==0)
			{
				print PATCHDELNOTES " \t$ModulesPatched[$i]\n";
			}
			else
			{
				print PATCHDELNOTES " \t$ModulesPatched[$i]@@/$PatchedVersion[$i]\n";
			}
			print PATCHDELNOTES "Reason For Patch : ";
			print PATCHDELNOTES "\t$Reason4Patch[$i]\n\n";
		}
			
		close (PATCHDELNOTES);

		print "\n\n$patchDelNote is generated in the current folder\n";	

		my $blddefName = "blddef.csv.".$patchVCEName;
		system("cp ./blddef.csv $patchDir/$blddefName"); 
		system("mv ./$patchDelNote $patchDir"); 
		system("rm ./$VCESPSFILE");
		print "\n$blddefName, $patchDelNote are moved to $patchDir\n\n";
		system("chmod 777 $patchDir/$blddefName  $patchDir/$patchDelNote $patchDir/$patchVCEName");	
		$returnValx = system("cd $patchDir; perl ShowVersion.pl $targetName");
		
		print "\nSENDING MAIL TO NOTIFY ABOUT THE PATCH YOU HAVE JUST CREATED ... \n\n";
		MailPatchListOfUsers($OwnerMailId,$patchVCEName,$UserReasonForPatch,$basePkg);
		print "ALL DONE!!\n"
		
	} else {
		print "RESOLVE ERROR DISPLAYED AT YOUR TERMINAL \n";
		print "REMEMBER TO MODIFY ONLY YOUR MODULES \n\n\n";
	}

unless ($dbhPatch->commit) {
	die "Could not commit: $DBI::errstr \n";
	$dbhPatch->rollback;
}

$dbhPatch->disconnect();
system("rm $logf");


#########################################################################
#	SUB FUNCTIONS START HERE					#
#########################################################################
		
sub Usage() {
	print "<Prog-name> <VCE-NAME (VTCU/VDTC/VSYS/VOSI/VTSC)> \n";
	exit (0);
}

#SUB FUNCTION TO SEND MAIL TO THE LIST OF USERS IMPACTED
sub MailPatchListOfUsers {
	my ($to, $rname, $cc, $ccList, $subject);
	my ($OwnerMailId, $patchVCEName, $UserReasonForPatch,$basePkg) = @_;
	my $patchmailingListFile = $patchToolDir . "patch-mailing-list";
	
	open(CCMAILLIST, "$patchmailingListFile") or warn, "$patchmailingListFile does not exit at $patchToolDir\n";
		@CCLIST = <CCMAILLIST>;
	close (CCMAILLIST);
	
	foreach $id (@CCLIST) {
		chomp($id);

		$cc = $cc . $id . "\@alcatel-sbell.com.cn, ";

	}
	
	$to = $OwnerMailId;

	# SEND MAIL, Update for new release
	$rname="MX-B12";	# release name
	$subject = "[B12_MX]ALERT:_".$patchVCEName."_was_prepared_for_".$UserReasonForPatch."_by_".$to ;

	open(MAIL,"| /bin/mailx  -r $to -c \"$cc\" -s \"$subject\" $to " ) or die "Could not open pipe: $!\n" ;
		
		print MAIL  "ATTENTION: This mail is sent from a virtual mail address, Please do NOT reply it !\n\n";
		print MAIL  "for Release : $rname\n\n";
		print MAIL  "Contact owner of the patch $patchVCEName at $OwnerMailId \n";
		print MAIL  "$patchVCEName based on $basePkg\n\n";
		print MAIL  "For details, please refer to http://172.24.12.75/Tools/patchTrack/ \n \n";
		
	close (MAIL) ;
}
#################################################################################################################################
#						END OF PROGRAM									#
#################################################################################################################################
