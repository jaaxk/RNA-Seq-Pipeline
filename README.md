# RNA-Seq pipeline using RSEM for isoform-level expression quantification

## Requirements
A conda environment with the following was used to run this pipeline:
1. FastQC v0.12.1
2. Fastp v0.24.0
3. STAR v2.7.10b
4. RSEM v1.2.28
5. Python 3.13.2

Also needed:
1. [SRA toolkit](https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit) v3.2.1 (independent from conda)
2. STAR and RSEM indices, this is explained in the `my_rnaseq_pipe.sh` file

## Running
The `my_rnaseq_pipe.sh` script downloads an example RNA-Seq dataset from the study [GSE2102491](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE210249) and runs the following:
1. Quality assessment with FastQC and MultiQC
2. Quality control and adapter trimming with Fastp
3. Alignment with STAR
4. Isoform counts with RSEM

These isoform counts can be used downstream with [DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) to find differential expression or other analyses
