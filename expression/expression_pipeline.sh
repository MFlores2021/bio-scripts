# By Mirella Flores

~/tools/hisat2-2.1.0/hisat2 -p 60 -x /home/mrf252/db/Diaci2.0/Diaci_v2.0.ref  --max-intronlen 200000 --rna-strandness RF --dta -1 SRR3239671_1.fastq -2 SRR3239671_2.fastq  -S SRR3239671.sam

samtools  sort -o SRR3239671.bam SRR3239671.sam


~/tools/stringtie-1.3.4c.Linux_x86_64/stringtie -p 60 -G ~/CG/RNAseqData/Dcitr_OGSv2.0.gff3 -e -B  -o wb/transcripts.gtf -A wb/gene_abundances.tsv SRR3239671.bam 

~/tools/scripts/stringtie_expression_matrix.pl --expression_metric=TPM --result_dirs=‘wb’ --transcript_matrix_file=transcript_tpm_wb.tsv --gene_matrix_file=gene_tpm_wb.tsv

awk '{ printf "%s\t%.2f\n",$1,$9}' wb/gene_abundances.tsv | awk '{ print $1"\tAdult\tCitrus_spp._CLas-_Female_Whole_body\t"$2"\t0.0\t"$2","$2","$2}' | awk '{ sub(/\.1$/, "", $1) }1' OFS="\t" >adultClas-FWB.tab


