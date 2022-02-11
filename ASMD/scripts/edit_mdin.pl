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
# $Id: edit_mdin.pl, Shuce 2020
# Usage: from ../ (should be a directory called ASMD), run
# perl scripts/edit_mdin.pl 100 40 mdin/asmd.mdin

#use biolearning;
my $num=@ARGV;
if($num<3)
{
   die  "$0 requires TWO starting numbers and an input .PDB file\n";
}
my $i=shift(@ARGV); #number of simulations
my $j=shift(@ARGV); #number of steps
my $f=shift(@ARGV); #template files
#print "$i\t$j\t$f\n";

for ($count = 1; $count <= $j; $count++){
	for ($sim = 1; $sim <= $i; $sim++){
		unless (open(INFILE,"$f"))
		{
    			die "Can't open the file:$!\n";
		}
		unless (open(OUTFILE,'>',$f.".$count".".$sim"))
		{
    			die "Can't write to the file:$!\n";
		}
		while ($line = <INFILE>)
    		{
        		chomp($line);
            		$line =~ s/\$STAGE/$count/;
			$line =~ s/\$SIML/$sim/;	
            		print(OUTFILE "$line\n");
    		}
		close INFILE;
		close OUTFILE;
	}
}
print "processed $count stages and $sim simulations successfully!\n";

