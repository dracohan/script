#!/usr/bin/perl -w
# Author : PYL
# Aim : OMCR trace package generator
# History : v1.0 24Oct06
#  - Creation
#
#----------------------------------------------

#
#
# $Author: cvs $
# $Date: 2009/02/02 13:55:24 $
# $Header: /cvsroot/TrcPkgGen/trcpg.pl,v 1.2 2009/02/02 13:55:24 cvs Exp $
# $Id: trcpg.pl,v 1.2 2009/02/02 13:55:24 cvs Exp $
# $Locker:  $
# $Name:  $
# $RCSfile
# $Revision: $
# $Source
# $State
#
# Author : PY Lescoublet  (pierre-yves.lescoublet@alcatel-lucent.fr)
# Aim : OMCR trace package generator
#       Collect OMCR log files for a BSC from date intervall 
#       (use OMCR Command Mode)
#



	use Tk;
	use Tk::BrowseEntry;
	use Tk::Dialog;

	use Net::FTP;

	$PROG = "Trace Package Generator";
	$VERSION = "1.3";

	$RootPath  = "/alcatel/omc3/maintenance";
	$HistPath  = "/alcatel/omc3/maintenance/hist";
	$TracePath = "/alcatel/omc3/maintenance/trace";
	$LogPath   = "/alcatel/omc3/maintenance/log";
	$CorePath   = "/alcatel/omc3/maintenance/core";
	$trc_w_core = 0;

	
	$TraceServerIP = "172.25.128.124";
	$TraceServerLogin = "axadmin";
	$TraceServerPasswd = "omc3";
	$TraceServerMode = 1; # 1=passive or 0=active, put in passive mode if behind a firewall.
	$TraceServerPath = "/net/pluto/vol/vol6/Bangalore/BGexchange/outgoing";

	#$TraceServerIP = "139.54.75.254";
	#$TraceServerLogin = "tlovz";
	#$TraceServerPasswd = "loadvz";
	#$TraceServerPath = "";

$SIG{'INT'} = 'ctrl_c_exit_all';


sub exit_all {
        omcdo("-stop RNL");
        omcdo("-stop EML");
        # stop cmd session
        omcdo("-exit");

        # close pipe of cmd session
        close CMD ;

        exit 0;
}

sub ctrl_c_exit_all {
        print "User exiting by Ctrl_C\n";
        exit_all;
}


sub exit_prog {
	exit 0;
}

sub ftp_file {
	
	my $file = "/tmp/$TraceName.tar.gz";
	my $path = $BscName;
	$path =~ tr/a-z/A-Z/;

	$path = $TraceServerPath;

	print "\nTry to transfer to trace server ...\n";
	print "path=$path file=$file\n";

	my $ftp = Net::FTP->new( $TraceServerIP, passive => $TraceServerMode);
	$ftp->login( $TraceServerLogin, $TraceServerPasswd) || die("FTP error: login");
	$ftp->binary || die("FTP error: bin");
	$ftp->hash(\*STDOUT, 32768);
	$ftp->cwd($path) || die("FTP error: cd $path");
	$ftp->put( $file) || die("FTP error: put $file");
	$ftp->quit;
	print "transfer=OK\n";
}

sub init_cmd {
        open( CMD , "/alcatel/omc3/usmcmd/script/run_usmcmd -p |" ) ;
        $startCmd = <CMD> ;
        if ( $startCmd =~ /PORT\s*=\s*(\d+)/ ) {
                $port = $1 ;
        } else {
                close CMD ;
                die "Bad command mode result : $startCmd\n" ;
        }
        print "port=$port\n";
        return $port;
}

sub close_cmd {
        # stop cmd session
        omcdo("-exit");

        # close pipe of cmd session
        close CMD ;
}

sub start_daemon {
        # Open an RNL and EML session
        print "Starting RNL command mode\n";
        $res = omcdo("-start RNL") ;
        #print "Starting EML command mode\n";
        #$res = omcdo("-start EML") ;
}

sub stop_daemon {
        # Close an RNL and EML session
        print "Closing RNL command mode\n";
        $res = omcdo("-stop RNL") ;
        #print "Closing EML command mode\n";
        #$res = omcdo("-stop EML") ;
}


sub omcdo {
        my $res ;
        my $arg = shift ;  # Command for command mode

        $res = `/alcatel/omc3/usmcmd/script/run_omcdo $arg` ;

        # check if command mode has return "DONE" key work excpeted for
        # -exit command (no return code)
        if (! ($res =~ "DONE") && ($arg ne "-exit")) {
                #print $arg , "\n" ;
                #print $res , "\n" ;
                return($res);
        }
        print $res;
        return($res);
}

sub _get_BSS_list {
@BscList = (["s222",3], ["s304",2], ["s307",1]);
}

sub get_BSS_list {
	my $i = 0;
	my @Bsc;
	my $res;

#@BscList = (["s222",3], ["s304",2], ["s307",1]);
	print "\nTry to get BSS identifiers ...\n";

	$port = init_cmd;
	$ENV{USMCMD_SESSION_PORT} = $port ;

	start_daemon;

        print "Listing all BSS's\n";
        $res = omcdo("'-cmd OMC_listBSS()'");

	@BSCid = $res =~ /(\d+)\s*-\s*UserLabel:\s*.*\s*/g;
	@BSCname = $res =~ m/: (.*)/g;

	foreach $name ( @BSCname) {
		@Bsc = [$name, $BSCid[$i]]; $i++; 
		push( @BscList, @Bsc);
	}

	stop_daemon;
	close_cmd;

        return $res;
}

sub get_Date_list {
#@DateList = ("061001", "061002", "061003");
	my $file;

	print "\nTry to get trace file dates ...\n";

	@DateList = `ls -1 $HistPath/bssim_1*.gz | awk '{FS="."}{print \$4}' | sort -u`;
	chomp( @DateList);
	printf("nb_of_days=%d\n", $#DateList);

}

sub print_error {
	my $msg = shift;
print "$msg\n";

	$f = $frmain -> Dialog( -title => $PROG, 
		-text => $msg, 
		-buttons => ['Cancel']);
	$f->Show();
}

sub get_hist_file {
	my $file;
	my $nb_file = 0;

	#printf("startfile=%s\n", $startfile);
	#printf("stopfile=%s\n", $stopfile);

	chomp( @FileList);
	foreach $file (@FileList) {
		if(( $file ge $startfile) && ( $file le $stopfile)) { 
			#printf("file=%s\n",$file);
			$file =~ s!$HistPath/!!;
			$file = "hist/$file";
			#printf(" file=%s\n",$file);
			push( @FileTraceList, $file);
			$nb_file++;
		}
	}
	#printf("nb of files = %d\n", $nb_file);
	return $nb_file;
}

sub get_trace_file {
	my $file;
	my $nb_file = 0;

	chomp( @FileList);
	foreach $file (@FileList) {
		if( !( $file =~ "lck")) {
			#printf("file=%s\n",$file);
			$file =~ s!$TracePath/!!;
			$file = "trace/$file";
			#printf(" file=%s\n",$file);
			push( @FileTraceList, $file);
			$nb_file++;
		}
	}

	return $nb_file;
}

sub get_log_file {
	my $file;
	my $nb_file = 0;

	chomp( @FileList);
	foreach $file (@FileList) {
		if( !( $file =~ "lck")) {
			#printf("file=%s\n",$file);
			$file =~ s!$LogPath/!!;
			$file = "log/$file";
			#printf(" file=%s\n",$file);
			push( @FileTraceList, $file);
			$nb_file++;
		}
	}

	return $nb_file;
}

sub get_core_dir {
	my $dir = shift;
	if( -d $dir) {
		printf(" dir=%s\n",$dir);
		push( @FileTraceList, $dir);
	}
}


sub make_tar_file {
	my $file;	

	print "\nTry to make a .tar.gz file ...\n";
	print "file=/tmp/$TraceName.tar.gz\n";
	open( FILE, ">/tmp/$TraceName.inc") || die("FILE error: unable to open file");
	foreach $file ( @FileTraceList) {
		print FILE "$file\n";
	}
	close( FILE);
	`cd $RootPath; tar cvf - -I /tmp/$TraceName.inc | gzip -c > /tmp/$TraceName.tar.gz`
}

sub gen_trace {

	my $n_file;
	my $total_file = 0;

	$start = sprintf("%02d0000", $StartHour->get);
	$stop = sprintf("%02d0000", $StopHour->get);

	if( length($TraceName) == 0) {
		print_error( 'No file name is defined');
		return;
	}
	if( length($StopDate) == 0) {
		print_error( 'Stop date is not defined');
		return;
	}
	if( $StartDate.$start ge $StopDate.$stop) {
		print_error( 'Start date/time is greater than Stop date/time');
		return;
	}

	@FileTraceList = ();

		print "\nTry to get selected trace files in $HistPath ...\n";

		$startfile = "$HistPath/bssim_$BscId.trace.old.$StartDate.$start.gz";
		$stopfile = "$HistPath/bssim_$BscId.trace.old.$StopDate.$stop.gz";
		@FileList = <$HistPath/bssim_$BscId*.gz>; 
		$n_file = get_hist_file;
		printf("nb of files for bssim_%d (%s) : %d\n", $BscId, $BscName,$n_file);
		$total_file += $n_file;

		$startfile = "$HistPath/bssusm.trace.axadmin.old.$StartDate.$start.gz";
		$stopfile = "$HistPath/bssusm.trace.axadmin.old.$StopDate.$stop.gz";
		@FileList = <$HistPath/bssusm*.gz>; 
		$n_file = get_hist_file;
		printf("nb of files for bssusm         : %d\n", $n_file);
		$total_file += $n_file;
	
		$startfile = "$HistPath/rnusmcmd.trace.axadmin.old.$StartDate.$start.gz";
		$stopfile = "$HistPath/rnusmcmd.trace.axadmin.old.$StopDate.$stop.gz";
		@FileList = <$HistPath/rnusmcmd*.gz>;
		$n_file = get_hist_file;
		printf("nb of files for rnusmcmd       : %d\n", $n_file);
		$total_file += $n_file;

		$startfile = "$HistPath/rnimsc.trace.old.$StartDate.$start.gz";
		$stopfile = "$HistPath/rnimsc.trace.old.$StopDate.$stop.gz";
		@FileList = <$HistPath/rnimsc*.gz>;
		$n_file = get_hist_file;
		printf("nb of files for rnimsc         : %d\n", $n_file);
		$total_file += $n_file;

		print "\nTry to get selected trace files in $TracePath ...\n";

		@FileList = <$TracePath/bssim_$BscId.*>;
		$n_file = get_trace_file;
		printf("nb of files for bssim_$BscId   : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/rnimsc.*>;
		$n_file = get_trace_file;
		printf("nb of files for rnimsc         : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/bssusm.*>;
		$n_file = get_trace_file;
		printf("nb of files for bssusm         : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/rnusm*.*>;
		$n_file = get_trace_file;
		printf("nb of files for rnusm          : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/bsscom*.*>;
		$n_file = get_trace_file;
		printf("nb of files for bsscom         : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/bssFTP*.*>;
		$n_file = get_trace_file;
		printf("nb of files for bssFTP         : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/oamusm*.*>;
		$n_file = get_trace_file;
		printf("nb of files for oamusm         : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/cmdsession*.*>;
		$n_file = get_trace_file;
		printf("nb of files for cmdsession     : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/mfsim*.*>;
		$n_file = get_trace_file;
		printf("nb of files for mfsim          : %d\n", $n_file);
		$total_file += $n_file;

		@FileList = <$TracePath/mfsusm*.*>;
		$n_file = get_trace_file;
		printf("nb of files for mfsusm         : %d\n", $n_file);
		$total_file += $n_file;

		print "\nTry to get selected trace files in $LogPath ...\n";
		@FileList = <$LogPath/*.log.axadmin>;
		$n_file = get_log_file;
		printf("nb of files for log            : %d\n", $n_file);
		$total_file += $n_file;

		printf("\nTotal nb of files              : %d\n\n", $total_file);

		if( $trc_w_core) {
			print "\nTry to get some core directories in $CorePath ...\n";
			get_core_dir( "$CorePath/bssim_$BscId"); 
			get_core_dir( "$CorePath/snmpcomm_$BscId"); 
			get_core_dir( "$CorePath/EXPORT_BSS_$BscId" . "_1"); 
		}



		make_tar_file;
		ftp_file;

}

sub update_stopdate_list {
	my $i = 0;
	my $d;
	$StopDate = $StartDate;
	$f_stopdate -> delete( 0, 'end');
	foreach $d ( @DateList) {
		if( $d ge $StartDate) {
			$f_stopdate -> insert( 'end', $d);
		}
	}
}

$InitStartHour = 12;
$InitStopHour = 12;

	$TITLE = sprintf("%s - v%s - PYL", $PROG, $VERSION);
	print "$TITLE\n";

	get_BSS_list;
	get_Date_list;



	$frmain = MainWindow->new;
	$frmain->title("$TITLE");

	$fr1 = $frmain->Frame;
	$title1 = "Trace package name";
	$fr1->Label( -textvariable => \$title1)->pack( -side => 'left');
	$fr1->Entry( -textvariable => \$TraceName)->pack;
	$fr1->pack;

	$fr2 = $frmain->Frame;
	$title1 = "Package trace name";
	$title2 = "Select BSC";
	$fr2->Label( -textvariable => \$title2)->pack( -side => 'left');
	$fr2->Optionmenu( -textvariable=> \$BscName,
		-variable => \$BscId, 
		-options => \@BscList)->pack;
	$fr2->pack;


	$fr3 = $frmain->Frame;
	$fr31 = $fr3->Frame;
	$fr32 = $fr3->Frame;
	$title3 = "Start date";
	$fr31->Label( -textvariable => \$title3)->pack;
	$StartDate=$DateList[0];
	$fr31->BrowseEntry(  -label => '',
		-variable => \$StartDate,
		-browsecmd => \&update_stopdate_list, 
		-choices => \@DateList)->pack;
	$StartHour = $fr32->Scale( -from => 0,
		-to => 23,
		-resolution => 1,
		-label => 'Start hour',
		-orient => 'horizontal')->pack;
	$StartHour->set( $InitStartHour);
	$fr31->pack( -side => 'left');
	$fr32->pack;
	$fr3->pack;

	$fr4 = $frmain->Frame;
	$fr41 = $fr4->Frame;
	$fr42 = $fr4->Frame;
	$title4 = "Stop date";
	$fr41->Label( -textvariable => \$title4)->pack;
	$StopDate='';
	$f_stopdate = $fr41->BrowseEntry( -label => '', 
		-variable => \$StopDate)->pack;
	$StopHour = $fr42->Scale( -from => 0,
		-to => 23,
		-resolution => 1,
		-label => 'Stop hour',
		-orient => 'horizontal')->pack( -side => 'left');
	$StopHour->set( $InitStopHour);
	$fr41->pack( -side => 'left');
	$fr42->pack;
	$fr4->pack;

	$fr5 = $frmain->Frame;
	$fr51 = $fr5->Frame;
	$fr51->Checkbutton( -text => "Add core files to the trace package", -variable => \$trc_w_core)->pack( -side => 'left');
	$fr51->pack( -side => 'left');
	$fr5->pack;

	$fr6 = $frmain->Frame;
	$fr6->Button( -text => 'Quit',
		-command => \&exit_prog )->pack( -side => 'left');
	$fr6->Button( -text => 'Execute',
		-command => \&gen_trace )->pack;
	$fr6->pack;
	
	MainLoop;
