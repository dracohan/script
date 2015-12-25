#!/usr/local/bin/perl
$| = 1;

#################################################################################
# COPYRIGHT (C) 2004 by Alcatel. All Rights Reserved		       		#
# FILENAME : PatchGenTool.pl			       		# 
# Project : B9 GA			       			#
# Team Responsible : DATA			       		#
# Author : LAKSHMINARAYANA PUTCHA (LAK)		       		#
#################################################################################

#################################################################################
#			HISTORY	                		#
#                      ---------	               		#
# 12/02/2004		Lak		Created			#
# 12/10/2004		Lak		CR: Change in input from VCE to		# 
#			    4chars of VCEname.         		#
# 12/13/2004		Lak		ER: Blank Input for SUB-VERSION		#
# 12/13/2004		Lak		OR: Remove temp files from VOBS		#
# 01/15/2005		Lak		CR: Remove libposixtime.so     		#
# 01/31/2005 		Fukai		CR: Copy *.link to vobs/.../obj		#
#	               Copy blddef.csv, patch_delnotes		#
#	               to Patch Folder.               		#
# 10/02/2005		Lak		CR: Erdie Cristian Reset Patch 		#
# 		        PatchNumber to 001 for each pkg.	#
#			Lak		Remove step to create vosconf.c		#
#				       		#	
# 28/02/2005            Lak         Add delivery/obj/patch folder to obtain 	#
#	           Patched Modules.		#
# 18/03/2005		Lak	    Add TSC VCE Patch Generation Steps 		#
# 24/05/2005		YYJ	    To include the Environment Name in generated#
#			   	    blddef and patch delivery note;		#
#		    To replace the spaces in the mail subject   #
#		    with the underscore to avoid strange        #
#		    characters in CC list sent by sbardx4b      # 
# 07/06/2005		YYJ	    Remove suffix of patch name, blddef and     #
#		    delivery note		#
# 07/06/2005		YYJ	    Add libposixtimer before LIBRT according to #
#		    GXM's CR5217		#
# 08/06/2005		YYJ	    Add reference info into delivery mail	#
# 23/06/2005		YYJ	    Update corresponding info for MxB9		#
# 11/11/2005		YYJ	    Add libmp_spm.so for GA package, add patch  #
#		    module version in generated delivery note   #
#		    and get the reason automatically from blddef#
#	           Include ShowVersion.pl in this script       #
# 11/16/2005            YYJ         Update DB location	  #
# 17/04/2006		YYJ	    Update according to B10 MX MR2 patch 	#
#		    production			#
#################################################################################
use DBI;
#use warnings;

$ENV{'ORACLE_HOME'} = "/opt/oracle/product/8.0.5";
my ($numModAns, $patchDelNote, $basePkg, $pkgDir, $label, $dataModel, $modulelable);
my $numModules = 0; my $isRepeat = 0; my $rows1 = 0; my $numRows = 0;

# Update for new release ... BEGIN
my $delDir         = "/project/gsmdel/mxb12/bss/bsc/";
my $patchToolDir   = $delDir."rC4/patch-tool/";
# Update for new release ... END

my $VOSCONFFILE    = "/vobs/g2bsc/src/kernel/VOS/src/vosconf.c";
my $objDir         = "/vobs/g2bsc/delivery/obj/";
my $patchSrcDir    = "/vobs/g2bsc/delivery/obj/patch/";
my $blddefFile     = "blddef.csv";
my $patchmodulefile = "patchmodule.log";
my (@ModulesPatched, @PatchedVersion, @Reason4Patch, @modulelables) = ();

($sec, $min, $hr, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time);
$year= $year+1900; $mon=$mon+1;
my $timestamp="$year-$mon-$day-$hr-$min";

my %attr = (
	PrintError => 0,
	RaiseError => 0,
	AutoCommit => 0
);
my %PATCHYN = (
        VTCU => N,
        VDTC => N,
        VSYS => N,
        VOSI => N,
        VTSC => N
);

# Get Module Labels
&GetModuleLabels();

#Update Blddef.csv
&UpdateBlddef(@modulelables);

#Get Impacted VCE
&GetPatchList();

#Make Patch binary
for (keys %PATCHYN) {
	&MakPatchList($_) if ($PATCHYN{$_} eq "Y");
}

#Build RPM
&BuildRpm();

#Cleanup and Notice
&ExitPatchGen(0);

#########################################################################
#	SUB FUNCTIONS START HERE			#
#########################################################################
##SUB FUNCTION TO LET USER INPUT LABELS
sub GetModuleLabels {
	print uc("\nHave you placed default blddef.csv into current folder? [y/n] ");
	chomp($YORN = <STDIN>);
	&ExitPatchGen("1") if ($YORN =~ /N/i); 
	
	print uc("\nPlease enter the module labels you want to patch. i.e:\n");
	print "\tME_HSK_3.SH_AL4D_PATCH_001\n"; 
	print "\tRF_MGT_L3_CCCH.WI_AL4C_PATCH_008\n";
	print "\tRF_MGT_L3.WI_AL4C_PATCH_006\n"; 
	print "\tRF_MGT_L3_SSM4.WI_AL4C_PATCH_006\n"; 
	print "\tSDCCH_RM_SSM.WI_AL4C_PATCH_006\n"; 
	print "\tTELECOM_SUPERV_MOD.WI_AL4F_PATCH_001\n";
	print uc("CTRL\^D to end the input:\n");

	while(chomp($modulelable = <STDIN>)){
		CleanupSpaceMess($modulelable);
		if (grep( /^$modulelable$/, @modulelables)){
			print "$modulelable already been recoreded, ignore duplicate input!!\n";
		}else{
			push(@modulelables, uc($modulelable)) if ($modulelable ne "");
		}
	}
	
	#Get Reason for the Patch
	if (!defined($UserReasonForPatch)) {
		print "\nPlease Enter the Reason for making this patch: ";
		chomp($UserReasonForPatch = <STDIN>);
		if ((length($UserReasonForPatch) == 0) ) {
			print "WARNING: YOU HAVE NOT ENTERED ER/CR/INFO OR REASON WHY YOU ARE MAKING PATCH\n";
			print "HISTORY SAYS THERE HAVE BEEN UNTOLD PROBLEMS FOR PATCHES WITHOUT REASON\n\n";
			print "CONTINUING ANYWAY .....\n\n\n";
		}
	}
}

#SUB FUNCTION TO GET VCE NAMES NEED TO PATCH
sub GetPatchList {
	# initilize hash table for patch list
	open(PATCHMODULEFILE, $patchmodulefile) or die "can't open $patchmodulefile $!";
	while (<PATCHMODULEFILE>){
		undef $newLbl; undef $oldLbl;
		undef $vtcu; undef $vdtc; undef $vsys; undef $vosi;
		undef $vtsc; undef $Reason;

		($moduleName, $cypher1, $cypher2, $newLbl, $vtcu,$vdtc, $vsys, $vosi, $vtsc, $Reason) = split /,/, $_;
		$oldLbl = substr($cypher2, 4);

		#cleanup the space mess
		CleanupSpaceMess($moduleName,$oldLbl,$newLbl,$vtcu,$vdtc,$vsys,$vosi,$vtsc,$Reason);      

		if ($vtcu eq "B"){
			$PATCHYN{"VTCU"} = "Y";
		}
		if ($vdtc eq "C"){
			$PATCHYN{"VDTC"} = "Y";
		}
		if ($vsys eq "D"){
			$PATCHYN{"VSYS"} = "Y";
		}
		if ($vosi eq "E"){
			$PATCHYN{"VOSI"} = "Y";
		}
		if ($vtsc eq "F"){
			$PATCHYN{"VTSC"} = "Y";
		}
		if ($vtcu ne "B"  && $vdtc ne "C" && $vsys ne "D" && $vosi ne "E" && $vtsc ne "F"){
			close(PATCHMODULEFILE);
			&ExitPatchGen(2);
		}
	}
	system ("rm $patchmodulefile");
}

#SUB FUNCTION TO MAKE VCE PATCHES
sub MakPatchList {
	# Variable initilize
	my $target = substr(uc($_), 0, 4);
	my $pos = -1;
	my $VCESPSFILE; 
	
	my $link = "basicroute_" . $target .".link";
	my $dbhPatch = DBI->connect("dbi:Oracle:host=sbardx4b;sid=MOL", "mcddata", "mcddata", \%attr) || die "Can't Connect: $DBI::errstr \n";
	
	#Initilize DataModel
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
	
	#print "Datamodel = $dataModel	BUILD_VERSION MUST BE:" . substr($VCESPSFILE,4,5) . "\n";
	$VCENAME = substr($VCESPSFILE,0,8). "." . substr($VCESPSFILE,6,3);
	
	
	#Get Complete Email ID
	if (!defined($OwnerMailId)) {
		print "\nPlease  Enter your complete Email ID [PUTCHA.LAKSHMINARAYANA] : ";
		chomp($OwnerMailId = <STDIN>);
		if ($OwnerMailId =~ /[^.*\@alcatel.*]/) {
			$OwnerMailId = $OwnerMailId . "\@alcatel-sbell.com.cn";
		}
		if(length($OwnerMailId) == 0) {
			print "YOU MUST INPUT YOUR Correct/Complete Email ID\n";
			exit(1);
		}
	}

	
	#Get Complete Build Version	
	if (!defined($buildVersion)) {
		print "\nPLEASE ENTER THE BUILD VERSION \t\t\t [AX05A]   : \t";
		chomp($buildVersion = <STDIN>);
		if ( (length ($buildVersion) < 5) || ($buildVersion =~ /^[0-9]/) ) {
			print "Either the blddef.csv is wrong OR Wrong input for Build Version\n";
			print "Run Again \n";
			system("rm $logf");
			exit (0);
		}
		$buildVersion = lc($buildVersion);
	
		#Ask user to enter all the required input
		print "\nPLEASE ENTER THE BUILD SUB VERSION \t\t [001]     : \t";
		chomp($buildSubVersion = <STDIN>);
		if (length ($buildSubVersion) == 0) { 
			print "CHOSING DEFAULT BUILD-SUB-VERSION AS 001\n";
			$buildSubVersion = "001"; 
		}

		$basePkg = $buildVersion . "/" . $buildSubVersion;
	        $pkgDir = $delDir . $basePkg;
		$basePkg = "'" . $basePkg . "'";
		$patchDir = $delDir . $buildVersion . "/" . $buildSubVersion . "/patch";		
		if (!(-e $patchDir)) {
			print "$patchDir Does not exist \n";
			print "Check input and Run Again or Contact Build/Patch Manager \n";
			system("rm $logf");
			exit (0);
		}
		$patchFolder = uc($buildVersion.$buildSubVersion);

		#print "\n\n\t\tPATCH-VCENAME WILL BE LIKE $VCENAME" . ".P***" . "_" . $testEnvName . "\n";
		print "\n\n\t\tPATCH-VCENAME WILL BE LIKE $VCENAME" . ".P***\n";
		print "\t\tBUILD_VERSION WILL BE  	   $buildVersion\n";
		print "\t\tBUILD_SUB_VERSION WILL BE  $buildSubVersion\n";
		print "\t\tYour Email ID is           $OwnerMailId\n";
		print "\t\tACCEPT [Y/N]: ";
		chomp($inpDataAns = <STDIN>);
		if ($inpDataAns =~ /N/i) {
			print "Chose Proper blddef.csv, Enter proper input like AV50A and then 001\n\n\n";
			system("rm $logf");
			exit (0);
		}
	}
	
	#Initilize log file
	#print "$target IS BEING Patched \n";
	$logf = $patchToolDir.$VCESPSFILE.".log";	
	while (-e $logf)
	{
		$isRepeat=$isRepeat+1;
		system("rm $logf");
	}
	open(LOGF, ">$logf") or die "can't open $logf $!";
	($sec, $min, $hr, $day, $mon, $year, $wday, $yday, $isdst) = localtime(time);
	$year=$year+1900;
	print LOGF "$year-$mon-$day\n";
	print LOGF "$VCESPSFILE\n";
	print LOGF "$OwnerMailId\n";
	close(LOGF);
	
	#Precheck	
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
	
	#
	#Generate ModuleName file
	#
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
		CleanupSpaceMess($moduleName,$oldLbl,$newLbl,$vtcu,$vdtc,$vsys,$vosi,$vtsc,$Reason);

		if ($vtcu ne "" && $vtcu ne "B") {
 			print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 			system("rm $logf");
 			exit(1);
 		}
 		if ($vdtc ne "" && $vdtc ne "C") {
 			print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 			system("rm $logf");
 			exit(1);
 		}
 		if ($vsys ne "" && $vsys ne "D") {
 			print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 			system("rm $logf");
 			exit(1);
 		}
 		if ($vosi ne "" && $vosi ne "E") {
 			print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 			system("rm $logf");
 			exit(1);
 		} 			
 		if ($vtsc ne "" && $vtsc ne "F") {
 			print "Mapping relation of $moduleName in blddef.csv is wrong! Please check the input!\n\n";
 			system("rm $logf");
 			exit(1);
 		}
		
		if ($moduleName =~ /^MLO/) {
		  		$moduleName = substr($moduleName, 4) . ".o";
		} elsif ($moduleName =~ /^LIB/) {
		  		$moduleName = substr($moduleName, 4) . ".a";
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
	
	if ($numModules > 0 && $numModAns ne "Y") {
		print "$numModules modules are being patched [Y/N]:  ";
		chomp($numModAns = <STDIN>);
			
		if ($numModAns =~ /N/i) {
			print "check blddef file \n";
			system("rm $logf");
			exit (0);
		}
	}
	
	#
	#Generate tempfile
	#
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
	#printf "Copy the basicroute link files ....\n";
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
	print "\nPatchVCEName = $patchVCEName \n\n";
			
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
			print "=========================================================================================\n";
			print "Patch $patchVCEName is located at $patchDir \n";
			$str = substr($patchVCEName,1);
			$scriptFile = "S". $str;
			$script = substr($scriptFile,0,12);
			$scriptFile = "$patchDir/" .$scriptFile;
			print "The script file is $scriptFile\n";
			print "=========================================================================================\n";
			$vce = substr($patchVCEName,0,12);
			system("cp $pkgDir/$script  $scriptFile");
			system(" sed s'/$vce/$patchVCEName/g' $scriptFile >tempscript");
			system("cp tempscript  $scriptFile");
			system("rm tempscript");
			
			#copy Patch and script file to $basePkg/$timestamp
			print uc("\nThe Patch and script is copied to ./$patchFolder/$timestamp now for you!\n\n");
			system("mkdir -p $patchFolder/$timestamp") if (!(-e $patchFolder/$timestamp));
			system("cp $patchDir/$patchVCEName $patchFolder/$timestamp");
			system("cp $scriptFile $patchFolder/$timestamp");

		} else {
			print "RESOLVE ERROR DISPLAYED AT YOUR TERMINAL \n";
		}
	
		#
		#Remove ALL Stray Files from VOBS
		#
		$linkName = "basicroute_" . $target . ".link";
		
		#DEBUG BEGIN
		#system ("cp /vobs/g2bsc/delivery/obj/$linkName $patchFolder/$timestamp");
		#system ("cp $tempfile $patchFolder/$timestamp");
		#system ("cp /vobs/g2bsc/delivery/obj/$targetName $patchFolder/$timestamp");
		#system ("cp $logf $patchFolder/$timestamp");
		#system ("cp $VCESPSFILE $patchFolder/$timestamp");
		#DEBUG END

		$returnVal6 = system ("rm -f /vobs/g2bsc/delivery/obj/$linkName ");
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
		$patchDelNote = $patchVCEName . ".txt";
		open (PATCHDELNOTES, ">$patchDelNote") or die "Can't open $patchDelNote : $! \n";
		print PATCHDELNOTES "Patch: $targetName \n";
		print PATCHDELNOTES "DMD: $dataModel \n";
		print PATCHDELNOTES "Generate Time: " . localtime(time)  . "\n\n";
		for ($i = 0; $i < $numModules; $i++) {
			print PATCHDELNOTES $i+1 . "  Patched Module :";
			if (length($PatchedVersion[$i])==0){
				print PATCHDELNOTES " \t$ModulesPatched[$i]\n";
			}
			else {
				print PATCHDELNOTES " \t$ModulesPatched[$i]@@/$PatchedVersion[$i]\n";
			}
			print PATCHDELNOTES "Reason For Patch : ";
			print PATCHDELNOTES "\t$Reason4Patch[$i]\n\n";
		}
		close (PATCHDELNOTES);

		my $blddefName = "blddef.csv.".$patchVCEName;
		system("cp ./blddef.csv $patchDir/$blddefName"); 
		system("mv ./$patchDelNote $patchDir"); 
		system("rm ./$VCESPSFILE");
		system("chmod 777 $patchDir/$blddefName  $patchDir/$patchDelNote $patchDir/$patchVCEName");	
		#$returnValx = system("cd $patchDir; perl ShowVersion.pl $targetName");
	
		#print "\nSENDING MAIL TO NOTIFY ABOUT THE PATCH YOU HAVE JUST CREATED ... \n\n";
		#&MailPatchListOfUsers($OwnerMailId,$patchVCEName,$UserReasonForPatch,$basePkg);
		#print "ALL DONE!!\n\n"
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

#SUB FUNCTION TO UPDATE BLDDEF.CSV ACCORDING TO LABELS
sub UpdateBlddef {
	#update blddef.csv 
	#system("cp blddef.csv blddef.csv.default");
	if(-e "patchmodule.log"){
		system("rm -f patchmodule.log");
	}
        open(BLDDEF, $blddefFile) or die "can't open $blddefFile $!";
	foreach(@_){
		($patchmodulename, $patchmodulelable) = split /\./, $_;
		system("sed '/\-'$patchmodulename'\,/ s/\,/\,'$patchmodulelable'/3' blddef.csv > blddef.csv.new");
		system("sed '/\-'$patchmodulename'\,/ s/\,/\,'$UserReasonForPatch'/9' blddef.csv.new > blddef.csv");
		system("rm blddef.csv.new");
		system("grep '\\-'$patchmodulename'\,' blddef.csv >> patchmodule.log");
	}
	close(BLDDEF);
}

#SUB FUNCTION TO CLEANUP SPACES IN ARGV
sub CleanupSpaceMess {
	foreach $cleanee (@_){
		$cleanee =~  s/^\s+//;
		$cleanee =~ s/\s+$//;
	}
}

#SUB FUNCTION TO BUILD RPM FILE
sub BuildRpm {
	print "START TO MAKING RPM FILES WITH THESE PATCHES......\n\n";
	my ($inputdir,$outputdir,$destdir,$patchfilename,$version);
	$destdir="/common/bsc/SCPRDISK";
	$version="R1.0";
	my $buildrpm;

	opendir my $dir, "./$patchFolder/$timestamp" or die "Cannot open ./$patchFolder/$timestamp: $!";
	my @files = readdir $dir;
	shift @files; shift @files;
	closedir $dir;

	$inputdir="./$patchFolder/$timestamp";
	$outputdir=$inputdir;
	chomp($destdir);chomp($version);

	# Get the operationg system in order to choose the good RPM command
	chomp($os = `uname -a`);
	if($os =~ /^.*Linux.*$/){
		# for Linux
		$buildrpm = "rpmbuild -bb --target i686--linux";
	}else {
		# for Solaris
		$buildrpm = "/opt/rpm/bin/rpm -bb --target i686--linux";
	}

	foreach my $i (0..$#files) {

		# Build the needed environment
		`
		rm -rf $ENV{HOME}/.rpm
		mkdir $ENV{HOME}/.rpm
		mkdir $ENV{HOME}/.rpm/SRPMS
		mkdir $ENV{HOME}/.rpm/SPECS
		mkdir $ENV{HOME}/.rpm/BUILD
		mkdir $ENV{HOME}/.rpm/SOURCES
		mkdir $ENV{HOME}/.rpm/tmp
		mkdir -p $ENV{HOME}/.rpm/tmp$destdir
		mkdir $ENV{HOME}/.rpm/RPMS
		mkdir $ENV{HOME}/.rpm/RPMS/noarch
		mkdir $ENV{HOME}/.rpm/RPMS/i686
		cat << EOF > $ENV{HOME}/.rpmmacros
		%_topdir	$ENV{HOME}/.rpm
		%_tmppath	$ENV{HOME}/.rpm/tmp
		EOF
		`;
		
		$patchfilename = $files[$i];
		my @array =split (/\./,$patchfilename);
		$newname=$array[0]."\.$array[1]";
		$patchnumber = $array[2];
		
		if(($patchfilename =~ m/^CMWRA/)or($patchfilename =~ m/^CMWPA/)or($patchfilename =~ m/^EIMLA/)or($patchfilename =~ m/^EIMRA/)or($patchfilename =~ m/^PSLHA/)or($patchfilename =~ m/^VDTCA/)or($patchfilename =~ m/^VOSIA/)or($patchfilename =~ m/^VSYSA/)or($patchfilename =~ m/^VTCUA/)or($patchfilename =~ m/^VTSCA/)or($patchfilename =~ m/^PGSLA/)or($patchfilename =~ m/^PNMPA/)or($patchfilename =~ m/^PPDRA/)or($patchfilename =~ m/^PTCRA/)or($patchfilename =~ m/^PLHPA/)or($patchfilename =~ m/^M3UAA/)){
			print "$patchfilename is in the set of {CMWRA, CMWPA, EIMLA, EIMRA, PSLHA, VDTCA, VOSIA, VSYSA, VTCUA, VTSCA}.\n";
		} else {
			print "$patchfilename is not in the set of {CMWRA, CMWPA, EIMLA, EIMRA, PSLHA, VDTCA, VOSIA, VSYSA, VTCUA, VTSCA}.\n";
			print "use $newname instead \n";
			system("cp -f $inputdir/$patchfilename $inputdir/$newname");
			$files[$i] = $newname;
		}

		if ($#array ne "2" || (length($array[0]) != 8) || (length($array[1]) != 3) || (length($array[2]) != 4)){
			print "There are some files in patch folder that are not in the '8.3.4' format.\n";
			print "Skip it! Please notice!\n";
			next;
		}

		#check does the rpm package already exit
		#$packagename = "$newname"."-$version"."-P1".".i686.rpm";
		#if (-e "$outputdir/$packagename"){
			#print "Error!The package:$packagename is already in $outputdir,please check it!\n";
			#exit(1);
		#}

		`
		echo "Name:             $patchfilename" > $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "Version:          $version" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "Release:          P1" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "Summary:          no description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "Group:            BSC" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "License:          Alcatel" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		cp $inputdir/$files[$i] $ENV{HOME}/.rpm/tmp$destdir/$files[$i]
		echo "BuildRoot:        %_tmppath" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "%description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "no description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "%files" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		echo "%attr(755,root,root) $destdir/$files[$i]" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
		`;

		print "$files[$i]\n";

		print "The file $ENV{HOME}/.rpm/SPECS/$files[$i].spec was sucessfully created\n";

		open(A,"$buildrpm $ENV{HOME}/.rpm/SPECS/$files[$i].spec |");
		while(<A>) {print $_;}
		close(A);
		print "\n";

		`rm -f $ENV{HOME}/.rpm/tmp$destdir/$files[$i]`;
		`mv $ENV{HOME}/.rpm/RPMS/i686/* $outputdir`;
		system("rm -rf $inputdir/$newname");
	}
}

#SUB FUNCTION TO CLEANUP AND NOTICE BEFORE EXIT
sub ExitPatchGen {
	system("cp blddef.csv ./$patchFolder/$timestamp/blddef.csv.$timestamp") if(defined($patchFolder));
	#system("cp blddef.csv.default blddef.csv") if (-e "blddef.csv.default");
	
	if($_[0] eq "0"){
		print "=========================================================================================\n";
		print "\tPLEASE FIND YOUR PATCH UNDER FOLDER ./$patchFolder/$timestamp\n";
		print "=========================================================================================\n";
		print "\a\a\a";
		exit(0);
	}elsif($_[0] eq "1"){
		print "=========================================================================================\n";
		print "\tPLEASE PUT CORRECT BLDDEF FILE TO CURRENT FOLDER AND RETRY AGAIN!\n";
		print "=========================================================================================\n";
		exit(0);
	}elsif($_[0] eq "2"){
		print "=========================================================================================\n";
		print "\tONLY VDTC, VTCU, VSYS, VOSI, VTSC PATCH ARE SUPPORTED NOW!\n";
		print "=========================================================================================\n";
		exit(1);
	}else{
		print "=========================================================================================\n";
		print "\tYOU SHOULD NOT ENTER THIS PATH!\n";
		print "=========================================================================================\n";
		exit(1);
	}
}

#################################################################################################################################
#				END OF PROGRAM					#
#################################################################################################################################
