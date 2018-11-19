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
my $inp2=$ARGV[1];
my $out=$ARGV[2];

open OUT, ">$out" or die;

open ($sfh, "<$inp2");

my %hNew;
my %hNew1;
my @list;

#local $/ = '>';

while (<$sfh>) {
    chomp;
    if($_ =~ /^>(S.+)/){
        $id = trim($1);
        $id2 = substr($id, 0, index($id, '.'));
    } else {
        $hNew{$id} .= trim($_);
        $hNew1{$id2} .= trim($_);
    }
}
# print Dumper \%hNew1;

open ($sfh2, "<$inp1");

my %hOld;  
my %hOld1; 
my $id ='';

while (<$sfh2>) {
    chomp;
    if($_ =~ /^>(.+)/){
        $id = trim($1);
        $id2 = substr($id, 0, index($id, '.'));
    }else{
        $hOld{$id} .= trim($_);
        $hOld1{$id2} .= trim($_);
    }
}


foreach my $gene (keys %hNew){

    if ($hNew{$gene} eq $hOld{$gene}) {
        print OUT $gene . "\t" . $gene . "\t" . $gene . "\n" ;
    } else {
    	my $gene1 = substr($gene, 0, index($gene, '.'));

        if ($hNew1{$gene1} eq $hOld1{$gene1}) {
            ($matching_key) = grep { $_ =~ /$gene1/  } keys %hOld;
              	print OUT $gene1 . "\t" . $matching_key ."\n";
                # print $gene1 . " " . $matching_key. "\n" ;
        }
    }
}

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

