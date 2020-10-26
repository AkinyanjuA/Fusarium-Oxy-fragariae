# Pilon is a software tool which can be used to:
# Automatically improve draft assemblies and find variation among strains, including large event detection
# RUN IN A SCREEN
# srun --partition long --time 0-06:00:00 --mem 40G --cpus-per-task 24 --pty bash (long was full)
srun --partition short --time 0-03:00:00 --mem 20G --cpus-per-task 24 --pty bash
# First install pilon into conda env (I used olc_assemblers env)
# conda install -c bioconda pilon

# activate conda env
# conda activate olc_assemblers env

# Default usage
# Usage: pilon --genome genome.fasta [--frags frags.bam] [--jumps jumps.bam] [--unpaired unpaired.bam]

# Step 0: Index your assembled genome (do for each assembly)
bwa index assembly/SMARTdenovo/F.oxysporum_fsp_lactucae/race_1/racon_10/medaka/race_1_smartdenovo_racon_round_10_renamed.fasta

# Step 1: Map your reads (PacBio or Oxford Nanopore) back to your (consensus) assembly using BWA. This will create a mapping file in SAM format
# v1 bwa mem –t 2 –x ont2d -p assembly/SMARTdenovo/F.oxysporum_fsp_lactucae/race_1/racon_10/medaka/race_1_smartdenovo_racon_round_10_renamed.fasta assembly/flye/F.oxysporum_fsp_lactucae/race_1/FAL_trim.fastq.gz > bwa_mapping_SDen.sam
# v2 bwa mem -t 4 -p race_1_smartdenovo_racon_round_10_renamed.fasta FAL_trim.fastq.gz >bwa_mapping_SDen.sam (worked)
bwa mem -t 4 -p race_1_smartdenovo_racon_round_10_renamed.fasta FAL_trim.fastq.gz >bwa_mapping_SDen.sam

# Step 2: Convert your SAM file to the binary BAM format using samtools
samtools view -Sb bwa_mapping_SDen.sam > bwa_mapping_SDen.bam

# Step 3:Sort and index the BAM file for faster access using samtools
samtools sort –o bwa_mapping.SDEN.sorted.bam bwa_mapping_SDen.bam
samtools index bwa_mapping.SDEN.sorted.bam

# Step 4: Run Pilon using the genome assembly and the sorted and indexed bam file
pilon --genome race_1_smartdenovo_racon_round_10_renamed.fasta \
--bam bwa_mapping.SDEN.sorted.bam --threads 2