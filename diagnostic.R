library(tidyverse)
library(MASS)
library(raster)
library(stringr)
source("R files/utils.R")
source("R files/2_Functions.R")
input_directory <- "DLC_output/DLC_csv_files_it8_stim01"
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"

setwd(primary_directory)

### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern = ".csv")
cat("# of .csv files found: ", length(file_list), "\n")

minimum_sound <- 0 # in dB, typically zero 
maximum_sound <- 90 # in dB, depends on experiment

for (file_name in file_list) {
  skip_low_confidence <- TRUE
  source("R files/3_Reader.R")
  # plot likelihood for all points on one histogram with ggplot
  # Plots a histogram of the likelihood values for all points using ggplot.
  # Adds a legend to the plot with meaningful names.
  #
  # data: data frame containing the likelihood values for all points.
  # Returns: a ggplot object.
  likelihood_plot <- ggplot(data, aes(V4, V7, V10, V13, V16, V19, V22)) +
    geom_histogram(binwidth = 0.01) +
    labs(title = convert_to_title(file_name),
      x = "Likelihood Value", y = "Count") +
    scale_fill_manual(values = c("V4" = "red", "V7" = "blue", "V10" = "green",
               "V13" = "purple", "V16" = "orange", "V19" = "black",
               "V22" = "brown"),
               name = "Point Number",
               labels = c("Abdomen", "Wax", "Left Knee", "Left Foot", "Right Knee", "Right Foot", "Sound")) +
    guides(fill = guide_legend(title = NULL))
  likelihood_plot
}
# Lines below are functions that could be inserted to testing.'

filter_plot <- function() {
  source("R files/4_Calculator_More_Angle.R")
  
  good_flyer_index = 
  
}

check_wax_shift <- function() {
  # remove the first 30 and last 30 frames for consistency
  stripped_wax_x <- wax_x[50:(length(wax_x) - 50)]
  stripped_wax_y <- wax_y[50:(length(wax_y) - 50)]

  movement <- dist.func(stripped_wax_x[-length(stripped_wax_x)],
    stripped_wax_y[-length(stripped_wax_y)], stripped_wax_x[-1], stripped_wax_y[-1])

  if (any(movement > 20)) {

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