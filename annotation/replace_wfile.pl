
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
my $file=$ARGV[1];
 
open OUT, ">$gff.renamed.gff" or die;
open OUT2, ">$gff.renamed_not.gff" or die;


### To get Function
my %hash;


open FILE3, "$file" or die;

while (my $line3=<FILE3>) {   

    (my $new,my $old) = split /\t/, $line3;  
    
    if (length(trim($new)) > 0){
	   	$hash{trim($old)} = trim($new);
	}
}

#print Dumper \%hash;

open FILE, "$gff" or die;

my @array = [];
while (my $line=<FILE>) {
    ## if we find a header line ...
    @array = split /\t/, $line; 
    (my $id, my $second, my $name) = split /\;/, $array[8];
        $id =~ s/ID=mRNA://g; 
        $name =~ s/Name=//g; 

    if ($array[2] eq "mRNA") {
        my $newid = $hash{trim($name)};
        if(length($newid)>0){
            # print $array[8] . "\t";
            $line =~ s/$name/$newid/g;
            print OUT $line;
        }   else {
            print OUT $line;
        }
    } else{
        # print $line;
       print OUT $line;
    }
}
         

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_; } ;

