# Load required libraries
library(tidyverse)
library(pheatmap)
library(tibble)

# Set report directory
report_dir <- "C:/Users/muhta/OneDrive/Documents/GitHub/PLPA-6820/Finalproject"
files <- list.files(report_dir, pattern = "_kraken_report.txt$", full.names = TRUE)

# Function to extract genus-level read counts with renamed samples
extract_genus_counts <- function(filepath) {
  full_name <- tools::file_path_sans_ext(basename(filepath))  # Full filename
  short_id <- str_extract(full_name, "F_\\d+|M_\\d+")          # e.g., F_01
  sample_name <- short_id %>%
    str_replace("F_", "Female") %>%
    str_replace("M_", "Male")
  
  df <- read_tsv(filepath, col_names = FALSE, col_types = cols(.default = "c"), quote = "", trim_ws = FALSE)
  colnames(df) <- c("percent", "reads", "direct", "rank", "taxid", "name")
  
  df %>%
    filter(rank == "G") %>%
    mutate(reads = as.numeric(reads),
           name = str_trim(name)) %>%
    group_by(name) %>%
    summarise(reads = sum(reads, na.rm = TRUE), .groups = "drop") %>%
    pivot_wider(names_from = name, values_from = reads, values_fill = 0) %>%
    mutate(Sample = sample_name)
}

# Process all Kraken reports
genus_read_list <- lapply(files, extract_genus_counts)

# Merge into full matrix
genus_read_matrix <- reduce(genus_read_list, full_join, by = "Sample") %>%
  replace(is.na(.), 0)

# Save full matrix as CSV
write_csv(genus_read_matrix, file.path(report_dir, "genus_read_counts_matrix.csv"))

# Load matrix, convert to log10, rename rows
genus_counts <- read_csv(file.path(report_dir, "genus_read_counts_matrix.csv")) %>%
  column_to_rownames("Sample")
genus_log <- log10(genus_counts + 1)

#  Top 100 most abundant genera
top_100 <- colSums(genus_log) %>%
  sort(decreasing = TRUE) %>%
  head(100) %>%
  names()
heatmap_data <- genus_log[, top_100]

#  Plot heatmap
pdf(file.path(report_dir, "figures/genus_readcount_heatmap_top100.pdf"), width = 18, height = 8)
pheatmap(
  heatmap_data,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  color = colorRampPalette(c("lightblue", "skyblue", "darkblue"))(100),
  fontsize_row = 10,
  fontsize_col = 6,
  angle_col = 90,
  main = "Heatmap of Top 100 Genera (log10-read counts)"
)
dev.off()

cat("Heatmap saved to: figures/genus_readcount_heatmap_top100.pdf\n")
