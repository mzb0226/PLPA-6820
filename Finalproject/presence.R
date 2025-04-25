# Load packages
library(tidyverse) # Set folder where your kraken reports are saved
report_dir <- "C:/Users/muhta/Downloads"  # Change if needed
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
    filter(rank == "S", reads > 0) %>%
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
