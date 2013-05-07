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

#################################################
# this is just to test that my sequence is fine #
#################################################

use Bio::SeqIO;
use Bio::Tools::Run::StandAloneBlastPlus;

# open file for reading as a sequence file
my $seq_in = Bio::SeqIO->new(-format => 'fasta',
                             -file   => $seq_filename);
my $seq1 = $seq_in->next_seq();

# need to have my string looking like fasta format
my $genome2 = ">mitogenome\n" . $genome;

# need to do some perl magic to make it deal with the string properly
open(my $stringfh, "<", \$genome2) or die "Could not open string for reading: $!";

my $seqio = Bio::SeqIO-> new(-fh     => $stringfh,
                             -format => 'fasta');
my $seq2 = $seqio->next_seq();

# run bl2seq
my $factory = Bio::Tools::Run::StandAloneBlastPlus->new(-db_name => 'testdb',
                                                        -create => 1);

$factory->bl2seq(   -method  => 'blastn',
                    -query   => $seq1,
                    -subject => $seq2,
                    -outfile => 'bl2seq-out',);

$factory->cleanup;

# take the sequence annotation file I made and make it a hash? 

# open an output file

# for each annotation
#   write "> <the name of the gene> <gene length>"
#   write the sequence between the start and stop (remember to adjust for perl counting from 0 rather than 1) on the next line

