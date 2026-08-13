# MobiDL alignmentSR

**WDL workflow for short-read alignment in capture-based panel sequencing.**

---

## 📌 Overview

WDL workflow for short-read alignment in capture-based panel sequencing.
It is designed to be modular, reproducible, and optimized for use in clinical settings.

---

## 🛠️ Requirements

### Software Dependencies

- [WDL](https://openwdl.org/) (Workflow Description Language)
- [Cromwell](https://cromwell.readthedocs.io/) (Workflow Execution Engine)
- [Apptainer](https://apptainer.org/) (for containerized tools)

### Apptainer images

This workflow is designed to be used on HPC cluster with apptainer images.
You could install images from this repo : https://github.com/MobiDL/apptainer-recipes

### Inputs

- **FastQ files** (paired-end)
- **Reference genome** (e.g., GRCh38)
- **Target regions** (BED file for panel definition)

---

## 🚀 Quick Start

⚠️ For maximum compatibility across Cromwell and cluster backends, all input and output paths must be absolute paths.

### 1. Clone the Repository

```bash
git clone --recursive https://github.com/MobiDL/alignmentSR.git
cd alignmentSR
```
### 2. Backend Configuration

Before running the workflow, adapt the backend configuration to match your HPC environment.

Common parameters to review include:
- `queue`
- `tmp_dir`
- `root_dir`
- `temporary-directory`
- `root`

These parameters are usually cluster-specific and may need to be adjusted depending on your scheduler and storage architecture.

### 3. Run the Test Dataset

A minimal test dataset is available in the `tests` directory.

Update the paths in `tests/test.json`, then run:

```bash
java cromwell run alignmentSR.wdl \
  -Dconfig.file=backends.conf/slurm_apptainer.conf \
  -i tests/test.json
```

### 3. Configure Inputs

Edit the `inputs.json` file to specify your input files and parameters:

```json
{
	"alignmentSR.sample": "SampleName",
	"alignmentSR.fasta": "/path/to/my/genomes/GRCh38/GRCh38.fa",
	"alignmentSR.fastq_R1": "/path/to/my/fastq_R1.fastq.gz",
	"alignmentSR.fastq_R2": "/path/to/my/fastq_R2.fastq.gz",
	"alignmentSR.knownSites": [
		"/path/to/my/knownsites_1.vcf.gz",
		"/path/to/my/knownsites_2.vcf.gz"
	],
	"alignmentSR.bed": "/path/to/my/intervals.bed",
	"alignmentSR.outputPath": "/path/to/my/output"
}
```

### 4. Run the Workflow

```bash
java cromwell run alignmentSR.wdl -Dconfig.file=backends.conf/slurm_apptainer.conf -i inputs.json
```

---

## 📂 Repository Structure

```
alignmentSR/
├── backends.conf/           # Backends sub-repository
├── modules/                 # Modules sub-repository
├── tests/                   # tests directory containing minimal dataset
├── alignmentSR.wdl          # Main workflow file
├── inputs.json              # Example input configuration
└── README.md                # This file
```

---

## ⚙️ Workflow Steps

<img height="840" alt="alignment" src="https://github.com/user-attachments/assets/bab19cc9-1557-44f8-9441-07cf540195e4" />


---

## 📊 Outputs

- **BAM files**: Aligned and processed reads.
- **QC Reports**: FastQC, MultiQC, and alignment metrics.
- **Logs**: Execution logs for debugging.

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

---

## 🆘 Support

For any questions or issues, please open an issue in this repository or contact us.
