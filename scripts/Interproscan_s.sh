ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/Feature_annotation
  for Genes in $(ls gene_pred/codingquary/F.oxysporum_fsp_fragariae/DSA15_041/final/final_genes_appended_renamed.pep.fasta); do
    echo $Genes
    $ProgDir/interproscan.sh $Genes
  done 2>&1 | tee -a interproscan_submisison.log
