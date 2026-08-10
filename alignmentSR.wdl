version 1.0

import "modules/fastp.wdl" as fastp
import "modules/minibwa.wdl" as minibwa
import "modules/utilities.wdl" as utilities
import "modules/samtools.wdl" as samtools
import "modules/sambamba.wdl" as sambamba
import "modules/GATK4.wdl" as GATK4

workflow alignmentSR {
	meta {
		author: "Charles VAN GOETHEM"
		email: "c-vangoethem(at)chu-montpellier.fr"
		version: "0.0.1"
		date: "2026-08-10"
	}

	input {
		String sample

		## WARNING ALL PATH MUST BE ABSOLUTE PATH
		File fasta

		File fastq_R1
		File fastq_R2

		Array[File] knownSites

		File bed

		String? outputPath
	}

	Object Fasta = {
        "fasta" : fasta,
		"fasta_index": fasta + ".fai",
		"fasta_gz": fasta + ".gz",
		"fasta_index_gz": fasta + "gz.fai",
		"fasta_gzindex": fasta + "gz.gzi",
		"fasta_dict": sub(fasta, "(.*).(fa|fasta)", "$1.dict"),
		"fasta_amb": fasta + ".amb",
		"fasta_ann": fasta + ".ann",
		"fasta_bwt": fasta + ".bwt",
		"fasta_pac": fasta + ".pac",
		"fasta_sa": fasta + ".sa",
		"fasta_l2b": fasta + ".l2b",
		"fasta_mbw": fasta + ".mbw"
    }



	call fastp.fastp {
		input:
			sample = sample,
			threads = 12,
			outputPath = "~{outputPath}",
			fastqR1 = fastq_R1,
			fastqR2 = fastq_R2,
	}

	call minibwa.map {
		input:
			sample = sample,
			threads = 12,
			outputPath = "~{outputPath}",
			fastqR1 = fastp.FastpR1,
			fastqR2 = fastp.FastpR2,
			fasta = Fasta.fasta,
            fasta_l2b = Fasta.fasta_l2b
	}

	call samtools.sort {
		input:
			threads = 12,
			outputPath = "~{outputPath}",
			bam = map.sam
	}
	
	if (defined(sort.outputFile) && size(sort.outputFile) > 0) {
		call utilities.rm_files {
			input:
				files = [map.sam]
		}
	}

	call sambamba.markdup {
		input:
			threads = 12,
			outputPath = "~{outputPath}",
			bam = sort.outputFile
	}

	call GATK4.splitIntervals {
		input:
			threads = 12,
			outputPath = "~{outputPath}",
			bed = bed,
	 		refFasta = Fasta.fasta,
	 		scatterCount = 12
	}

 	call utilities.suffixArray {
 		input:
 			array = knownSites,
            suffix = ".tbi"
 	}

	scatter (interval in splitIntervals.splittedIntervals) {
		call GATK4.baseRecalibrator {
			input:
				threads = 12,
				outputPath = "~{outputPath}",
				bam =  markdup.outputBam,
    			bed = interval,
    			knownSites = zip(knownSites,suffixArray.array_suffix),
				refFasta = Fasta.fasta
		}
	}

	call GATK4.gatherBQSRReports {
		input:
			threads = 12,
			outputPath = "~{outputPath}",
			reports = baseRecalibrator.outputFile
	}

	call GATK4.applyBQSR {
		input:
			threads = 12,
			outputPath = "~{outputPath}",
			bam =  markdup.outputBam,
	 		refFasta = Fasta.fasta,
			bqsrReport = gatherBQSRReports.report
	}

	call GATK4.leftAlignIndels {
		input:
			threads = 12,
			outputPath = "~{outputPath}",
			bam = applyBQSR.outputBam,
	 		refFasta = Fasta.fasta
	}

	output {
		File bam = leftAlignIndels.outputBam
		File bai = leftAlignIndels.outputBai
	}
    
    parameter_meta {
		sample: {
			description: 'Sample name to use for output file name [default: sub(basename(fastqR1),subString,"")]',
			category: 'Output path/name option'
		}
		fasta: {
			description: 'Path to the reference file (format: fasta)',
			category: 'Required'
		}
		fastq_R1: {
			description: 'Input file with reads 1 (fastq, fastq.gz, fq, fq.gz).',
			category: 'Input'
		}
		fastq_R2: {
			description: 'Input file with reads 2 (fastq, fastq.gz, fq, fq.gz).',
			category: 'Input'
		}
        knownSites: {
			description: 'One or more databases of known polymorphic sites used to exclude regions around known polymorphisms from analysis.',
			category: 'Input'
		}
        bed: {
			description: 'Path to a file containing genomic intervals over which to operate. (format: bed or GATK intervals list)',
			category: 'Input'
		}
        outputPath: {
			description: 'Output path where files will be generated. [default: pwd()]',
			category: 'Output path/name option'
		}
	}
}