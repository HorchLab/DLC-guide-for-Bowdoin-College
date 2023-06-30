library(tidyverse)
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim05"
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"

setwd(primary_directory)

### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
stripped_files <- str_remove(file_list, pattern='.csv')
cat("# of .csv files found: ", length(stripped_files), "\n")

par(mfrow=c(3,3),mar = c(1,1,1,1))

for (i in stripped_files) 
{
  file_name = i # this is one file in a directory
  file_name_csv <- paste(file_name, ".csv", sep='') 
  output_name <- NULL
  # print(file_name_csv)
  
  ### STEP 3: Load in the data
  source("R files/3_Reader.R")
  
  # remove the first 30 and last 30 frames for consistentcy
  stripped_wax_x <- wax_x[50:(length(wax_x) - 50)]
  stripped_wax_y <- wax_y[50:(length(wax_y) - 50)]
  
  
  movement = dist.func(stripped_wax_x[-length(stripped_wax_x)], stripped_wax_y[-length(stripped_wax_y)], 
                       stripped_wax_x[-1], stripped_wax_y[-1])
  
  if(any(movement > 20)) {
    
    # Extracting individual name (e.g., 201027UM1)
    individual_name <- sub(".*?(\\d{6}[A-Za-z0-9]+).*", "\\1", file_name)
    
    # Extracting description (e.g., SHORT ANTENNAE)
    description <- sub(".*stim\\d{2}(.*?)DLC.*", "\\1", file_name)
    
    # Converting timestamp to a human-friendly format
    timestamp <- sub("(\\d{4})-(\\d{2})-(\\d{2})\\s(\\d{2})-(\\d{2})-(\\d{2}).*", "\\2/\\3/\\1 \\4:\\5:\\6", file_name)
    
    info <- paste(individual_name, "at", timestamp, "with", description)
    
    cat("Unusual Movement in", info, "\n")
    plot(movement, main = info)
  }
  
  
}