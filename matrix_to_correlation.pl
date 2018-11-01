#!/usr/bin/perl

#use strict;
#use warnings;

my $inputfile=$ARGV[0];

# open input file and read it line by line
open (my $file_fh, "<", $inputfile) || die ("\nERROR: the input file  could not be found\n");
open OUT, ">corr_matrix.txt" or die;

my $header = <$file_fh>;
chomp($header);
# print "$header\n";

my @gene_header = split("\t",$header);
unshift(@gene_header,"");

# print "$gene_header[0]\t$gene_header[1]\n";

my %pairs;

while (my $line = <$file_fh>) {
  chomp($line);
  
  my @line = split("\t",$line);
  
  for (my $n = 1; $n < @gene_header; $n++) {
    
    $line[0] =~ s/\"//g;
    $gene_header[$n] =~ s/\"//g;
    
    my $hash_key = $line[0]."_".$gene_header[$n];
    my $hash_key2 = $gene_header[$n]."_".$line[0];
    
    # print STDERR "$hash_key\n";
    # if ($line[$n] ne "NA") {
    #  print $line[0] ."-". $gene_header[$n] ."\t";
    if ($line[$n] >= 0.65 && $line[0] ne $gene_header[$n]) {
      if (!$pairs{$hash_key}) {
        print OUT "$line[0]\t$gene_header[$n]\t".sprintf("%.2f",$line[$n])."\n";
        $pairs{$hash_key} = 1;
        $pairs{$hash_key2} = 1;
      }
    #}
  }
  }
  
}

