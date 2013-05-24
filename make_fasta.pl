#!usr/bin/perl
# make_fasta.pl
use warnings;
use strict;

# make sure that this is just a little reusable..

die "usage: make_fasta.pl <sequence file> <annotation file>" unless (@ARGV == 2);

my $seq_filename    = shift;
my $anno_filename   = shift;
my $fasta_db_name   = $seq_filename . "_db.fa";

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

close($seq_file);

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

close($anno_file);

open (my $fasta_db, '>', $fasta_db_name) or die "Can't open $fasta_db_name, $!";

# loop through the keys to my annotation hash 
foreach my $gene (keys %annotation_for) {
    
    # find the gene length (plus one because nucleotide counts are inclusive
    my $gene_length = abs(${$annotation_for{$gene}}[0] 
                            - ${$annotation_for{$gene}}[1]) + 1;
    
    # print identifier line to output
    print $fasta_db ">$gene length = $gene_length\n";
    
    # make new variables for the sequence coordinates and 
    # subtract 1 to account for counting from 0
    my $gene_start = ${$annotation_for{$gene}}[0] - 1;    
        
    # substring to extract sequence 
    my $gene_seq = substr($genome, $gene_start, $gene_length);
    
    #print to fasta database
    print $fasta_db "$gene_seq\n";
}

close ($fasta_db);

