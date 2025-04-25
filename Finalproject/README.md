# Final Microbiome Project Report: *Periplaneta americana*

**Author**: Muhtarin Khayer Brohee  
**Course**: PLPA-6820  
**Project Type**: Final Project — Reproducible Workflow  
**Date**: April 2025  

---

##  Project Overview

This project analyzes the gut microbiome composition of **male and female adult American cockroaches (*Periplaneta americana*)** using taxonomic profiles produced by **Kraken2**. The goal was to create a **reproducible workflow** that computes taxonomic richness, compares microbial diversity between sexes, and visualizes taxonomic abundance at the genus level.

---

##  Data & Software

- **Input**: Kraken2 report files (`*_kraken_report.txt`)
- **Sample Groups**: 10 samples (5 Female, 5 Male)
- **File format**: Tab-separated Kraken2 outputs (unfiltered)
- **Software Used**:
  - R (version ≥ 4.2)
  - RStudio
  - Git + GitHub
- **R Packages**:
  - `tidyverse`
  - `readr`
  - `ggpubr`
  - `pheatmap`
  - `tibble`
  - `knitr`, `rmarkdown`

---

##  Folder & File Structure
<pre> ``` Finalproject/ ├── Finalproject.Rproj ├── FinalMicrobiomeProject.Rmd ├── FinalMicrobiomeProject.docx ├── FinalMicrobiomeProject_files/ │ └── figure-docx/ ├── README.md ├── versioncontrolgit.png ├── R_scripts/ │ ├── Finalproject.R │ ├── FinalMicrobiomeProject.Rmd │ ├── heatmap.R ├── Kraken_reports/ │ ├── F_01_CKDN240013765-1A_HJMVHDSXC_L2_unmapped_kraken_report.txt │ ├── F_02_CKDN240013766-1A_HKM53DSXC_L4_unmapped_kraken_report.txt │ ├── F_03_CKDN240011250-1A_HHCT2DSXC_L2_unmapped_kraken_report.txt │ ├── F_04_CKDN240011251-1A_HKLVFDSXC_L2_unmapped_kraken_report.txt │ ├── F_05_CKDN240011252-1A_HHCT2DSXC_L2_unmapped_kraken_report.txt │ ├── M_01_CKDN240013767-1A_HJMVHDSXC_L2_unmapped_kraken_report.txt │ ├── M_02_CKDN240013763-1A_HKN7JDSXC_L3_unmapped_kraken_report.txt │ ├── M_03_CKDN240011255-1A_HHCT2DSXC_L3_unmapped_kraken_report.txt │ ├── M_04_CKDN240011256-1A_HHCT2DSXC_L3_unmapped_kraken_report.txt │ ├── M_05_CKDN240013764-1A_HJMVHDSXC_L2_unmapped_kraken_report.txt │ ├── genus_read_counts_matrix.csv │ ├── presence_absence_matrix.csv │ └── presence_absence_matrix_aggregated.csv ├── figures/ │ ├── richness_plot_aggregated.png │ ├── richness_plot_aggregated.pdf │ ├── richness_boxplot_final.png │ ├── richness_boxplot_final.pdf │ └── genus_readcount_heatmap_top100.pdf ``` </pre>
##  How to Run the Scripts

All R scripts used in this project are stored in the `R_scripts/` folder. Each script corresponds to a specific step in the microbiome analysis pipeline and can be run independently.

### Steps to Run

1. **Open the R Project**

   Start by opening the RStudio Project file:
   Finalproject.Rproj
   This ensures that all file paths are interpreted correctly as relative paths.

---

### 2. Navigate to the `R_scripts/` Folder

This folder contains the following key scripts:

 - `richness.R` 
  Generates a presence-absence matrix using Kraken2 reports (species + genus level).
  Calculates species richness and creates both barplots and a boxplot with t-test comparison between male and female samples.

- `heatmap.R`  
  Processes genus-level Kraken2 counts, applies log10 transformation, identifies the top 100 most abundant genera, and produces a heatmap.

---

### 3. Run Scripts in Order

Each script can be run individually in RStudio by opening the script and clicking **“Source”**, or by running it through the console using `source("R_scripts")`.

Run the scripts in the following order for a full workflow:

1. Generate the presence-absence matrix
2. Compute and visualize richness metrics
3. Generate the genus-level heatmap

---

### 4. Outputs

- CSV files (e.g., matrices) are saved in the root project folder
- Plot files (e.g., `.png`, `.pdf`) are saved in the `figures/` directory

The figures include:
- Barplot of species/genus richness per sample
- Boxplot comparing richness by sex
- Heatmap of the top 100 genera (log-transformed)

These outputs are manuscript-ready and reproducible from script execution.

---

###  Notes

- Ensure all required R packages are installed before running scripts
