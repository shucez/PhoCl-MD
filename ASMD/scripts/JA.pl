#!/usr/bin/perl -w
#SBATCH --account=def-recfp2
#SBATCH --mem=10000M
#SBATCH --time=0-00:15:00
#SBATCH --mail-user=shuce@ualberta.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
# $Id: computing JA for a given stage, Shuce 2020
# Usage: from ../ (should be a directory called ASMD), run
# perl scripts/JA.pl 1 scripts/submit.asmd.sh

#use biolearning;
my $i=shift(@ARGV); # the stage you want to compute
my $f=shift(@ARGV); # the template submit scripts
my $result = `python2 scripts/ASMD.py -i dats/work.dat.$i.* -o dats/stage$i.dat`;
#my $result = "The file closest to the Jarzynski Average is:   work.dat.1.47";

$j=$i + 1; #The next stage
# print "$result\n";
# $result should be something like "The file closest to the Jarzynski Average is:   work.dat.1.47"

$result =~ /$i\.(\d*)$/;
print "$1\n";
my $choose = $1;

unless (open(INFILE,"$f"))
{
    	die "Can't open the file:$!\n";
}
unless (open(OUTFILE,'>',$f.".$j"))
{
    	die "Can't write to the file:$!\n";
}
unless (open(CHOOSE,'>',"choose.$i"))
{
    	die "Can't write to the file:$!\n";
}
print(CHOOSE "$choose\n");
while ($line = <INFILE>)
{
        chomp($line);
        $line =~ s/\$STAGE/$j/g;
	$line =~ s/\$EX/$i/g;
	$line =~ s/\$JA/$choose/g;	
        print(OUTFILE "$line\n");
}
close INFILE;
close OUTFILE;
