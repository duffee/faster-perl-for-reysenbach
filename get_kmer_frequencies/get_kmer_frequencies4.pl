#!/usr/bin/perl
###########################################################################
### Get kmer Frequencies                                                ###
### Usage: get_kmer_frequencies.pl <fasta file>                         ###
### This program takes a fasta file, k and a prefix as it's parameters. ###
###                                                                     ###
### It returns a tab delimited file                                     ###
###                                                                     ###
### Jennifer Meneghin                                                   ###
### May 11, 2015                                                        ###
###                                                                     ###
### Updated. Now it returns results with summed reverse compliments     ###
### Jennifer Meneghin                                                   ###
### February 10, 2016                                                   ###
###########################################################################
#
# Output identical to original jmeneghin/get_kmer_frequencies.pl - duffee, July 2023
#
#---------------------------------------------------------------------------------------------------------------------------
#Deal with passed parameters
#---------------------------------------------------------------------------------------------------------------------------

use warnings;
use strict;
use v5.10;

usage() unless @ARGV;

my ($fasta_file, $k, $prefix) = @ARGV;
my $out_file = "${prefix}_kmers.txt";

open my $in_fh,  '<', $fasta_file or die "Got a bad fasta file: $fasta_file : $!\n";
open my $out_fh, '>', $out_file   or die "Couldn't create $out_file: $!\n";

say join "\n", "Parameters:", "fasta file = $fasta_file", "output file = $out_file",
    "k = $k";

#---------------------------------------------------------------------------------------------------------------------------
#The main event
#---------------------------------------------------------------------------------------------------------------------------

my $start = time();

my ($seq, $id, %knucs) = (0, 0, ());
my ($pc,  $linecount) = (0, 0);

while (<$in_fh>) {
    chomp;
    if (/^>/) {

        #finish up previous line.
        if (length($seq) > 0) {
            process_it();
        }

        #start new line.
        $id = $_;
        $id =~ s/^>//g;
        $pc++;
        if ($pc % 100 == 0) {
            say "count = $pc";
        }
    } else {
        $seq .= uc($_);
    }
    $linecount++;
    if ($linecount % 10000 == 0) {
        say "line count = $linecount";
    }
}

#finish up last line.
process_it();

say "Sorting...";
my (%kmers, %records);

for my $i (keys %knucs) {
    my ($record, $kmer) = split ':', $i;

    $kmers{$kmer}++;
    $records{$record}++;
}
my @record_keys = sort keys %records;

say "Printing...";
say $out_fh join "\t", "${k}-mer", @record_keys; # header line

my $testsum = 0;
for my $i (sort keys %kmers) {
    my @items = map { my $key = join ':', $_, $i; $knucs{$key} // 0 }
        @record_keys;
    say $out_fh join "\t", $i, @items;
#    $testsum += $_ for @items;
}

#print "TEST SUM = $testsum\n";
close($in_fh);
close($out_fh);

my $stop       = time();
my $total_time = $stop - $start;
say "Total time to run = $total_time";
exit;

sub usage {
    say <<USAGE;
Get kmer Frequencies
Usage: $0 <fasta file>
This program takes a fasta file, k and prefix as it's parameters.

It returns a tab delimited file (knucs_out.txt) of kmer counts. (columns = records, rows = kmer counts.)

Jennifer Meneghin
May 11, 2015

Updated. Now results are returned with summed reverse compliments
Jennifer Meneghin
February 10, 2016
USAGE
    exit;
}

sub process_it {
    my @letters = split //, $seq;
    my $end     = @letters - $k;

    for my $i (0 .. $end) {
        my $thiskmer = q{};
        for my $j ($i .. ($i + $k - 1)) {
            $thiskmer .= $letters[$j];
        }
        my $rckmer = rc_seq($thiskmer);

        #print "$id\tthiskmer = $thiskmer\n";
        #print "$id\trc  kmer = $rckmer\n";
        my $key = join ':', $id, ($thiskmer le $rckmer ? $thiskmer : $rckmer);

        $knucs{$key}++;
    }
    $seq = q{};
    $id  = q{};
}

sub rc_seq {
    my ($mykmer)  = @_;
    my @myletters = split //, $mykmer;
    my (@rcmykmer, $thisrcmykmer);

    for my $i (0 .. $k - 1) {
        if ($myletters[$i] eq "A") {
            $rcmykmer[ $k - $i - 1 ] = "T";
        } elsif ($myletters[$i] eq "C") {
            $rcmykmer[ $k - $i - 1 ] = "G";
        } elsif ($myletters[$i] eq "G") {
            $rcmykmer[ $k - $i - 1 ] = "C";
        } elsif ($myletters[$i] eq "T") {
            $rcmykmer[ $k - $i - 1 ] = "A";
        } else {
            $rcmykmer[ $k - $i - 1 ] = $myletters[$i];    #No swap of Ns and such
        }
    }
    $thisrcmykmer = join q{}, map { $rcmykmer[$_] } (0 .. $k - 1);

    return $thisrcmykmer;
}
