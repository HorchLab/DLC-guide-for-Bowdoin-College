library(tidyverse)
library(MASS)
library(stringr)
source("R files/utils.R")

#### 1_Master.R 
### This script controls the process of going from a DLC .csv file to a graphical .pdf file.
### We do this in 5 steps, each with its oscript. See the tutorial video and handout for more guidance.

formatted_time <- format(Sys.time(), "%Y-%m-%d-%H-%M")
output_description <- ""
### STEP 0: Define your directories
primary_directory <- "~/2023 Summer/DLC-guide-for-Bowdoin-College"
output_directory <- paste0("graphs_output/", formatted_time, output_description)
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
setwd(primary_directory)

if (!file.exists(output_directory)) {
  # Create the output directory
  dir.create(output_directory, recursive = TRUE)  # recursive means if the parent dir doesn't exist, it will proceed to create. 
  cat("Output directory created successfully!\n")
} else {
  cat("Output directory already exists.\n")
}

### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
stripped_files <- str_remove(file_list, pattern='.csv')
cat("# of .csv files found: ", length(stripped_files), "\n")
results = matrix(NA, nrow = length(stripped_files), ncol = 2)
colnames(results) = c("File name", "Average turn (degrees)")
num.files = 1

### STEP 2: Load in the functions
source("R files/2_Functions.R") # this will read in the script containing the necessary functions

pdf(paste0(output_directory, "/", "all_plots.pdf"), width = 8.5, height = 11)
par(mfrow = c(6,1), mar = c(1,1,2,0.5), oma = c(1,1,1,1),cex.lab=1,cex.axis=1)

filter_plot <- function(filename) {
  plot(shots, average_angle_per_shot, main = convert_to_title(file_name), xlab = "",
  ylab = "Angle (degrees)", col = "blue", type = "l")
  grid() # add gridlines
  abline(h = 0, col = "red") # add a red line at y = 0
}

## This loop allows us to read every csv file in a directory
for (i in stripped_files) {
  file_name = i # this is one file in a directory
  file_name_csv <- paste(file_name, ".csv", sep='') 
  output_name <- NULL
  # print(file_name_csv)
  
  info_vec <- convert_to_datavec(file_name)
  
  if ((info_vec[6] == "M") && (info_vec[5] == "S11")) {
    # Filtering and only plot those that fits in the selection. 
    print(convert_to_title(file_name))
    
    ### STEP 3: Load in the data
    source("R files/3_Reader.R")
    
    ### STEP 4: Perform the relevant calculations
    minimum_sound <- 0 # in dB, typically zero 
    maximum_sound <- 90 # in dB, depends on experiment
    tick_mark_interval <- 10 # in dB, space between tick marks
    
    #results[num.files, 3] = sd.turn
    source("R files/4_Calculator_Fix_Anchor.R")
    #cat("Step 4 Complete. Calculations performed.", "\n")
  
    filter_plot()
    
    ### STEP 5: Generate and save the cricket's graph
    # source("R files/5_Grapher_Fixed_Anchor.R")
    #cat("Step 5 Complete. Graph saved as:", output_name_pdf ,"\n")
     
    num.files = num.files + 1
  }
}
dev.off()

print(paste0(num.files, " files outputted sucessfully. "))