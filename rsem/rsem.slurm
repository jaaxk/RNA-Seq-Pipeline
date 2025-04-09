#!/bin/bash
#SBATCH --partition=long-96core
#SBATCH --time=48:00:00
#SBATCH --mem=250G
#SBATCH --output=res.txt
#SBATCH --cpus-per-task=96

conda activate bioinfo

rsem-calculate-expression --star --paired-end ../../fastq_files/SRR20736630_1.fastq ../../fastq_files/SRR20736630_2.fastq /gpfs/scratch/jvaska/BMI511/genome/rsem_star_hg38_STAR/hg38 SRR20736630
