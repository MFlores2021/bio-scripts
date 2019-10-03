#! bash
####### genPFiles
##
## Script to create pf files and elements file for Citrus Cyc
## It is using interproscan results and GOterms (replace obsolets)
##
## Usage: genPFiles.sh crop gfffile blastfile ecfile annotationsfile gostoreplace
##
## To see details for each input file
## https://docs.google.com/presentation/d/11vbeAHk0Dn9jLqfrtTDd1mCeWMLtP1q5UTC41l2WItI/edit#slide=id.g131faab02f_0_394
#################

crop=$1
gfffile=$2
blastfile=$3
ecfile=$4
annot=$5
trentry=$6
swissentry=$7
scaffoldpattern=$8

# gotoreplace=$6

### to get inf del gff

awk -F'\t' '{
#	split($1, scaf1, "|");
 	split($9, des, ";");
	split($9, id, "prot_id:");
	split($9, gene, "Parent=");
	split(gene[2], gen, ";" );
	gsub("Info=","",des[4]);
	gsub("ID=","",des[1]);
	if ($3 == "mRNA"){ print $1 "\t" des[1] "\t" gen[1] "\t" $4 "\t" $5 "\t" des[7]; }
}' $gfffile  >$crop.gff.list1

sort -k1,1 $crop.gff.list1 >$crop.gff.list
rm $crop.gff.list1 

# #### GO list

awk -F'\t' '{
	if (length($14) > 0){  print $1 "\t" $14 ; }
}' $annot | sort -k1,1 | uniq  >$annot.list

# #order blast  and filter the best score

awk -F'\t' '{
	 	if ($4 > 00){ 
		if ($3 > 50){ print $0; } }
}' $blastfile | sort -k1,1 -k12,12gr > $crop.blast.list1

awk '!seen[$1,$2]++'  $crop.blast.list1 > $crop.blast.list

rm $crop.blast.list1

perl scripts/exons2introns.pl $gfffile  >$crop.intron.gff

perl scripts/preproc.pl $crop $ecfile $annot.list

mkdir scaf

awk '!seen[$1]++' $crop.pre.out > $crop.pre.out1

awk -F'\t' '{
 		print >> $16; close($16)
 }' $crop.pre.out1


mv $scaffoldpattern* scaf/

perl scripts/writefiles.pl $crop $crop.pre.out1 $ecfile $annot.list $trentry $swissentry


files="scaf/*.pf"
for f in $files
do
  sed '/^$/d' $f > $f.tmp
  mv  $f.tmp $f
done




