var=$1
echo $var"\n"

array=$(ls -d */ | sed 's/_[0-9]\///g' |sort | uniq)


for m in ${array}
do
echo ${m};
~/tools/scripts/stringtie_expression_matrix.pl --expression_metric=TPM --result_dirs=${m}'_1,'${m}'_2' --transcript_matrix_file=${m}_transcript_tpm_all_samples.tsv --gene_matrix_file=${m}_gene_tpm_all_samples_.tsv

awk '{ print $0"\t"($2+$3)/2 }' ${m}_gene_tpm_all_samples_.tsv >${m}_gene_tpm_all_samples.tsv

awk -v var=$var -v m=${m} 'NF>1{ s=0;s2=0;c=NF-1 ;
           for (i=2; i<=NF;i++) { s+=$i/c}
           for (i=2; i<=NF;i++) { s2+=($i-s)^2;}
           print $1"\t"m"\t"var"\t"s"\t"sqrt((s2)/(c-1))/sqrt(c)"\t"$2","$3","$4 ;}' ${m}_gene_tpm_all_samples.tsv  >${m}_gene_expression.txt
  echo "${m}"
done

