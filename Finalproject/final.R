library(tidyverse) # Set folder where your kraken reports are saved
report_dir <- "C:/Users/muhta/OneDrive/Documents/GitHub/PLPA-6820/Finalproject"
# Change if needed
files <- list.files(report_dir, pattern = "_kraken_report.txt$", full.names = TRUE)

# Function to process one file
extract_species_presence <- function(filepath) {
  # Extract sample ID and assign sex label
  sample_id <- tools::file_path_sans_ext(basename(filepath)) %>%
    str_replace("_unmapped_kraken_report", "")
  sex <- ifelse(str_starts(sample_id, "F"), "female", "male")
  sample_name <- paste0(sex, "_", sample_id)
  
  # Read the kraken report
  df <- read_tsv(filepath, col_names = FALSE, col_types = cols(.default = "c"), quote = "", trim_ws = FALSE)
  colnames(df) <- c("percent", "reads", "direct", "rank", "taxid", "name")
  
  # Convert numeric columns
  df <- df %>%
    mutate(reads = as.numeric(reads),
           name = str_trim(name))
  
  # Filter to species (rank "S") with reads > 0
  species_df <- df %>%
    filter(rank == "F", reads > 0) %>%
    mutate(present = 1) %>%
    select(name, present)
  
  # Turn into row for the sample
  presence_vector <- deframe(species_df)
  tibble(Sample = sample_name, !!!set_names(presence_vector, names(presence_vector)))
}

# Apply to all files and combine
presence_list <- lapply(files, extract_species_presence)
presence_matrix <- reduce(presence_list, full_join, by = "Sample") %>%
  replace(is.na(.), 0)

# Save matrix to CSV
write_csv(presence_matrix, "C:/Users/muhta/Downloads/presence_absence_matrix.csv")

# Message
cat("✅ Presence-absence matrix saved to 'presence_absence_matrix.csv'\n")
library(readr)
library(tidyverse)

# Load the data
presence_matrix <- read_csv("C:/Users/muhta/OneDrive/Documents/GitHub/PLPA-6820/Finalproject/presence_absence_matrix.csv")

# Extract simplified sample name (e.g., Female01, Male02)
presence_matrix <- presence_matrix %>%
  mutate(Group = case_when(
    str_detect(Sample, "^female") ~ "Female",
    str_detect(Sample, "^male") ~ "Male",
    TRUE ~ "Unknown"
  ),
  ID = str_extract(Sample, "F_\\d+|M_\\d+"),
  SampleSimple = paste0(Group, str_extract(ID, "\\d+")))

# Aggregate by SampleSimple: if any run had presence (1), result = 1
presence_aggregated <- presence_matrix %>%
  select(-Sample, -Group, -ID) %>%
  group_by(SampleSimple) %>%
  summarise(across(everything(), ~ as.numeric(any(. == 1)))) %>%
  ungroup()

# Check output
head(presence_aggregated)

# Save aggregated matrix
write_csv(presence_aggregated, "C:/Users/muhta/OneDrive/Documents/GitHub/PLPA-6820/Finalproject/presence_absence_matrix_aggregated.csv")
presence_aggregated %>%
  rowwise() %>%
  mutate(Richness = sum(c_across(where(is.numeric)))) %>%
  ggplot(aes(x = SampleSimple, y = Richness, fill = str_extract(SampleSimple, "Female|Male"))) +
  geom_col() +
  labs(title = "Species Richness per Sample (Aggregated)",
       x = "Sample", y = "Number of Species") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10))

library(ggpubr)

# Extract richness
richness_df <- presence_matrix %>%
  rowwise() %>%
  mutate(Richness = sum(c_across(-Sample))) %>%
  mutate(Group = str_extract(Sample, "Female|Male"))

# Generate the boxplot
richness_plot <- ggboxplot(richness_df,
                           x = "Group", y = "Richness",
                           color = "Group", palette = "jco") +
  stat_compare_means(method = "t.test") +
  labs(title = "Species Richness by Sex")

# Print the plot
print(richness_plot)

# Save to file
ggsave("C:/Users/muhta/OneDrive/Documents/GitHub/PLPA-6820/Finalproject/figures/richness_boxplot_ttest.png",
       plot = richness_plot, width = 6, height = 4, dpi = 300)


#heatmap
# Load required packages
install.packages("pheatmap")

library(tidyverse)
library(pheatmap)

# Load the matrix again (if needed)
presence_matrix <- read_csv("C:/Users/muhta/OneDrive/Documents/GitHub/PLPA-6820/Finalproject/presence_absence_matrix.csv")

# Clean sample names
presence_matrix <- presence_matrix %>%
  mutate(Sample = str_extract(Sample, "female_F_\\d+|male_M_\\d+"),
         Sample = str_replace_all(Sample, "female_F_(\\d+)", "Female\\1"),
         Sample = str_replace_all(Sample, "male_M_(\\d+)", "Male\\1"))

# Generate unique sample names
presence_matrix <- presence_matrix %>%
  mutate(Sample = make.unique(Sample))

# Set 'Sample' as row names and convert to matrix
heatmap_matrix <- presence_matrix %>%
  column_to_rownames("Sample") %>%
  as.matrix()

# Create the heatmap
library(pheatmap)
pheatmap(heatmap_matrix,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = TRUE,
         show_colnames = FALSE,
         main = "Presence-Absence Heatmap",
         color = c("white", "black"))