#!/usr/bin/env perl
use strict;
use Data::Dumper;
my %hashgo;
my $input=$ARGV[0];
my $gotoreplace=$ARGV[1];


open (IN, "<$input") or die ("no such file!");
open (GO, "<$gotoreplace") or die ("no such file!");

while(my $linego = <GO>)
{
   chomp;
   (my $old,my $sep, my $new) = split /\t/, $linego;  
    $old =~ s/GO_/GO:/g;
    $new =~ s/GO_/GO:/g;

    if (length(trim($new)) > 0){
      $hashgo{$old}  = trim($new);
   }
}
#print Dumper \%hashgo;

while(my $line = <IN>)
{ 
  chomp;
print replaceGO($line). "\n";
}
sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
sub replaceGO {
    my $goc = shift; 
    my $go = $goc;
    $go =~ s/DBLINK\t//g; 
    $go = "GO:" . $go; 
    
    if(exists $hashgo{trim($go)}){ $goc = $hashgo{trim($go)}};
    
    return $goc
};
