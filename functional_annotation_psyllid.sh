#!/bin/sh

# Functional annotation tomato
#Mirella Flores (BTI)

usage(){
   echo "usage:
   $0 <protein.fa> <prefix>"
   exit 1
}

if [ "$#" -ne 2 ]
then
   usage
fi

#Input protein fasta file
fasta=$1
base=$2

mkdir tmp
cp $fasta tmp/
cd tmp
sed -i 's/*//g' $fasta

# Split files to run it faster
perl ~/tools/bio-scripts/split_multifasta.pl --input_file $fasta --output_dir ./ --seqs_per_file=1000 

 for f in *; do mv $f part_$f; done

# Run Blastp

ls *.fsa | parallel -j 30 blastall -p blastp -i {} -o arap-{.}.tab -d ~/db/araport11/Araport11_genes.201606.pep.fasta -e 0.0001 -v 200 -b 200 -m 8 -a 3

ls *.fsa | parallel -j 30 blastall -p blastp -i {} -o swiss-{.}.tab -d ~/db/swiss/uniprot-plant_swissprot.fasta -e 0.0001 -v 200 -b 200 -m 8 -a 3

ls *.fsa | parallel -j 30 blastall -p blastp -i {} -o trembl-{.}.tab -d ~/db/trembl/uniprot-plant_trembl.fasta -e 0.0001 -v 200 -b 200 -m 8 -a 3


# Create template to run AHRD
end=$(ls -1q *.fsa | wc -l )
i=1
while [ $i -le $end ]
do
echo "proteins_fasta: $i.fsa
token_score_bit_score_weight: 0.6
token_score_database_score_weight: 0.4
token_score_overlap_score_weight: 0.0
output: ./ahrd_$base.$i.csv

blast_dbs: 
   araport11: 
      weight: 50
      description_score_bit_score_weight:  2.590211
      file: arap-$i.tab
      database: /home/mrf252/db/araport11/Araport11_genes.201606.pep.fasta
      blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_descline.txt
      token_blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_token.txt
      filter: /home/mrf252/tools/AHRD/test/resources/filter_descline_tair.txt
      fasta_header_regex: '^>(?<accession>.+?) (?<description>.+?)'
   swissprot: 
      weight: 40
      description_score_bit_score_weight: 2.717061
      file: swiss-$i.tab
      database: /home/mrf252/db/swiss/uniprot-plant_swissprot.fasta
      blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_descline.txt
      token_blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_token.txt
      filter: /home/mrf252/tools/AHRD/test/resources/filter_descline_sprot.txt
   trembl: 
      weight: 10
      description_score_bit_score_weight:  2.917405
      file: trembl-$i.tab 
      database: /home/mrf252/db/trembl/uniprot-plant_trembl.fasta 
      blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_descline.txt
      token_blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_token.txt
      filter: /home/mrf252/tools/AHRD/test/resources/filter_descline_trembl.txt
" >ahrd_$base.part$i.yml
i=$(( i+1 ))
done 

#Run AHRD

ls ahrd_*.yml | parallel -j 50 java -Xmx4g -jar ~/tools/AHRD/dist/ahrd.jar {} 



# InterproScan:

<<<<<<< HEAD
ls *.fsa | parallel -j 20 ~/tools/interproscan-5.32-71.0/interproscan.sh -t n -i {} -goterms -iprlookup -pa -f tsv -appl Pfam -dra >{}.log
=======
ls *.fsa | parallel -j 20 ~/tools/interproscan-5.32-71.0/interproscan.sh -t p -i {} -goterms -iprlookup -pa -f tsv -appl Pfam -dra >{}.log
>>>>>>> 73ceb59d7e9795a6ff177298abd1698dccab552d

cd ..
cat tmp/*csv >ahrd_$base.csv
cat tmp/*tsv >interpro_$base.tsv

mkdir tmp2
cd tmp2

grep "Unknown protein" ../ahrd_$base.csv | cut -f1 >$base.unknown.txt

perl ~/tools/scripts/subset_fasta.pl -i $base.unknown.txt < ../$fasta > $base.unknown.fa

perl ~/tools/bio-scripts/split_multifasta.pl --input_file $base.unknown.fa --output_dir ./ --seqs_per_file=500

ls *.fsa | parallel -j 30 blastall -p blastp -i {} -o nr-{.}.tab -d ~/db/nr/arthropoda/nr.arth.fa -e 0.0001 -v 200 -b 200 -m 8 -a 3


# Create template to run AHRD with nr
end=$(ls -1q *.fsa | wc -l )
i=1
while [ $i -le $end ]
do
echo "proteins_fasta: $i.fsa
token_score_bit_score_weight: 0.6
token_score_database_score_weight: 0.4
token_score_overlap_score_weight: 0.0
output: ./ahrdunknown_$base.$i.csv

blast_dbs: 
   nr: 
      weight: 50
      description_score_bit_score_weight:  2.590211
      file: nr-$i.tab
      database: /home/mrf252/db/nr/arthropoda/nr.arth.fa
      blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_descline.txt
      token_blacklist: /home/mrf252/tools/AHRD/test/resources/blacklist_token.txt
      filter: /home/mrf252/tools/AHRD/test/resources/filter_descline_tair.txt
      fasta_header_regex: '^>(?<accession>.+?) (?<description>.+?)'
" >ahrd_$base.part$i.yml
i=$(( i+1 ))
done

#Run AHRD unknown

ls ahrd_*.yml | parallel -j 50 java -Xmx4g -jar ~/tools/AHRD/dist/ahrd.jar {} 

cd ..
cat tmp2/*csv >ahrd_$base.unknown.csv

cat <(grep -v "Unknown protein" ahrd_$base.csv) ahrd_$base.unknown.csv | sort >ahrd_$base.final.csv 


