library(tidyverse)
library(MASS)
library(stringr)
source("R files/utils.R")
# This script is designed in a way that you can change all useful parameters
# before the for loop. Don't touch stuff below unless u know what's happening. 


primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
output_directory <- "filtering_output"
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
filtering_critiera <- function() {
  # for S12 use !(info_vec[5] %in% c("S11","G","U")), cuz naming method for s12 is ass. 
  # (info_vec[6] == "F") && (!(info_vec[5] %in% c("S11","G","U")))
  (as.numeric(format(as.Date(info_vec[1]), "%m")) >= 6) && (format(as.Date(info_vec[1]), "%Y") == 2021)
}
output_name <- "2021AUG_stim01"  # don't add .pdf here. 

file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
cat("# of .csv files found: ", length(file_list), "\n")
num.files = 1

### STEP 2: Load in the functions
source("R files/2_Functions.R") # this will read in the script containing the necessary functions

filter_plot <- function(filename) {
  plot(shots, average_angle_per_shot, main = convert_to_title(file_name), xlab = "",
       ylab = "Angle (degrees)", col = "blue", type = "l", ylim = c(-25,25), xaxt = "n")
  grid() # add gridlines
  abline(h = 0, col = "red") # add a red line at y = 0
}

pdf(paste0(output_directory, "/", output_name, ".pdf"), width = 8.5, height = 11)
par(mfrow = c(6,1), mar = c(1,1,2,0.5), oma = c(1,1,1,1),cex.lab=1,cex.axis=1, 
    cex.main = 1)
## This loop allows us to read every csv file in a directory
for (i in file_list) {
  file_name = i # this is one file in a directory, now with ".csv"
  
  info_vec <- convert_to_datavec(file_name)
  
  # Filtering and only plot those that fits in the selection. 
  if (filtering_critiera()) {
    
    print(convert_to_title(file_name))
    
    ### STEP 3: Load in the data
    source("R files/3_Reader.R")
    
    ### STEP 4: Perform the relevant calculations
    minimum_sound <- 0 # in dB, typically zero 
    maximum_sound <- 90 # in dB, depends on experiment
    
    #results[num.files, 3] = sd.turn
    source("R files/4_Calculator_Fix_Anchor.R")
    
    filter_plot()
    
    num.files = num.files + 1
  }
}
dev.off()

print(paste0(num.files, " files outputted sucessfully. "))