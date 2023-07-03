library(tidyverse)

#### 1_Master.R      (updated June 29, 2021 by Max Hukill for the tutorial video)
### This script controls the process of going from a DLC .csv file to a graphical .pdf file.
### We do this in 5 steps, each with its oscript. See the tutorial video and handout for more guidance.

formatted_time <- format(Sys.time(), "%Y-%m-%d-%H-%M")
output_description <- ""
### STEP 0: Define your directories
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
output_directory <- paste0("graphs_output/", formatted_time, " ", output_description)
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
setwd(primary_directory)

if (!file.exists(output_directory)) {
  # Create the output directory
  dir.create(output_directory, recursive = TRUE)  # recursive means if the parent dir doesn't exist, it will proceed to create. 
  cat("Output directory created successfully!\n")
} else {
  cat("Output directory already exists.\n")
}

## I recommend using the structure from the extant GitHub link, but you can use whatever file structure you deem fit. 
## (These three lines above are all you should have to change if changing the file structure.)


### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
stripped_files <- str_remove(file_list, pattern='.csv')
cat("# of .csv files found: ", length(stripped_files), "\n")
results = matrix(NA, nrow = length(stripped_files), ncol = 2)
colnames(results) = c("File name", "Average turn (degrees)")
num.files = 1
#results <- aperm(results, c(2, 1))

### STEP 2: Load in the functions
source("R files/2_Functions.R") # this will read in the script containing the necessary functions
#cat("Step 2 Complete. Functions successfully read.", "\n")

## This loop allows us to read every csv file in a directory
for (i in stripped_files) {
  file_name = i # this is one file in a directory
  file_name_csv <- paste(file_name, ".csv", sep='') 
  output_name <- NULL
  print(file_name_csv)
  
  ### STEP 3: Load in the data
  source("R files/3_Reader.R")
  #cat("Step 3 Complete. Data successfully read.", "\n")
  
  ### STEP 4: Perform the relevant calculations
  minimum_sound <- 0 # in dB, typically zero 
  maximum_sound <- 90 # in dB, depends on experiment
  tick_mark_interval <- 10 # in dB, space between tick marks
  # results[1, 1] = file_name_csv
  # print(file_name_csv)
  # results[1, 2] = avg.turn
  # print(avg.turn)
  # results[1, 3] = sd.turn
  #cat("diff.turn is:", diff.turn)
  # results[num.files, 1] = file_name_csv
  # results[2, 2] = diff.turn
  
  #results[num.files, 3] = sd.turn
  source("R files/4_Calculator.R")
  #cat("Step 4 Complete. Calculations performed.", "\n")

  ### STEP 5: Generate and save the cricket's graph
  source("R files/5_Grapher.R")
  #qcat("Step 5 Complete. Graph saved as:", output_name_pdf ,"\n")
   
  num.files = num.files + 1
  print(num.files)
}
#results <- aperm(results, c(2, 1))

#print(results[2,2])
# create a data frame with some values

