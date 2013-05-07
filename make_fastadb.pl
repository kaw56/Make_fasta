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
    # if the first line starts with a > skip that line
    if ($line =~ /^>/) {
        next;
    } else {
        chomp $line;        
        push(@seq, $line);
    } 
}

# make the array a string
my $genome = join( "", @seq);

# take the sequence annotation file and make it a hash

open (my $anno_file, '<', $anno_filename) or die "Can't open $anno_filename, $!";

my %annotation_for  = ();

# read in annotation file line by line...
while (my $line = <$anno_file>) {
    
    # split line on space into an array...
    my @gene_information = split(" ", $line);
    
    # take the gene name as the key for the hash...
    my $gene_name = shift @gene_information;
    
    # reference to the 2 position values...   
    my $positions_ref = \@gene_information;
    
    # put into the hash...     
    $annotation_for{$gene_name} = $positions_ref;
    
}

# open an output file

# for each annotation
#   write "> <the name of the gene> <gene length>"
#   write the sequence between the start and stop (remember to adjust for perl counting from 0 rather than 1) on the next line

