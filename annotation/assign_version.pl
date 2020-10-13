#!/usr/local/bin/perl
#Author: Mirella Flores

=head1 NAME
    compare_seq.pl
=head1 SYNOPSIS
    compare_seq.pl olversion newversion output
=cut

#use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';

#use warnings;
my $inp1=$ARGV[0];
my $itag4=$ARGV[1];
my $itag3=$ARGV[2];
my $itag2=$ARGV[3];
my $out=$ARGV[4];

open OUT, ">$out" or die;

my %h4;
my %h3;
my %h2;

#local $/ = '>';
open FILE4, $itag4 or die;

while (my $line4=<FILE4>) {     
    chomp; #print $line4;
    (my $id, my $version) = split /\./, $line4;  

    if (length(trim($id)) > 0){
        $h4{trim($id)}{full}   = trim($line4);
        $h4{trim($id)}{version}   = trim($version);
    }
}

open FILE3, $itag3 or die;

while (my $line3=<FILE3>) {     
    chomp; #print $line4;
    (my $id, my $version) = split /\./, $line3;  

    if (length(trim($id)) > 0){
        $h3{trim($id)}{full}   = trim($line3);
        $h3{trim($id)}{version}   = trim($version);
    }
}

open FILE2, $itag2 or die;

while (my $line2=<FILE2>) {     
    chomp; #print $line4;
    (my $id, my $version) = split /\./, $line2;  

    if (length(trim($id)) > 0){
        $h2{trim($id)}{full}   = trim($line2);
        $h2{trim($id)}{version}   = trim($version);
    }
}

#print Dumper \%h2;


open FILE, $inp1 or die;

while (my $line=<FILE>) {
    (my $marker, my $solyc) = split /\t/, $line;
    (my $gene, my $version) = split /\./, $solyc;

    if (trim($h4{$gene}) ne '') {
        print OUT $marker . "\t" . trim($solyc) . "\t" . trim($gene) . "." . ($h4{$gene}{version} + 1 )  . ".1\n" ;
    } elsif (trim($h3{$gene}) ne '') {
        print OUT $marker . "\t" . trim($solyc) . "\t" . trim($gene) . "." . ($h3{$gene}{version} + 1 )  . ".1\n" ;
    } elsif (trim($h2{$gene}) ne '') {
        print OUT $marker . "\t" . trim($solyc) . "\t" . trim($gene) . "." . ($h2{$gene}{version} + 1 )  . ".1\n" ;
    } else {
        print "Error!\n";
    }

}

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

