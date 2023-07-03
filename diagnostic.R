library(tidyverse)
library(MASS)
library(raster)
library(stringr)
source("R files/utils.R")
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
primary_directory <- "~/2023 Summer/DLC-guide-for-Bowdoin-College"

setwd(primary_directory)

### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern='.csv') # make sure to identify which directory 
stripped_files <- str_remove(file_list, pattern='.csv')
cat("# of .csv files found: ", length(stripped_files), "\n")

center_point <- function(x, y) {
  # Estimate the density of the points using kernel density estimation
  dens <- kde2d(x, y, n = 100)
  plot(raster(dens), main = convert_to_title(file_name))
  
  # Find the index of the point with the highest density
  max_idx <- which(dens$z == max(dens$z), arr.ind = TRUE)
  
  # Extract the x and y coordinates of the center point
  center_x <- dens$x[max_idx[1]]
  center_y <- dens$y[max_idx[2]]
  
  # Return the center point as a vector
  return(c(center_x, center_y))
}

for (i in stripped_files) 
{
  file_name = i # this is one file in a directory
  file_name_csv <- paste(file_name, ".csv", sep='') 
  output_name <- NULL
  # print(file_name_csv)
  
  cat(extract_group_from_filename(file_name), " ")
  
}

# Lines below are functions that could be inserted to testing.'

check_wax_shift <- function() {
  # remove the first 30 and last 30 frames for consistency
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


