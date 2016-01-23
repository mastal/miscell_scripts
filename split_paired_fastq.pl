#!/usr/bin/perl

# Maria Stalteri
# split_paired_fastq.pl
# 23/01/2016

# split interleaved fastq into 2 files
# trying this on an interleaved file from the ENA
# ERR194146.fastq

# doesn't work because they are not interleaved reads
# reads appear in random order, not R1 and R2 next to
# each other, and appear to be from more than 1 lane;
# try the SRA toolkit;

# but should work on properly interleaved reads;

# a  quick and dirty script without too many checks


use strict;
use warnings;

# usage:
unless (3 == scalar(@ARGV)) {
    die "Usage: $0 input_interleaved.fastq output_read1.fastq output_read2.fastq\n";
}


my $interleavedFastq = $ARGV[0];
my $read1Fastq = $ARGV[1];
my $read2Fastq = $ARGV[2];


# a  quick and dirty script without too many checks

# open filehandles 
open(IN1, "<$interleavedFastq")
    or die "\nUnable to open input file $interleavedFastq\n\n";

open(OUT1, "> $read1Fastq")
    or die "\nUnable to open output file $read1Fastq\n\n";

open(OUT2, "> $read2Fastq")
    or die "\nUnable to open output file $read2Fastq\n\n";

# check that output files don't already exist
if (-e "$ARGV[1]") {
    die "Output file $ARGV[1] already exists\n";
}

if (-e "$ARGV[2]") {
   die "Output file $ARGV[2] already exists\n";
}


while (my $line = <IN1>){

    # print Read1 reads to one file
    if ($line =~ m{^\@.*/1$}){
        print OUT1 $line;

        # print next 3 lines

        for (my $i=1; $i < 4; $i++){
            $line = <IN1>;   
            print OUT1 $line; 

        } # end for

    } # end if
    elsif ($line =~ m{^\@.*/2$}){
        # print Read2 reads to a second file
        print OUT2 $line;

        # print next 3 lines
        for (my $j=1; $j < 4; $j++){
            $line = <IN1>;
            print OUT2 $line;

        } # end for
        
    }  # end elsif

} # end while

# close filehandles
close(IN1)
or die "\nUnable to close input file $interleavedFastq\n\n";

close(OUT1)
or die "\nUnable to close output file $read1Fastq\n\n";

close(OUT2)
or die "\nUnable to close output file $read2Fastq\n\n";


