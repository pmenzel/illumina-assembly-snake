from glob import glob
import pandas as pd
shell.executable("/bin/bash")

wildcard_constraints:
  sample = "[^_]+",
  assembly = "[^_]+",
  sample_assembly = "[^/]+",
	num = "[0-9]"

def get_R1_fq(wildcards):
	return glob('fastq/' + wildcards.sample + '_R1.fastq*')
def get_R2_fq(wildcards):
	return glob('fastq/' + wildcards.sample + '_R2.fastq*')

sample_assemblies, = glob_wildcards("assemblies/{sample_assembly,[^/]+}/")
#ignore symlinks in assemblies/folder, e.g. sample_flye.fa -> assemblies/sample_flye/output.fa
sample_assemblies = [a for a in sample_assemblies if not re.search('\.fa', a)]

list_outputs = expand("assemblies/{sample_assembly}/output.fa", sample_assembly = sample_assemblies)
list_outputs_links = expand("assemblies/{sample_assembly}.fa", sample_assembly = sample_assemblies)

rule all:
	input:
		list_outputs,
		list_outputs_links

rule shovill:
	threads: 5
	input:
		fq1 = get_R1_fq,
		fq2 = get_R2_fq
	output:
		fa = "assemblies/{sample}_shovill/output.fa",
		link = "assemblies/{sample}_shovill.fa",
		tmp_dir = temp(directory("assemblies/{sample}_shovill/tmp"))
	log: "log/{sample}_shovill_log.txt"
	shell:
		"""
		shovill --force --R1 {input.fq1} --R2 {input.fq2} --ram 50 --cpus {threads} --outdir {output.tmp_dir} >{log} 2>&1
		cp {output.tmp_dir}/contigs.fa {output.fa}
		ln -sr {output.fa} {output.link}
		"""

rule spades:
	threads: 5
	input:
		fq1 = get_R1_fq,
		fq2 = get_R2_fq
	output:
		fa = "assemblies/{sample}_spades/output.fa",
		link = "assemblies/{sample}_spades.fa",
		tmp_dir = temp(directory("assemblies/{sample}_spades_tmp"))
	log: "log/{sample}_spades_log.txt"
	params:
		dir = lambda wildcards : "assemblies/" + wildcards.sample + "_spades"
	shell:
		"""
		spades.py --isolate -1 {input.fq1} -2 {input.fq2} --threads {threads} --memory 96 --tmp-dir {output.tmp_dir} -o {params.dir} >{log} 3>&1
		cp {params.dir}/contigs.fasta {output.fa}
		ln -sr {output.fa} {output.link}
		"""

