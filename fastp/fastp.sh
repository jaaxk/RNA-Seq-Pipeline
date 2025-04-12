#!/bin/bash

for fq1 in ../fastq/*_1.fastq; do
    fq2=${fq1/_1.fastq/_2.fastq}
    filename=$(basename "$fq1")          # -> someprefix_sample_1.fastq
    filename_no_ext=${filename%%_1.fastq} # -> someprefix_sample
    base=${filename_no_ext##*_} 
    echo $fq1 $fq2
    fastp -i "$fq1" -I "$fq2" \
          -o "$base"_1.fastq \
          -O "$base"_2.fastq
done
