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

### Inputs

- **FastQ files** (paired-end)
- **Reference genome** (e.g., GRCh38)
- **Target regions** (BED file for panel definition)

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/MobiDL/alignmentSR.git
cd alignmentSR
```

### 2. Configure Inputs

Edit the `inputs.json` file to specify your input files and parameters:

```json
{
  "alignmentSR.reads": ["path/to/sample_R1.fastq.gz", "path/to/sample_R2.fastq.gz"],
  "alignmentSR.reference": "path/to/reference.fa",
  "alignmentSR.target_regions": "path/to/targets.bed"
}
```

### 3. Run the Workflow

```bash
cromwell run alignmentSR.wdl -i inputs.json
```

---

## 📂 Repository Structure

```
alignmentSR/
├── tasks/                   # Tasks sub-repository
├── alignmentSR.wdl          # Main workflow file
├── inputs.json              # Example input configuration
└── README.md                # This file
```

---

## ⚙️ Workflow Steps

<img width="820" height="1540" alt="alignment (1)" src="https://github.com/user-attachments/assets/9f723e17-9d2c-4171-a67f-7e1b1239bc1e" />


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

For questions or issues, please contact the Mobidic team or open an issue in this repository.
