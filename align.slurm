#!/bin/bash
#SBATCH --partition=long-96core
#SBATCH --time=48:00:00
#SBATCH --mem=250G
#SBATCH --output=res.txt
#SBATCH --cpus-per-task=96

fastq_dir="../fastq_files"
genome_dir="/gpfs/scratch/jvaska/BMI511/genome/STAR_hg38"

# Loop through each paired-end FASTQ file
for read1 in $fastq_dir/*_1.fastq; do
  # Derive the sample name by removing the "_1.fastq.gz" part
  sample_name=$(basename $read1 _1.fastq)
  echo $read1
  # Define the corresponding second read (paired-end)
  read2="$fastq_dir/${sample_name}_2.fastq"

  # Check if the second read exists
  if [[ -f "$read2" ]]; then
    # Run STAR with the sample name as the prefix
    STAR --runThreadN 96 \
         --genomeDir $genome_dir \
         --readFilesIn $read1 $read2 \
         --outFileNamePrefix ./star/aligned_${sample_name}_ \
         --outSAMtype BAM SortedByCoordinate
  else
    echo "Warning: No paired-end file found for $sample_name"
  fi
done
