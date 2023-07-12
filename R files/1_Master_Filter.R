library(tidyverse)
library(MASS)
library(stringr)
source("R files/utils.R")

# This script is used for the filtering process (see filtering_output/*)
# it screens out each individual based on the naming convention and the criteria
# and generate plot for each individual.
# To use this script, you need to change the following variables:
# 1. *_directory: the directory where you store/want to output all the files
# 2. filtering_criteria: the criteria you want to use to filter out the data
# 3. output_name: the name of the output file
# 4. filter_plot: the plot you want to generate for each individual
#
# Keep in mind that the output_name should be unique, otherwise it will
# overwrite the existing file. Also, this script current have filtering criteria
# overwritten by a list so I can generate all 8 groups in one run, if you want
# to use this script for other purposes, you need to change/delete that.

primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
output_directory <- "filtering_angle_output"
setwd(primary_directory)

if (!file.exists(output_directory)) {
  # Create the output directory
  # recursive means if the parent dir doesn't exist, it will proceed to create. 
  dir.create(output_directory, recursive = TRUE)
  cat("Output directory created successfully!\n")
} else {
  cat("Output directory already exists.\n")
}

# make sure to identify which directory
file_list <- list.files(path = input_directory, pattern = ".csv")
cat("# of .csv files found: ", length(file_list), "\n")
num_files <- 1

# Change this if you want to display different audio.
# REMEMBER to change the output name too!!!
filtering_criteria <- function() {
  # for S12 use !(info_vec[5] %in% c("S11","G","U"))
  (info_vec[6] == "M") && (info_vec[5] == "S11")
  # To filter out dates, use
  # (as.numeric(format(as.Date(info_vec[1]), "%m")) >= 6)  # nolint
  #   && (format(as.Date(info_vec[1]), "%Y") == 2021)
}
output_name <- "S11_stim01"  # don't add .pdf here.

# Change BOTH criteria_order and criteria if you want
# to output correctly named files.
criterias <- list(function() {(info_vec[5] == "S11") && (info_vec[6] == "M")},
                  function() {(info_vec[5] == "U") && (info_vec[6] == "M")}, 
                  function() {(info_vec[5] == "G") && (info_vec[6] == "M")}, 
                  function() {!(info_vec[5] %in% c("S11","G","U")) && (info_vec[6] == "M")},
                  function() {(info_vec[5] == "S11") && (info_vec[6] == "F")},
                  function() {(info_vec[5] == "U") && (info_vec[6] == "F")}, 
                  function() {(info_vec[5] == "G") && (info_vec[6] == "F")}, 
                  function() {!(info_vec[5] %in% c("S11","G","U")) && (info_vec[6] == "F")})
criteria_order <- c("S11_M", "U_M", "GFP_M", "S12_M", "S11_F",
                    "U_F", "GFP_F", "S12_F")

### STEP 2: Load in the functions
source("R files/2_Functions.R") # this will read in the script containing the necessary functions

filter_plot <- function(filename) {
  plot(shots, average_angle_per_shot, main = convert_to_title(file_name),
      xlab = "", ylab = "Angle (degrees)", col = "mediumorchid4",
      type = "l", ylim = c(-25, 25), xaxt = "n")
  grid() # add gridlines
  abline(h = 0, col = "red") # add a red line at y = 0

  y_axis_size <- max(left_leg_center_dist_normalized, right_leg_center_dist_normalized)

  plot(right_leg_center_dist_normalized, type = "l", col = "blue",
       ylim = c(-y_axis_size, y_axis_size),
       main = paste("leg-center distance for", convert_to_title(file_name)),
       xlab = "", ylab = "Distance(px)")
  lines(left_leg_center_dist_normalized * -1, col = "red")
  abline(h = 0, col = "black", lty = 2)
  legend("topright", legend = c("Left leg", "Right leg"),
         col = c("blue", "red"), lty = 1)
  grid()
}

## This loop allows us to read every csv file in a directory
n <- 1
for (filtering_criteria in criterias) {
  pdf(paste0(output_directory, "/", criteria_order[n], "_stim01.pdf"), width = 17, height = 22)
  par(mfrow = c(6,1), mar = c(1,1,2,0.5), oma = c(1,1,1,1),cex.lab=1,cex.axis=1, 
      cex.main = 1.5)
  n <- n + 1
  for (file_name in file_list) {
    info_vec <- convert_to_datavec(file_name)

    # Filtering and only plot those that fits in the selection.
    if (filtering_criteria()) {
      print(convert_to_title(file_name))
      ### STEP 3: Load in the data
      source("R files/3_Reader.R")

      ### STEP 4: Perform the relevant calculations
      minimum_sound <- 0 # in dB, typically zero
      maximum_sound <- 90 # in dB, depends on experiment

      source("R files/4_Calculator_More_Angle.R")

      filter_plot()

      num_files <- num_files + 1
    }
  }
  dev.off()
}

print(paste0(num_files, " files outputted sucessfully. "))