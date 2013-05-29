#!usr/bin/perl
# make_fasta.pl
use warnings;
use strict;

# make sure that this is just a little reusable..

die "usage: make_fasta.pl <sequence file>" unless (@ARGV == 1);

my $seq_filename    = shift;
my $fasta_db_name   = $seq_filename . "_db.fa";

open(my $seq_file, '<', $seq_filename) or die "can't open file $seq_filename, $!";
open(my $fasta_file, '>', $fasta_db_name) or die "can't open file $fasta_db_name, $!";

while (my $line = <$seq_file>) {
    chomp $line;
    if ($line =~ /^[ATCG]+$/) { # if the line is entirely DNA seqence
       print "$line\n";            
    } elsif ($line =~ /Full-length (\w+) cDNA/) { # if the line has gene info
        print ">$1\n";
    } 
}



