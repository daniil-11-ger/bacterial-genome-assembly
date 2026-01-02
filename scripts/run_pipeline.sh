#!/bin/bash

# Project Parameters
ACCESSION="SRR35523993"
THREADS=20
MEMORY=180
REFERENCE_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/021/125/GCF_000021125.1_ASM2112v1/GCF_000021125.1_ASM2112v1_genomic.fna.gz"

# 1. Directory Setup
mkdir -p BACTERIA_ASSEMBLY_NEW
cd BACTERIA_ASSEMBLY_NEW

# 2. Download SRA Reads
fasterq-dump --split-files $ACCESSION

# 3. Quality Control & Trimming (fastp)
# -q 20: base quality >= 20; -u 30: max 30% unqualified bases; -l 50: min length 50bp
conda activate fastp
fastp -i ${ACCESSION}_1.fastq -I ${ACCESSION}_2.fastq \
      -o ${ACCESSION}_1.trimmed.fastq -O ${ACCESSION}_2.trimmed.fastq \
      -q 20 -u 30 -l 50 -w 10 -f 10 -t 10
conda deactivate

# 4. Genome Assembly (SPAdes)
# --careful mode minimizes mismatches and short indels
conda activate spades
spades.py -1 ${ACCESSION}_1.trimmed.fastq -2 ${ACCESSION}_2.trimmed.fastq \
          -o spades_output --careful -t $THREADS -m $MEMORY
conda deactivate

# 5. Assembly Evaluation (QUAST)
cp spades_output/contigs.fasta .
conda activate quast
quast.py -o quast_results -t $THREADS contigs.fasta
conda deactivate

# 6. Reference Preparation
wget $REFERENCE_URL
gunzip -c $(basename $REFERENCE_URL) > reference.fna
# Split multi-FASTA into single entries using seqret
seqret -ossingle reference.fna

# 7. Reference-based Scaffolding (RagTag)
conda activate ragtag
# Using a specific reference chromosome (e.g., nc_011353.1.fasta)
ragtag.py scaffold nc_011353.1.fasta contigs.fasta -t $THREADS -o ragtag_output
cp ragtag_output/ragtag.scaffold.fasta our_bacteria_genome_assembly.fasta
conda deactivate

# 8. Biological Completeness Check (BUSCO)
conda activate busco
busco -c $THREADS -i our_bacteria_genome_assembly.fasta -o assembly_busco \
      -m genome -l enterobacterales_odb12
conda deactivate

# 9. Functional Annotation (Prokka)
conda activate prokka
prokka -outdir prokka_out --prefix ecoli --cpus $THREADS our_bacteria_genome_assembly.fasta
conda deactivate
