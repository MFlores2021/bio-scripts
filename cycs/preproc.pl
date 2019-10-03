#!/usr/local/bin/perl
#use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';

#use warnings;
 my $crop=$ARGV[0];
 my $ecfile=$ARGV[1];
 my $annot=$ARGV[2];


open preOUT, ">$crop.pre.out" or die;


### To get Function
my %hash2;
my %hash_scf;

open FILE3, "$crop.gff.list" or die;

while (my $line3=<FILE3>) {   
    # chomp;
   (my $scf,my $prot, my $gene, my $start, my $end, my $function) = split /\t/, $line3;  

	   if (length($prot) > 0){
	   	# print $prot;
	   	$hash2{$gene}{scf}   = trim($scf);
		$hash2{$gene}{gen}   = trim($gene);
		$hash2{$gene}{start}   = trim($start);
		$hash2{$gene}{end}   = trim($end);
		$hash2{$gene}{function}   = trim($function);
	   	$hash_scf{$scf}   = trim($prot);

	}
}
#print Dumper \%hash2;


### To get EC

my %hash;
open FILE1, "$ecfile" or die;
    
while (my $line=<FILE1>) {   
   #  chomp;
   (my $word1,my $word2) = split /\t/, $line;  
   if (length(trim($word2)) > 0){
          $hash{$word1} = trim($word2);   
	}
}

### To get GOs  ## checked

my %hashanot;
open FILE4, "$annot" or die;

while (my $line4=<FILE4>) {   
   
   my @protdata = split /\t/, $line4;  

	   	$hashanot{$protdata[0]}{id}   = trim($protdata[0]);
	   	$hashanot{$protdata[0]}{desc}   = trim($protdata[1]);

}
#print Dumper \%hash;

### To merge everything and write PF

open FILE2, "$crop.blast.list" or die;
	my $count = 0;
    my $salida;
    my $prot1 ;
	my @blast;
	my @prot;

	while (my $line2=<FILE2>) {   
		chop $line2;
		@blast = ();
		@prot = ();
	    @blast = split /\t/, $line2;  
	   (my $db, my $ort) = split /\|/, $blast[1]; # split ortolog  
	    @prot = split /\|/, $blast[0];  #split prot name
		
	     $prot[3] = $blast[1];
		### Columns for pre-results:
		### [blast 9 col]	genename	ncbi_proteinid	ortolog 	scaf	desc	ncbi_genename(for synomim)	ec 	db
		print preOUT $line2 . "\t".  $hashanot{trim($blast[0])}{id} . "\t". trim($blast[0]) ."\t" . $blast[1]  . "\t" . 
				$hash2{$blast[0]}{scf}  . "\t" . $hashanot{$blast[0]}{desc} . "\t" . trim($hash2{$blast[0]}{gen}) . "\t". 
				$hash{$ort} ."\t" . $db . "\t" . trim($hash2{$blast[0]}{start}) .  "\t" . trim($hash2{$blast[0]}{end}) .  "\t" .
				$hash2{$blast[0]}{function} .  "\n" ;
	
	}



sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_; } ;





