library(tidyverse)
library(MASS)
library(stringr)
source("R files/utils.R")
# This script is designed in a way that you can change all useful parameters
# before the for loop. Don't touch stuff below unless u know what's happening. 

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

# Change this if you want to display different audio. 
# REMEMBER to change the output name too!!!
# filtering_criteria <- function() {
  # for S12 use !(info_vec[5] %in% c("S11","G","U")), cuz naming method for s12 is ass. 
  # (info_vec[6] == "F") && (info_vec[5] == "S11")
  # (as.numeric(format(as.Date(info_vec[1]), "%m")) >= 6) && (format(as.Date(info_vec[1]), "%Y") == 2021)
# }
output_name <- "S11_stim01"  # don't add .pdf here. 

criterias <- list(function() {(info_vec[5] == "S11")},
                  function() {(info_vec[5] == "U")}, 
                  function() {(info_vec[5] == "G")}, 
                  function() {!(info_vec[5] %in% c("S11","G","U"))})
criteria_order <- c("S11", "U", "GFP", "S12")

file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
cat("# of .csv files found: ", length(file_list), "\n")
num.files = 1

### STEP 2: Load in the functions
source("R files/2_Functions.R") # this will read in the script containing the necessary functions

filter_plot <- function(filename) {
  plot(shots, average_angle_per_shot, main = convert_to_title(file_name), xlab = "",
       ylab = "Angle (degrees)", col = "mediumorchid4", type = "l", ylim = c(-25,25), xaxt = "n")
  grid() # add gridlines
  abline(h = 0, col = "red") # add a red line at y = 0
  
  plot(right_leg_center_dist, type = "l", col = "blue", ylim = c(-100, 100),
       main = paste("leg-center distance for", convert_to_title(file_name)),
       xlab = "", ylab = "Distance(px)")
  lines(left_leg_center_dist * -1, col = "red")
  abline(h = 0, col = "black", lty = 2)
  legend("topright", legend = c("Left leg", "Right leg"),
         col = c("blue", "red"), lty = 1)
}


## This loop allows us to read every csv file in a directory
n <- 1
for (filtering_criteria in criterias) {
  print(filtering_criteria)
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
      
      num.files = num.files + 1
    }
  }
  dev.off()
}

print(paste0(num.files, " files outputted sucessfully. "))