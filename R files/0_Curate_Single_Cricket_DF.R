library(tidyverse)
library(stringr)
library(moments)

# Convert raw DLC data for one crickets into a single data frame
# containing secondary parameters like foot centerline distance.
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
output_directory <- "single_cricket_processed_data"
setwd(primary_directory)

if (!file.exists(output_directory)) {
  # Create the output directory
  dir.create(output_directory, recursive = TRUE)  # recursive means if the parent dir doesn't exist, it will proceed to create. 
  cat("Output directory created successfully!\n")
} else {
  cat("Output directory already exists.\n")
}
file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
cat("# of .csv files found: ", length(file_list), "\n")

file_name <- file_list[1] # for first stage I'm just going to do one file
maximum_sound <- 90 # in decibels
minimum_sound <- 0 # in decibels

# Read in the data
source("R files/utils.R")
source("R files/2_Functions.R")
for (file_name in file_list) {
  source("R files/3_Reader.R")
  source("R files/4_Calculator_More_Angle.R")

  # Create a new dataframe with the following columns:
  # 1. Frame number
  # 2. Body Angle (wax-abdomen)
  # 3. Right_foot_centerline_dist (in pixels)
  # 4. Left_foot_centerline_dist (in pixels)
  df <- data.frame(
  Frame = frame_col,
  Body_Angle = angles,
  Right_foot_centerline_dist = right_leg_center_dist,
  Left_foot_centerline_dist = left_leg_center_dist
  )

  # output the data frame to a csv file
  write.csv(df,
  file = paste0(output_directory, "/", convert_to_title(file_name), ".csv"),
  row.names = FALSE)
}