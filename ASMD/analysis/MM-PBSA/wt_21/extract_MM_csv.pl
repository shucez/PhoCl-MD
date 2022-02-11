#!/usr/bin/perl -w
#
my $num=@ARGV;
if($num<1)
{
   die  "$0 requires 1 argument as input file\n";
}

$filename = $ARGV[0];

# for testing only
# $filename = "energy_stage21.csv";

if ($filename =~ /\D*(\d*)\.csv/) {
        $aaa = $1;
}

unless (open(FILE, $filename))
{
 die "Can't open the file:$!\n";
}

my $meth;
my $part;
my $header = 0;

print "Processing stage $aaa\n";

while (my $line = <FILE>) {
            chomp($line);
	    $line =~ s/[\r\n]+//g;
	    #if ($line) {
	    #    print "$line\n\n\n\n\n";
	    #}
            if ($line =~ /^\s*$/) {         # discard blank line
                next;
            }
            elsif ($line =~ /GENERALIZED BORN/) {
		    $meth = "gb";
		    $header = 0;
            }
	    elsif($line =~ /POISSON BOLTZMANN/) {
		    $meth = "pb";
		    $header = 0;
   	    }
	    elsif($line =~ /Complex/) {
                    $part = "com";
		    $header = 0;
            }
	    elsif($line =~ /Receptor/) {
                    $part = "rec";
		    $header = 0;
            }
	    elsif($line =~ /Ligand/) {
                    $part = "lig";
		    $header = 0;
            }
	    elsif($line =~ /DELTA Energy/) {
                    $part = "del";
		    $header = 0;
            }
	    elsif($line =~ /^Frame/ && $header == 0) {
		    open(FH, ">>$meth$part$aaa.csv") or die;
		    print FH "$line,Stage\n";
		    close(FH);
		    $header = 1;
	    }
	    elsif($line =~ /^\d*,.*/) {
		    open(FH, ">>$meth$part$aaa.csv") or die;
                    print FH "$line,$aaa\n";
                    close(FH);
            }
    }

