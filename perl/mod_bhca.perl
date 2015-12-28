#!/usr/bin/perl

use integer;

sub main
{
	if ($#ARGV == -1)
	{
		print "Usage: mod_bhca.perl <profile> <target ratio>\n";
		print "Example:\n";
		print "mod_bhca.perl moc_ms 50%\n";
		print "  => decrease the BHCA to 50% of the original setting.\n";
		exit 0;
	}

	$ratio_valid = 0;
	if ($ARGV[1] =~ m/^(\d{1,3})\%$/)
	{
		$ratio = $1;
		if ($ratio != 0)
		{
			$ratio_valid = 1;
		}
	}
	if ($ratio_valid == 0)
	{
		print "[Error] Invalid ratio or ratio not specified.\n";
		exit 0;
	}

	system "tar zcvf ./mod_bhca_backup.tar.gz ./run_abis_*_pool*";

	@files = glob("./run_abis_*_pool*");
	$num_of_files = @files;
	for ($i = 0; $i < $num_of_files; $i++)
	{
		if (!open("fin", "<${files[$i]}"))
		{
			print "[Error] Cannot open ${files[$i]}.\n";
			exit 0;
		}

		if (!open("fout", ">mod_bhca.tm0"))
		{
			print "[Error] Cannot create temporary file.\n";
			close "fin";
			exit 0;
		}

		while (<fin>)
		{
			chop;
			if (m/^(.*) ($ARGV[0]_\d\d) (\d*)$/)
			{
				$leading = $1;
				$profile = $2;
				$interval = $3;
				$interval = (100 * $interval) / $ratio;
				printf fout ("%s %s %d\n", $leading, $profile, $interval);
			}
			else
			{
				printf fout ("%s\n", $_);
			}
		}

		close "fin";
		close "fout";
		system "mv ./mod_bhca.tm0 ./${files[$i]}";
		system "chmod 755 ./${files[$i]}";
	}
}

main();
