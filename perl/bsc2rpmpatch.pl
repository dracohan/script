#!/usr/bin/perl
#######################################################
#                                                     #
#                     bsc2rpmpatch.pl                      #
#                                                     #
#######################################################
#  Last modification: Wed Jan 18 09:28:01 CST 2006    #
#  Author:MCG Chen Jianglin                           #
#######################################################

# This convert the BSC software files into RPMs.
# For example, "VTCUAV70.70A.P005" will become "VTCUAV70.70A-R1.2-P005.i686.rpm".

#input the things needed
my ($inputdir,$outputdir,$destdir,$patchfilename,$version);
print "Input path of the directory containing all your files:\n";
chomp ($inputdir =<STDIN>);
if (not -d $inputdir){
    print "Incorrect,input must be a directory\n";
    exit 1;
   }

$outputdir=$inputdir;
print "The path of the directory in which all the RPM will be stored is $outputdir\n";

$destdir="/common/bsc/SCPRDISK";
chomp($destdir);
print "The destination path where the file will be installed on equipment is $destdir\n";

$version="R1.0";
chomp($version);
print "The main version of the patch  is $version\n";

print "if you confirm the info above please enter 'y'\n";
chomp ($confirm= <STDIN>);
$y="y";
if("$confirm" ne "$y")
{print "What you enter is not 'y' or you don't confirm the information above please check and try again.\n";
exit 1;
}

print "Input the name of the patch:\n";
chomp ($patchfilename= <STDIN>);
if (not -e "$inputdir/$patchfilename"){
  print "Error!There is no this file:$patchfilename in $inputdir\n";
  exit 1;
 }
my @array;
@array =split (/\./,$patchfilename);
$newname=$array[0]."\.$array[1]";
$patchnumber = $array[2];
@array0 =split ('',$array[0]);
$array0 =@array0;
@array1 =split ('',$array[1]);
$array1 =@array1;
@array2 =split ('',$array[2]);
$array2 =@array2;
if (($array0 !=8)or($array1 !=3)or($array2 !=4)){
  print "Error!The filename is not in the '8.3.4' format.\n";
  print "For example :VSYSAW21.21E.P002\n";
  exit 1;
  }

#check does the rpm package already exit
$packagename = "$newname"."-$version"."-$patchnumber".".i686.rpm";
if (-e "$outputdir/$packagename"){
  print "Error!The package:$packagename is already in $outputdir,please check it!\n";
  exit 1;
 }

#to make a exclusive directory which contains all your files
system("who am i > $inputdir/userinfo.txt");
if (not -e "$inputdir/userinfo.txt")
{
  print "Creat the userinfo.txt failed ,you may have no right to creat file in this directory of $inputdir.\n";
  exit 1;
   }
open(USER,"$inputdir/userinfo.txt")||die;
$userinfo=<USER>;
chomp($userinfo);
close(USER);
# print "userinfo is $userinfo\n";
system("rm -f $inputdir/userinfo.txt");
@Array =split (m"\s+",$userinfo);
  #print "user is $Array[0]\n";

system("date > $inputdir/dateinfo.txt");
if (not -e "$inputdir/dateinfo.txt")
{
  print "Creat the dateinfo.txt failed ,you may have no right to creat file in this directory of $inputdir.\n";
  exit 1;
   }
open(DATE,"$inputdir/dateinfo.txt")||die;
$date=<DATE>;
chomp($date);
close($DATE);
#  print "date is $date\n";
system("rm -f $inputdir/dateinfo.txt");  
my @array;
@array =split (m"\s+",$date);
  #print "array[0] is $array[0]\n";
  #print "array[1] is $array[1]\n";
  #print "array[2] is $array[2]\n";
  #print "array[3] is $array[3]\n";
$useranddate="$Array[0]"."$array[0]"."$array[1]"."$array[2]"."$array[3]"."$array[4]"."$array[5]"."$array[6]";
chomp($useranddate);
#  print "useranddate is $useranddate\n";
  $newdir="$inputdir/$useranddate";
#  print "newdir is $newdir\n";
system("mkdir -p $inputdir/$useranddate");

#copy the file to the exclusive directory
#system("cp -f $inputdir/$patchfilename $inputdir/$useranddate/$patchfilename");

# Get the operationg system in order to choose the good RPM command
my $os = `uname -a`;
chomp $os;
my $buildrpm;
if($os =~ /^.*Linux.*$/)
{$buildrpm = "rpmbuild -bb --target i686--linux";} # for Linux
 else {$buildrpm = "/opt/rpm/bin/rpm -bb --target i686--linux";} # for Solaris
 
$tempinputdir="$inputdir/$useranddate";
chomp($tempinputdir);
$ARGV[0] =$tempinputdir;
   #  print "ARGV[0] is $ARGV[0]\n";
$ARGV[1] =$outputdir;
$ARGV[2] =$destdir;

# Build the needed environment
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
cat << EOF > $ENV{HOME}/.rpmmacros
%_topdir	$ENV{HOME}/.rpm
%_tmppath	$ENV{HOME}/.rpm/tmp
EOF
`;

# Build the spec files accordingly
#echo -n "" > $ENV{HOME}/.rpm/SPECS/$files[$i].spec
if(($patchfilename =~ m/^CMWRA/)or($patchfilename =~ m/^CMWPA/)or($patchfilename =~ m/^EIMLA/)or($patchfilename =~ m/^EIMRA/)or($patchfilename =~ m/^PSLHA/)or($patchfilename =~ m/^VDTCA/)or($patchfilename =~ m/^VOSIA/)or($patchfilename =~ m/^VSYSA/)or($patchfilename =~ m/^VTCUA/)or($patchfilename =~ m/^VTSCA/)or($patchfilename =~ m/^PGSLA/)or($patchfilename =~ m/^PNMPA/)or($patchfilename =~ m/^PPDRA/)or($patchfilename =~ m/^PTCRA/)or($patchfilename =~ m/^PLHPA/)or($patchfilename =~ m/^M3UAA/))
{
	print "$patchfilename is in the set of {CMWRA, CMWPA, EIMLA, EIMRA, PSLHA, VDTCA, VOSIA, VSYSA, VTCUA, VTSCA}.\n";
	#copy the file to the exclusive directory
 system("cp -f $inputdir/$patchfilename $inputdir/$useranddate/$patchfilename");
         #push the filename needed to an array
    push(@files,$patchfilename);
    foreach my $i (0..$#files) {
            @names = (@names, $files[$i]);
           print "\$file[$i]";
           }
      #build the spec file	   
 foreach my $i (0..$#files) {
 `
 echo "Name:             $patchfilename" > $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Version:          $version" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Release:          P1" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Summary:          no description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Group:            BSC" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "License:          Alcatel" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 cp $ARGV[0]/$files[$i] $ENV{HOME}/.rpm/tmp$ARGV[2]/$files[$i]
 echo "BuildRoot:        %_tmppath" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "%description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "no description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "%files" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "%attr(755,root,root) $ARGV[2]/$files[$i]" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 `;

 print "$files[$i]\n";
 print "The file $ENV{HOME}/.rpm/SPECS/$files[$i].spec was sucessfully created\n";

 open(A,"$buildrpm $ENV{HOME}/.rpm/SPECS/$files[$i].spec |");
 while(<A>) {print $_;}
 close(A);
 print "\n";

 `rm -f $ENV{HOME}/.rpm/tmp$ARGV[2]/$files[$i]`;
 `mv $ENV{HOME}/.rpm/RPMS/i686/* $ARGV[1]`;
 }
}
else
{
	 print "$patchfilename is not in the set of {CMWRA, CMWPA, EIMLA, EIMRA, PSLHA, VDTCA, VOSIA, VSYSA, VTCUA, VTSCA}.\n";
	 #copy the file to the exclusive directory
  system("cp -f $inputdir/$patchfilename $inputdir/$useranddate/$newname");
    #push the filename needed to an array
  push(@files,$newname);
  foreach my $i (0..$#files) {
          @names = (@names, $files[$i]);
	          print "\$file[$i]";
		          }
			  
 foreach my $i (0..$#files) {
 `
 echo "Name:             $patchfilename" > $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Version:          $version" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Release:          P1" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Summary:          no description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "Group:            BSC" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "License:          Alcatel" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 cp $ARGV[0]/$files[$i] $ENV{HOME}/.rpm/tmp$ARGV[2]/$files[$i]
 echo "BuildRoot:        %_tmppath" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "%description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "no description" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "%files" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 echo "%attr(755,root,root) $ARGV[2]/$files[$i]" >> $ENV{HOME}/.rpm/SPECS/$files[$i].spec
 `;

 print "$files[$i]\n";
 print "The file $ENV{HOME}/.rpm/SPECS/$files[$i].spec was sucessfully created\n";

 open(A,"$buildrpm $ENV{HOME}/.rpm/SPECS/$files[$i].spec |");
 while(<A>) {print $_;}
 close(A);
 print "\n";

 `rm -f $ENV{HOME}/.rpm/tmp$ARGV[2]/$files[$i]`;
 `mv $ENV{HOME}/.rpm/RPMS/i686/* $ARGV[1]`;
 }
}

#Delete the exclusive directory
system("rm -f -r $inputdir/$useranddate");
