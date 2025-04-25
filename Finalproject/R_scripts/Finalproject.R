# Load required packages
library(tidyverse)
library(readr)
library(pheatmap)
library(tibble)
library(ggpubr)
# Set folder with Kraken report files
report_dir <- "Kraken_reports"
files <- list.files(report_dir, pattern = "_kraken_report.txt$", full.names = TRUE)

# Function to extract presence from each report
extract_species_presence <- function(filepath) {
  # Get sample ID like F_01 or M_01 from filename
  filename <- tools::file_path_sans_ext(basename(filepath))
  sample_raw <- str_extract(filename, "^[FM]_\\d{2}")
  group <- ifelse(str_starts(sample_raw, "F"), "Female", "Male")
  sample_name <- paste0(group, str_extract(sample_raw, "\\d+"))
  
  # Read Kraken report
  df <- read_tsv(filepath, col_names = FALSE, col_types = cols(.default = "c"), quote = "", trim_ws = FALSE)
  colnames(df) <- c("percent", "reads", "direct", "rank", "taxid", "name")
  
  df <- df %>%
    mutate(reads = as.numeric(reads),
           name = str_trim(name))
  
  # Include both genus and species
  taxa_df <- df %>%
    filter(rank %in% c("G", "S"), reads > 0) %>%
    mutate(present = 1) %>%
    select(name, present)
  
  # Convert to single-row tibble
  presence_vector <- deframe(taxa_df)
  tibble(Sample = sample_name, !!!set_names(presence_vector, names(presence_vector)))
}

#  Apply function to all files
presence_list <- lapply(files, extract_species_presence)
presence_matrix <- reduce(presence_list, full_join, by = "Sample") %>%
  replace(is.na(.), 0)

# Save raw matrix
write_csv(presence_matrix, file.path(report_dir, "presence_absence_matrix.csv"))
cat("Saved full presence/absence matrix.\n")

#  Aggregate runs by sample (e.g., Female01)
presence_aggregated <- presence_matrix %>%
  group_by(Sample) %>%
  summarise(across(where(is.numeric), ~ as.numeric(any(. == 1)))) %>%
  ungroup()

# Add sex group and richness
presence_aggregated <- presence_aggregated %>%
  mutate(Group = str_extract(Sample, "Female|Male"),
         Richness = rowSums(across(where(is.numeric))))

# Save aggregated matrix
write_csv(presence_aggregated, file.path(report_dir, "presence_absence_matrix_aggregated.csv"))
cat("Saved aggregated matrix.\n")

# Plot richness
# Colorblind-friendly palette
cb_palette <- c("Female" = "#E69F00", "Male" = "#56B4E9")

# Updated plot
richness_plot <- ggplot(presence_aggregated, aes(x = Sample, y = Richness, fill = Group)) +
  geom_col() +
  scale_fill_manual(values = cb_palette) +
  labs(title = "Species & Genus Richness per Sample",
       x = "Sample", y = "Number of Taxa") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10))

# Save plot
ggsave("figure/richness_plot_aggregated.png",
       plot = richness_plot, width = 8, height = 4, dpi = 300)

# Draw the plot
print(richness_plot)
# Set path to save the PDF
pdf("figures/richness_plot_aggregated.pdf",
    width = 8, height = 4)

# Close the PDF device
dev.off()

cat("PDF saved successfully.\n")

#t-test
library(ggpubr)

# Build the richness boxplot with t-test
richness_boxplot <- ggboxplot(
  presence_aggregated,
  x = "Group",
  y = "Richness",
  fill = "Group",
  color = "black",
  palette = c("Female" = "#E69F00", "Male" = "#56B4E9") 
) +
  stat_compare_means(
    method = "t.test",
    label.y = max(presence_aggregated$Richness) * 1.05  # position above max value
  ) +
  labs(
    title = "Richness Comparison by Sex",
    x = "Group",
    y = "Number of Taxa"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12),
    legend.title = element_text(size = 11),
    legend.text = element_text(size = 10)
  )

print(richness_boxplot)
pdf("figures/richness_boxplot_final.pdf",
    width = 6, height = 4)
print(richness_boxplot)
dev.off()
ggsave("figures/richness_boxplot_final.png",
       plot = richness_boxplot, width = 6, height = 4, dpi = 300)
