library(tidyverse)
library(MASS)
library(stringr)
source("R files/utils.R")

# 1_Master.R

formatted_time <- format(Sys.time(), "%Y-%m-%d-%H-%M")
output_description <- ""
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
output_directory <- paste0("graphs_output/", formatted_time, output_description)
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
setwd(primary_directory)

if (!file.exists(output_directory)) {
  # Create the output directory, recursive means if the parent dir does not
  # exist, it will proceed to create.
  dir.create(output_directory, recursive = TRUE)
  cat("Output directory created successfully!\n")
} else {
  cat("Output directory already exists.\n")
}

### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern = ".csv")
cat("# of .csv files found: ", length(file_list), "\n")
num_files <- 1

### STEP 2: Load in the necessary functions
source("R files/2_Functions.R")

pdf(paste0(output_directory, "/", "S12_M_stim01.pdf"), width = 8.5, height = 11)
par(mfrow = c(6, 1), mar = c(1, 1, 2, 0.5), oma = c(1, 1, 1, 1),
    cex.lab = 1, cex.axis = 1, cex.main = 1)

## This loop allows us to read every csv file in a directory
for (file_name in stripped_files) {
  print(convert_to_title(file_name))

  # STEP 3: Load in the data
  source("R files/3_Reader.R")

  # STEP 4: Perform the relevant calculations
  minimum_sound <- 0 # in dB, typically zero
  maximum_sound <- 90 # in dB, depends on experiment
  source("R files/4_Calculator.R")

  # STEP 5: Generate and save the cricket's graph
  source("R files/5_Grapher_Fixed_Anchor.R")

  num_files <- num_files + 1  # Thanks, R!
}
dev.off()

print(paste0(num_files, " files outputted sucessfully. "))