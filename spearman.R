#exp_file = read.table("/home/mrf252/citrus/data/gene_tpm_all_samples.tsv",header=TRUE, sep = "\t")
exp_file= "/home/mrf252/citrus/data/gene_tpm_all_samples.tsv"
gene_corr <- function(exp_file, minexp=1) { 
  data<-read.delim(exp_file, header=TRUE) 
  rownames(data)<-data[,1] 
  data<-data[,-1] 
  gcorr<-cor(t(data[rowSums(data)>minexp,]), method="spearman") 
  out<-paste0(exp_file,".gcor.txt") 
  write.table(gcorr, file=out, sep="\t") 
}

gene_corr(exp_file, minexp=1)
