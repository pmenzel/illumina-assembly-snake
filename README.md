# illumina-assembly-snake

A snakemake-wrapper for creating *de novo* bacterial genome assemblies from paired-end Illumina sequencing data.

Currently included programs:
* [shovill](https://github.com/fenderglass/Flye)
* [spades](https://github.com/lbcb-sci/raven)

## Quick start
```
# Install
git clone https://github.com/pmenzel/illumina-assembly-snake.git
conda config --add channels bioconda
conda env create -n illumina-assembly-snake --file illumina-assembly-snake/environment.yaml
source activate illumina-assembly-snake

# Prepare data
mkdir fastq
cp /data/my_sample/reads_R1.fastq.gz fastq/mysample_R1.fastq.gz
cp /data/my_sample/reads_R2.fastq.gz fastq/mysample_R2.fastq.gz

# Declare desired assemblies and run workflow
mkdir -p assemblies/mysample_shovill
mkdir -p assemblies/mysample_spades
snakemake -s illumina-assembly-snake/Snakefile --cores 10
```


## Installation
Clone repository, for example:
```
git clone https://github.com/pmenzel/illumina-assembly-snake.git /opt/software/illumina-assembly-snake
```
Install [conda](https://docs.conda.io/en/latest/miniconda.html) and then create a new environment containing all the programs:
```
conda config --add channels bioconda
conda env create -n illumina-assembly-snake --file /opt/software/illumina-assembly-snake/environment.yaml
```
and activate environment:
```
source activate illumina-assembly-snake
```

## Usage
First, prepare a folder called `fastq` containing the sequencing reads as
two fastq files per sample, called `samplename_R1.fastq.gz` and `samplename_R2.fastq.gz`.

Next, create a folder `assemblies` and inside create empty folders specifying
the desired assemblies.

Sample name and assembler name need to be separated by an underscore.
NB: This also means that sample names must not contain underscores.

### Example folder structure
This example contains two samples.

Sample 1 should be assembly with shovill, whereas sample2 should be assembly by both shovill and spades.
```
.
├── fastq
│   ├── sample1_R1.fastq.gz
│   ├── sample1_R2.fastq.gz
│   ├── sample2_R1.fastq.gz
│   └── sample2_R2.fastq.gz
│
└── assemblies
    ├── sample1_shovill
    ├── sample2_shovill
    └── sample2_spades
```


### Run workflow

Run workflow in that folder, e.g. with 10 threads:
```
snakemake -k -s /opt/software/illumina-assembly-snake/Snakefile --cores 10
```

The assemblies are contained in the files `output.fa` in each folder.

