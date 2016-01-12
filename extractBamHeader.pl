#!/usr/bin/perl

# Maria Stalteri
# 17/10/2014
# extractBamHeader.pl

# compare chr names and lengths from 
# Ravindra's RNASeq bam file and the ensembl
# genomes, to try and find out why the gtf
# gives errors

# do this in a modular way,
# SO, this script will just parse
# the bam header and produce a table
# with chr_name and chr_length


# parse the bam file header
# format of the relevant lines is:
# @SQ\tSN:chr_name\tLN:chr_length

# want to check that chromosome names are unique,
# so put them into a hash, with chr_names as keys,
# and want to count how many chromosomes as well;

# to call the script:
# ./extractBamHeader.pl bam_header.txt > output.txt

use strict;
use warnings;

my $seqLines = 0;
my %bamHeader;

while (my $line = <>){
    if ($line =~ /^\@SQ\tSN:([A-Z\d\.\_]+)\tLN:(\d+)\n/){
        
         $seqLines++;         

         # $1 is the chr_name  
         # $2 is the chr_length

         my $chrName = $1;
         my $chrLen = $2;
         
         if (exists $bamHeader{$chrName}){

              print STDERR "Error, chromosome hash key already exists\n $line.";
         }
         else{
             $bamHeader{$chrName} = $chrLen;

         } # end else, add chr name to hash
         
    } # end if, regex matches
    else {
        # regex doesn't match,
        # missing a line somewhere
        # of course the lines without @SQ at start won't match
        print STDERR "Line $line doesn't match regex.\n";

    } # end else, regex doesn't match

} # end while


my $noOfChr = keys(%bamHeader);

foreach my $chr (sort keys %bamHeader){
    print "$chr\t$bamHeader{$chr}\n";

}

print STDERR "\n\nThe number of sequence lines in the bam header is: $seqLines\n";
print STDERR "The number of keys in the hash with chr as key is: $noOfChr\n\n";

