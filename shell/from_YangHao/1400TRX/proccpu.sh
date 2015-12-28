#!/usr/bin/perl

#
# Silent mode
#

sub main
{
	$fn[0]  = "omcp1.log";
	$fn[1]  = "omcp2.log";
	$fn[2]  = "ccp5.log";
	$fn[3]  = "ccp6.log";
	$fn[4]  = "ccp7.log";
	$fn[5]  = "ccp8.log";
	$fn[6]  = "ccp9.log";
	$fn[7]  = "ccp10.log";
	$fn[8]  = "ccp12.log";
	$fn[9]  = "ccp14.log";
	$fn[10]  = "tp1.log";
	$fn[11]  = "tp2.log";
	$fn[12] = "pq2_tp1.log";
	$fn[13] = "pq2_tp2.log";

	$type[0]  = "OMCP1    ";
	$type[1]  = "OMCP2    ";
	$type[2]  = "CCP5     ";
	$type[3]  = "CCP6     ";
	$type[4]  = "CCP7     ";
	$type[5]  = "CCP8     ";
	$type[6]  = "CCP9     ";
	$type[7]  = "CCP10    ";
	$type[8]  = "CCP12    ";
	$type[9]  = "CCP14    ";
	$type[10]  = "TP_GSM13 ";
	$type[11]  = "TP_GSM11 ";
	$type[12] = "PQ2_TP13 ";
	$type[13] = "PQ2_TP11 ";


	for ($i = 0; $i < 14; $i++)
	{
		if (!open("fin", "</var/log/CPULoad/${fn[$i]}"))
		{
			next;
		}

		$cnt = 0;
		$val = 0.0;
		$linenbr = 0;

		for ($j = 0; $j < 327680; $j++)
		{
			$buf[$j] = 0.0;
		}

		if ($fn[$i] =~ /^pq2_tp[12]\.log$/)
		{
			while (<fin>)
			{
				chop;
				$linenbr++;

				while (m/PQ2 cpu load = ([0-9.]+)%/g)
				{
					$val = $1;
					if ($cnt == 327680)
					{
						last;
					}
					else
					{
						if ($val >= 0.0 && $val <= 100.0)
						{
							$buf[$cnt++] = $val;
						}
					}
				}
			}
		}
		else
		{
			while (<fin>)
			{
				chop;
				$linenbr++;

				if (m/.+\s(\d{1,3})\s+(\d{1,3})$/)
				{
					$val = $1;
					if ($cnt == 327680)
					{
						last;
					}
					else
					{
						if ($val >= 0.0 && $val <= 100.0)
						{
							$buf[$cnt++] = $val;
						}
					}
				}
			}
		}

		close "fin";

		$sum = 0.0;
		for ($j = 0; $j < $cnt; $j++)
		{
			$sum += $buf[$j];
		}

		if ($cnt > 0)
		{
			printf("%s%f%%\n", $type[$i], $sum / $cnt);
		}
		else
		{
			next;
		}


		if (!open("fout", ">/var/log/CPULoad/${fn[$i]}.csv"))
		{
			next;
		}

		select "fout";
		for ($j = 0; $j < $cnt; $j++)
		{
			printf("%f\n", $buf[$j]);
		}

		select STDOUT;
		close "fout";
	}
}

main();

