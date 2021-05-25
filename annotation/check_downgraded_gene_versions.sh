#!/usr/bin/env bash
# Author: Mirella Flores
# Description: It compares gene ids from one version to another and gets downgraded versions

old=$1
new=$2
grep -P "\tgene\t" $old | cut -f9 |sed 's/ID=gene.//g' |  cut -f1 -d ";"| sed 's/\./\t/g' | sort -k1,1 >$old.txt
grep -P "\tgene\t" $new | cut -f9 |sed 's/ID=gene.//g' |  cut -f1 -d ";"| sed 's/\./\t/g' | sort -k1,1 >$new.txt

join -1 1 -2 1 $old.txt $new.txt | awk '$2>$3 {print $0}' >wrong_genes.txt
