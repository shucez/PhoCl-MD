#!/usr/bin/perl -w
unless (open(FILE,"unigene.blast.pep.fasta"))
{
 die "Can't open the file:$!\n";
}

$aa = ['A', 'C', 'D', 'E', 'F',
        'G', 'H', 'I', 'K', 'L',
        'M', 'N', 'P', 'Q', 'R',
        'S', 'T', 'V', 'W', 'Y'];
print "cluster\tlenth\t";
for $j (@$aa) {
    print "$j\t";
}
print "\n";

$nexrec = &parsefa(FILE);        # Use iterator to parse the fasta file
while (my $aref = $nexrec->()) {
    &freqstat($aref, $aa); 
}

sub parsefa {
    my $hdl = shift;
    $origin = $/;
    $/ = ">Cluster";
    return sub {                            # Note this is an iterator
        while ($loc = <$hdl>) {
            chomp($loc);
            if ($loc) {
                $loc = '>Cluster'.$loc;
            }
            if ($loc =~ /^\s*$/) {         # discard blank line
                next;
            }
            elsif ($loc =~ /^\s*#/) {      # discard comment line
                next;
            }
            elsif ($loc =~ />(Cluster\-\d*.*?);.*\n(\D+)/) {
                $clu = $1;
                #$ref = $2;
                #print "gi=$gi\n";
                #print "ref=$ref\n";
                $seq = $2;
                $seq =~ s/\n//g;
                $seq =~ s/\*//g;
                #print "$clu\t$seq\t\n\n";
                $temp = [$clu, $seq];
                return $temp;
            }
        }
    }
    #$/ = $origin;
}

sub freqstat {
    my $seq_aref = shift;
    my $aa_ref = shift;
    my $_ = $$seq_aref[1];
    #print "$_\n\n";
    my $totlen = length($_);
    print "$$seq_aref[0]\t$totlen\t";
    for $j (@$aa_ref) {
        #print "$j\n";
        $count = s/$j/$j/ig;
        unless ($count) {
            $count = 0;
        }
        $freq = $count / $totlen;
        print "$freq\t";
    }
    print "\n";
}