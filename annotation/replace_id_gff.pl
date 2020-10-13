
#!/usr/local/bin/perl
#Author: Mirella Flores

=head1 NAME
rename_id_with_annot_infasta.pl

=head1 DESCRIPTION
Cutomized for the following inputs files.
    File with description:
    Solyc00g005000.2    Solyc00g005000.3    Note=Eukaryotic aspartyl protease family protein (AHRD V3.3 *** 
    Fasta File:
    mRNA:Solyc00g005000.3.1 (joined) (translated)
=cut

use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';
# use warnings;

my $gff=$ARGV[0];
my $desc=$ARGV[1];
 
open OUT, ">$gff.renamed.gff" or die;
open OUT2, ">$gff.renamed_not.gff" or die;


### To get Function
my %hashgene;
my %hashmRNA;
my %hashexon;
my %hashCDS;
my %hash3;
my %hash5;

open FILE3, "$desc" or die;

while (my $line3=<FILE3>) {   

    (my $maker,my $oldid, my $newid) = split /\t/, $line3;  
    
    if (length(trim($maker)) > 0){
	   	$hashgene{trim($maker)}                     = "gene:" . trim($newid);
        $hashmRNA{trim($maker."-mRNA-1")}{mRNA}     = "mRNA:" . trim($newid). ".1";
        $hashmRNA{trim($maker)."-mRNA-1"}{parent}   = "gene:" . trim($newid);
        $hashexon{trim($maker)."-mRNA-1:"}{exon}    = "exon:" . trim($newid) .".1.";
        $hashexon{trim($maker)."-mRNA-1"}{parent}   = "mRNA:" . trim($newid) .".1";
        $hashCDS{trim($maker."-mRNA-1")}{cds}       = "CDS:" . trim($newid). ".1.";
        $hashCDS{trim($maker)."-mRNA-1"}{parent}    = "mRNA:" .  trim($newid) .".1";
        $hash3{trim($maker)."-mRNA-1"}{three}       = "three_prime_UTR:" . trim($newid) .".1.";
        $hash3{trim($maker)."-mRNA-1"}{parent}      = "mRNA:" . trim($newid) .".1";
        $hash5{trim($maker)."-mRNA-1"}{five}        = "five_prime_UTR:" .trim($newid) .".1.";
        $hash5{trim($maker)."-mRNA-1"}{parent}      = "mRNA:" .trim($newid) .".1";
	}
}


open FILE, "$gff" or die;
my $ncds =1;
my $n5 =0;
my $n3 =0;
my @array = [];
while (my $line=<FILE>) {
    ## if we find a header line ...
    @array = split /\t/, $line; 
    (my $id) = trim(split /\;/, $array[8]);
        $id =~ s/ID=//g; 

    if ($array[2] eq "gene") {
        my $newid = $hashgene{trim($id)};
        if(length($newid)>0){
            $line =~ s/$id/$newid/g;
            print OUT $line;
        }   else {
            print OUT2 $line;
        }
    } elsif ($array[2] eq "mRNA") {
        my $newid = trim($hashmRNA{$id}{mRNA});
        my $parentid = trim($hashmRNA{$id}{parent});
        if(length($newid)>0){
            $line =~ s/$id/$newid/g;
            $id =~ s/-mRNA-1//g;
            $line =~ s/$id/$parentid/g;
            print OUT $line;
        }   else {
            print OUT2 $line;
        }
        $ncds = 1; $n5 = 0; $n3 = 0;
    } elsif ($array[2] eq "exon") {
        my @id1 = split /:/, $id; 
        my $id1 = trim(@id1[0]) .":";
        my $id2 = trim(@id1[0]);
        my $newid = trim($hashexon{$id1}{exon});
        my $parentid = trim($hashexon{$id2}{parent});
        if(length($newid)>0){
            $line =~ s/$id1/$newid/g; 
            $line =~ s/$id2/$parentid/g;
            print OUT $line;
        }   else {
            print OUT2 $line;
        }
    } elsif ($array[2] eq "CDS") {
        my @id1 = split /:/, $id; 
        my $id1 = trim(@id1[0]) .":cds";
        my $idx = trim(@id1[0]);
        my $newid = trim($hashCDS{$idx}{cds});
        my $parentid = trim($hashCDS{$idx}{parent});
        if(length($newid)>0){
            $newid = $newid .$ncds;
            $line =~ s/$id1/$newid/g; 
            $line =~ s/$idx/$parentid/g;
            print OUT $line;
        }   else {
            print OUT2 $line;
        }
        $ncds++;
    } elsif ($array[2] eq "five_prime_UTR") {
        my @id1 = split /:/, $id; 
        my $id1 = trim(@id1[0]) .":five_prime_utr";
        my $idx = trim(@id1[0]);
        my $newid = trim($hash5{$idx}{five});
        my $parentid = trim($hash5{$idx}{parent});

        if(length($newid)>0){
            $newid = $newid .$n5;
            $line =~ s/$id1/$newid/g; 
            $line =~ s/$idx/$parentid/g;
            print OUT $line;
        }   else {
            print OUT2 $line;
        }
        $n5++;
    } elsif ($array[2] eq "three_prime_UTR") {

        my @id1 = split /:/, $id; 
        my $id1 = trim(@id1[0]) .":three_prime_utr";
        my $idx = trim(@id1[0]);
        my $newid = trim($hash3{$idx}{three});
        my $parentid = trim($hash3{$idx}{parent});

        if(length($newid)>0){
            $newid = $newid .$n3;
            $line =~ s/$id1/$newid/g; 
            $line =~ s/$idx/$parentid/g;
            print OUT $line;
        }   else {
            print OUT2 $line;
        }
        $n3++;
    } else{
        # print $line;
        # print "ERROR!\n";
    }
}
         

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_; } ;

