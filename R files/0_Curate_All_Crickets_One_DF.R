library(tidyverse)
library(stringr)
library(moments)
source("R files/utils.R")

# This script is used to curate the data frame with each row
# representing a single cricket.
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
output_directory <- "filtering_angle_output"
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

source("R files/2_Functions.R")

# Create a new dataframe with the following columns:
# 1. Cricket Name from extract_name_from_filename()
# 2. Sex from extract_sex_from_filename()
# 3. Group from extract_group_from_filename()
# 4. Date from extract_date_from_filename()
# 5. Stimulus from extract_stim_from_filename()
# 6. Note from extract_note_from_filename()
# 7. Filename
# 8. Right_foot_centerline_dist mean
# 9. Right_foot_centerline_dist sd
# 10. Right_foot_centerline_dist Kurtosis
# 11. Right_foot_centerline_dist Skewness
# 12. Left_foot_centerline_dist mean
# 13. Left_foot_centerline_dist sd
# 14. Left_foot_centerline_dist Kurtosis
# 15. Left_foot_centerline_dist Skewness
crickets_df <- data.frame(
    Name = character(),
    Sex = character(),
    Group = character(),
    Date = POSIXct(),
    Stimulus = numeric(),
    Note = character(),
    Filename = character(),
    Right_foot_centerline_dist_mean = numeric(),
    Right_foot_centerline_dist_sd = numeric(),
    Right_foot_centerline_dist_Kurtosis = numeric(),
    Right_foot_centerline_dist_Skewness = numeric(),
    Left_foot_centerline_dist_mean = numeric(),
    Left_foot_centerline_dist_sd = numeric(),
    Left_foot_centerline_dist_Kurtosis = numeric(),
    Left_foot_centerline_dist_Skewness = numeric()
)

#' This function is used to curate the data frame with each row
#' representing a single cricket.
#'
#' @param df A data frame following the df format above. 
#' @param filename A string representing the filename of the data file.
#'
#' @return A data frame with the new row appended.
append_cricket <- function(df, filename) {
  source("R files/3_Reader.R")
  source("R files/4_Calculator_More_Angle.R")

  # Append the new row to the data frame
  df <- df %>%
    add_row(Name = extract_name_from_filename(filename), # Name
            Sex = extract_sex_from_filename(filename), # Sex
            Group = extract_group_from_filename(filename), # Group
            Date = as.POSIXct(extract_POSIXct_from_filename(filename)), # Date
            Stimulus = as.numeric(extract_stim_from_filename(filename)), # Stimulus
            Note = extract_note_from_filename(filename), # Note
            Filename = filename, # Filename
            Right_foot_centerline_dist_mean = mean(right_leg_center_dist), # Right_foot_centerline_dist mean
            Right_foot_centerline_dist_sd = sd(right_leg_center_dist), # Right_foot_centerline_dist sd
            Right_foot_centerline_dist_Kurtosis = kurtosis(right_leg_center_dist), # Right_foot_centerline_dist Kurtosis
            Right_foot_centerline_dist_Skewness = skewness(right_leg_center_dist), # Right_foot_centerline_dist Skewness
            Left_foot_centerline_dist_mean = mean(left_leg_center_dist), # Left_foot_centerline_dist mean
            Left_foot_centerline_dist_sd = sd(left_leg_center_dist), # Left_foot_centerline_dist sd
            Left_foot_centerline_dist_Kurtosis = kurtosis(left_leg_center_dist), # Left_foot_centerline_dist Kurtosis
            Left_foot_centerline_dist_Skewness = skewness(left_leg_center_dist) # Left_foot_centerline_dist Skewness
    )
  df
}

num_files <- 1
minimum_sound <- 0
maximum_sound <- 90

for (file_name in file_list) {
  crickets_df <- append_cricket(crickets_df, file_name)
}

# Write the data frame to a csv file
write.csv(crickets_df,
          file = paste0(output_directory, "/crickets_df.csv"),
          row.names = FALSE)
