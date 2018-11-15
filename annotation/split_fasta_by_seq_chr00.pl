#!/usr/local/bin/perl
#Author: Mirella Flores

=head1 NAME
split_fasta_by_seq.pl

=head1 DESCRIPTION
To create TPF.

=cut

#use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';

#use warnings;

$input=$ARGV[0];
$output=$ARGV[1];

open OUT, ">$output" or die;


### To get Function

open ($sfh, "<$input");
my $j=2;
my $i=0;

print OUT ">Contig1\n";

while (<$sfh>) {
    ## if we find a header line ...
        chomp;
        if( />(.*)/){
        # $head = $1; $i=0;
        # next};
        }
        else{
         @a=split("",$_);
         foreach(@a){
                 if($_ eq "N" && $i == 1) {
                    $i++;
                    print OUT "\n".">Contig" .$j."\n";
                    $j++; $count=0;
                 } elsif ($_ eq "N" ) {
                    $i++; $count++;
                 } elsif ($_ ne "N" && $i == 1 ) {
                    $i=0; $count++;
                    print OUT "N" . $_ ;
                 }
                 else {
                   $i=0;
                   $count=1;
                   print OUT $_;
                 }
         }
     }
}

