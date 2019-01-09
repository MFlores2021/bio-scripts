
#!/usr/local/bin/perl
#Author: Mirella Flores (BTI)

=head1 NAME
annotate_fasta_pyllid.pl
=head1 SYNOPSIS
annotate_fasta_pyllid.pl

Usage: perl annotate_fasta_psyllid.pl listids.txt ahrd.OGS2.0beta.final.txt  OGS2.0beta.interproGO.tsv OGS2.0beta.interproPFAM.tsv sale.txt

=cut

#use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';

#use warnings;
$inputList=$ARGV[0];
$inputAhrd=$ARGV[1];
$inputGO=$ARGV[2];
$inputPFAM=$ARGV[3];
$inputMCOT=$ARGV[4];
$inputNCBI=$ARGV[5];
$inputAED=$ARGV[6];
$output=$ARGV[7];

open OUT, ">$output" or die;


### To get Function
my %hashahrd;
my %hashinterPfam;
my %hashinterGO;
my %hashinterMCOT;
my %hashinterNCBI;
my %hashinterAED;

#file with geneid and description
open FILE3, $inputAhrd or die;

while (my $line3=<FILE3>) {   
    # chomp;
    (my $protid, my $desc) = split /\t/, $line3;  
    # (my $db,my $ortid,my $geneid) = split /\|/, $desc1;  
    # if (length(trim($geneid))<1) { $geneid= $db;}

	if (length(trim($protid)) > 0){
	   	$hashahrd{trim($protid)}{desc}   = trim($desc);   #Solyc05g015840.2.1      Squamosa promoter binding protein NtabSPL13 (AHRD V3.3 *** A0A125SZN9_TOBAC)
	}
}
# print Dumper \%hashahrd;
#Proper format: file with 3 columns: geneid, IPR(interprofamily), GO
open FILE4, "$inputGO" or die;

while (my $line4=<FILE4>) {   
    # chomp;
    (my $protid, my $interpro, my $gos) = split /\t/, $line4;  
    $gos =~ s/\|/,/g; 

	if (length(trim($protid)) > 0){
	   	$hashinterGO{trim($protid)}{interpro}   = trim($interpro);   # mRNA:Solyc00g017910.1.1 IPR002504       GO:0003951|GO:0006741|GO:0008152
	   	$hashinterGO{trim($protid)}{go}   = trim($gos);  
	}
}

#Proper format: file with 3 columns: geneid, DB (eg. Pfam), PFAM name
open FILE5, "$inputPFAM" or die;

while (my $line5=<FILE5>) {   
    # chomp;
    (my $protid,my $interpro,my $q, my $pfam) = split /\t/, $line5;  
    $protid =~ s/mRNA://g; 
        # $protid =~ s/\.[0-9]//g;
	   if (length(trim($protid)) > 0){
	   	$hashinterPfam{trim($protid)}{interpro}   = trim($interpro);  
	   	$hashinterPfam{trim($protid)}{pfam}   = trim($pfam);  # mRNA:Solyc00g041190.1.1 IPR009081       Pfam    PF00550
	   }
}

open FILE, "$inputMCOT" or die;

while (my $line=<FILE>) {   
    # chomp;
    (my $protid,my $mcot) = split /\t/, $line;  

	   if (length(trim($protid)) > 0){
	   	$hashinterMCOT{trim($protid)}  = trim($mcot);  # DcitrP000065.1.1        MCOT03335.0.CC
	   }
}

open FILE, "$inputNCBI" or die;

while (my $line=<FILE>) {   
    # chomp;
    (my $protid,my $ncbi) = split /\t/, $line;  

	   if (length(trim($protid)) > 0){
	   	$hashinterNCBI{trim($protid)}  = trim($ncbi);  # DcitrP000065.1.1        MCOT03335.0.CC
	   }
}

open FILE, "$inputAED" or die;

while (my $line=<FILE>) {   
    # chomp;
    (my $protid,my $aed) = split /\t/, $line;  

	   if (length(trim($protid)) > 0){
	   	$hashinterAED{trim($protid)}  = trim($aed);  # DcitrP000065.1.1        MCOT03335.0.CC
	   }
}


open FILE6, "$inputList" or die;
my $output; my $i,$j,$k,$l;

while (my $id=<FILE6>) {   
    # chomp;
    $id=trim($id);
	$output = "" ;
	# print trim($hashahrd{trim($id)}{desc}). "    ";
    if (trim($hashahrd{trim($id)}{desc}) ne '') {
		$output = $output .  $hashahrd{$id}{desc} ; $k++;
	}
	else{
		$l++;
	}
	if ( trim($hashinterMCOT{trim($id)}) ne '' || trim($hashinterNCBI{trim($id)}) ne '' ){ 
		if (trim($output) ne '') { $output = $output .". Similar to "; }
		else { $output = $output ."Similar to "; } 
	}
	$output = $output .$hashinterMCOT{trim($id)}. " ";
	$output = $output .$hashinterNCBI{trim($id)};

	if (trim($hashinterAED{trim($id)}) ne ''){
		if (trim($output) ne '') {$output = $output . ". AED " . $hashinterAED{trim($id)};}
		else { $output = $output . "AED " . $hashinterAED{trim($id)};}
	}

	if (trim($hashinterGO{$id}{interpro}) ne ''){
		#$output = $output . " contains Interpro domain(s) " . $hashinterGO{$id}{interpro} .
		$output = $output . ";Dbxref=InterPro:". $hashinterGO{$id}{interpro} ;
	}
	elsif (trim($hashinterPfam{$id}{interpro}) ne ''){
		$output = $output . ";Dbxref=InterPro:". $hashinterPfam{$id}{interpro} ;
	}

	if (trim($hashinterPfam{$id}{pfam}) ne ''){
		$output = $output . ",Pfam:" . $hashinterPfam{$id}{pfam} ;
	}
	if (trim($hashinterGO{$id}{go}) ne ''){
		$output = $output . ";Ontology_term=" . trim($hashinterGO{$id}{go}) ;
	}

	print OUT $id ."\t" . $output . "\n"; 
}
print $i."\t".$j."\t".$k."\t".$l."\n";

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };



