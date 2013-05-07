#!usr/bin/perl
# make_fastadb.pl
use warnings;
use strict;

# make sure that this is just a little reusable..

die "usage: make_fastadb.pl <sequence file> <annotation file>" unless (@ARGV == 2);

my $seq_filename    = shift;
my $anno_filename   = shift;

open(my $seq_file, "<", $seq_filename) or die "can't open file $seq_filename, $!";

# read sequence into an array
my @seq;

while (my $line = <$seq_file>) {
    if ($line =~ /^>/) {
        next;
    } else {
        chomp $line;        
        push(@seq, $line);
    } 
}

# make the array a string
my $genome = join( "", @seq);

print "$genome\n";

# take the sequence annotation file I made and make it a hash? 

# open an output file

# for each annotation
#   write "> <the name of the gene> <gene length>"
#   write the sequence between the start and stop (remember to adjust for perl counting from 0 rather than 1) on the next line

