# SCHOOL bacterial-genome-assembly
# Bacterial Genome Assembly Pipeline: SRR35523993

This project provides a complete, automated workflow for the assembly and annotation of the *Escherichia coli* genome (Accession: SRR35523993).

## Project Overview
The pipeline processes raw sequencing data through a series of bioinformatics tools to produce a high-quality, annotated genome. It includes quality control, de novo assembly, reference-based scaffolding, and functional annotation.

### Pipeline Stages:
* **Quality Control (fastp):** Filters low-quality reads (Q20) and trims adapters.
* **De novo Assembly (SPAdes):** Uses the `--careful` mode to ensure high-accuracy sequence reconstruction.
* **Scaffolding (RagTag):** Orders and orients contigs using a reference *E. coli* genome.
* **Biological Assessment (BUSCO):** Validates the completeness of the assembly based on Enterobacterales core genes.
* **Annotation (Prokka):** Identifies coding sequences (CDS), rRNA, and tRNA.

## Implementation
The main logic is contained in the `scripts/run_pipeline.sh` bash script.

### Analogy of the Process:
Think of this process as restoring a shredded historical book:
1. **Cleaning:** Throwing away illegible scraps (fastp).
2. **Assembling:** Gluing pieces together into paragraphs (SPAdes).
3. **Organizing:** Using another edition of the book to put paragraphs in the right order (RagTag).
4. **Verifying:** Checking the table of contents to ensure no chapters are missing (BUSCO).
5. **Labeling:** Adding titles to every chapter (Prokka).

## Results
*Here you can mention the results you saw in your logs:*
- **Completeness:** High BUSCO score confirmed.
- **Annotated Features:** Identified thousands of coding sequences.

---
*Developed for bioinformatics research and reproducibility.*
