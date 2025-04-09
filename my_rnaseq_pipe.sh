#!/bin/bash

## download
prefetch --option-file SRR_Acc_List.txt

mkdir -p reads
cat SRR_Acc_List.txt | xargs -I {} fasterq-dump --split-files --progress -O reads {}

## fastqc
fastqc -o ./fastqc ./reads/*.fastq

## multiqc
conda activate bioinfo_python3.12 #some crazy dependency issues (multiqc needed python 3.12)

multiqc fastqc/ -o multiqc

## fastp
mkdir -p fastp
for f in reads/*_1.fastq; do
    base=$(basename "$f" _1.fastq)
    r1="reads/${base}_1.fastq"
    r2="reads/${base}_2.fastq"
    out1="fastp/${base}_1.fastq"
    out2="fastp/${base}_2.fastq"

    echo "Processing $base"
    fastp -i "$r1" -I "$r2" -o "$out1" -O "$out2" --thread 96
done

## alignment
conda activate bioinfo #back to bioinfo env

#need to build an index?
#STAR --runThreadN 20 --runMode genomeGenerate --genomeDir STAR_index --genomeFastaFiles GRCh38.primary_assembly.genome.fa --sjdbGTFfile gencode.v40.annotation.gtf

./align.slurm
#this is for uncompressed, add --readFilesCommand zcat if they are .gz's
#this script just loops through all pairs and runs STAR on each

## RSEM
cd rsem
./rsem/rsem.slurm

#rsem-calculate-expression --star --paired-end ../../fastq_files/SRR20736630_1.fastq ../../fastq_files/SRR20736630_2.fastq /gpfs/scratch/jvaska/BMI511/genome/rsem_star_hg38_STAR/hg38 SRR20736630


#First an RSEM reference needs to be created with STAR (or bowtie), this will make a NEW star index that has isoform information (necessary for RSEM), find this in genome/rsem_star_h938_STAR/generate_index.slurm
#Then the above command will ALIGN the reads to ISOFORMS (and genes?) using the NEW star index (so we really dont need to run STAR before this, these happen at the same time)
#The third argument has to be the path to the star-rsem index directory /<genome_name> with no extension, it will figure out how to find necessary files from this

