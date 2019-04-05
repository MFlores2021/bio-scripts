
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

#use strict;
use Data::Dumper qw(Dumper);
use List::Util 'max';

#use warnings;

$input=$ARGV[0];
$list=$ARGV[1];
 
open OUT, ">$input.full_desc.fasta" or die;
open sOUT, ">$input.desc.fasta" or die;


### To get Function
my %hashdesc;
my %hashid;

open FILE3, "$list" or die;

while (my $line3=<FILE3>) {   
    # chomp;
    (my $prot,my $protid, my $desc) = split /\t/, $line3;  
    $desc =~ s/Note=//g;
    (my $sdesc) = split /\;/, $desc;  
      if (length(trim($protid)) > 0){
	$hashdesc{trim($protid)}{desc}   = trim($desc);
        $hashdesc{trim($protid)}{sdesc}   = trim($sdesc);
	$hashid{trim($prot)}   = trim($protid);
	}
}
#print Dumper \%hashdesc;

open ($sfh, "<$input");
my $j=0;
while (<$sfh>) {
    ## if we find a header line ...
    if (/^\>(.*)/) {
        chomp;
        ## write the previous sequence before continuing with this one
        unless ($first) {
			(my $id) = split /\ /, $header; 
            $id =~ s/mRNA://g;
      	    #print OUT ">" . $hashid{$id} . " ". $hashdesc{$hashid{$id}}{desc} ."\n";
            print OUT ">Trancript_" .$j . " ". $hashdesc{$hashid{$id}}{desc} ."\n";	    
	    print OUT  $seq;
            print sOUT ">" . $hashid{$id} . " ". $hashdesc{$hashid{$id}}{sdesc} ;
            print sOUT  "\n" . $seq;           
            ## reset the sequence
            $seq = '';
        }

        $first = 0;
        $header = $1;
	$j++;
    ## else we've found a sequence line
    } else {
        ## skip it if it is just whitespace
        next if (/^\s*$/);

        ## record this portion of the sequence
        $seq .= $_;
    }
}
          (my $id) = split /\ /, $header; 
          $id =~ s/mRNA://g;
	    print OUT ">Trancript_" .$j . " ". $hashdesc{$hashid{$id}}{desc} ."\n"; 
      	    #print OUT ">" . $id . " ". $hashdesc{$hashid{$id}}{desc} ;
	    print OUT  $seq;
            print sOUT ">" . $id . " ". $hashdesc{$hashid{$id}}{sdesc} ;
            print sOUT  "\n" . $seq;           

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_; } ;

