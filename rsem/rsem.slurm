#!/bin/bash
#SBATCH --partition=long-96core
#SBATCH --time=48:00:00
#SBATCH --mem=250G
#SBATCH --output=res.txt
#SBATCH --cpus-per-task=96

conda activate bioinfo

fastq_dir=../fastp
genome_dir=/gpfs/scratch/jvaska/BMI511/genome/rsem_star_hg38_STAR/hg38

for read1 in "$fastq_dir"/*_1.fastq; do
  sample_name=$(basename "$read1" _1.fastq)
  echo "Processing: $sample_name"
  read2="$fastq_dir/${sample_name}_2.fastq"
  basename=$(basename "$read1" _1.fastq)
  accession=${basename%%_*}

  # Skip if output already exists
  if ls . | grep -q "$accession"; then
    echo "Skipping $accession – output already exists."
    continue
  fi

  if [[ -f "$read2" ]]; then
    rsem-calculate-expression --star --paired-end "$read1" "$read2" "$genome_dir" "$accession" -p 96
  else
    echo "Warning: No paired-end file found for $sample_name"
  fi
done

