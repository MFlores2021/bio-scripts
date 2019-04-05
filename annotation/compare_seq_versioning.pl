#!/usr/local/bin/perl
#use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';

#use warnings;
my $in1=$ARGV[0];
my $in2=$ARGV[1];
my $out=$ARGV[2];

open OUT, ">$out" or die;
open OUT1, ">d$out" or die;

open ($sfh, "<$in2");

my %hNew;
my @list;
my @dif;

local $/ = '>';

while (<$sfh>) {
    chomp;
    /(\w+).+?\n(.+)/s and $hNew{trim($1)} = trim($2) or next;
    #print $1;
}

open ($sfh2, "<$in1");

my %hOld;
local $/ = '>';

while (<$sfh2>) {
    chomp;
    /(\w+).+?\n(.+)/s and $hOld{trim($1)} = trim($2) or next;
}

foreach my $gene (keys %hNew){

    if ($hNew{$gene} eq $hOld{$gene}) {
        push @list, $gene; #print @list;
    }
    else {
	push @dif, $gene;
	}
}
print OUT Dumper @list ;
print OUT1 Dumper @dif;
print scalar @list;
#print Dumper \%hash3;

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

