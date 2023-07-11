library(tidyverse)
library(MASS)
library(raster)
library(stringr)
source("R files/utils.R")
source("R files/2_Functions.R")
input_directory <- "DLC_output/DLC_csv_files_it7_s4_stim01"
primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"

setwd(primary_directory)

### STEP 1: Decide on your filename(s)
file_list <- list.files(path = input_directory, pattern = ".csv")
cat("# of .csv files found: ", length(file_list), "\n")

filtering_critiera <- function() {
  # for S12 use !(info_vec[5] %in% c("S11","G","U")), cuz naming method for s12 is ass. 
  (info_vec[6] == "M") && (info_vec[5] == "S11")
  # (as.numeric(format(as.Date(info_vec[1]), "%m")) >= 6) && (format(as.Date(info_vec[1]), "%Y") == 2021)
}
minimum_sound <- 0 # in dB, typically zero 
maximum_sound <- 90 # in dB, depends on experiment

pdf("angle_and_foot_dist.pdf", width = 30, height = 20)
par(mfrow = c(2, 1), mar = c(2, 2, 2, 2), oma = c(1,1,1,1))
for (file_name in file_list) {
  info_vec <- convert_to_datavec(file_name)
  # if (!(filtering_critiera())) {next}
  source("R files/3_Reader.R")
  source("R files/4_Calculator_More_Angle.R")
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
dev.off()
# Lines below are functions that could be inserted to testing.'

check_wax_shift <- function() {
  # remove the first 30 and last 30 frames for consistency
  stripped_wax_x <- wax_x[50:(length(wax_x) - 50)]
  stripped_wax_y <- wax_y[50:(length(wax_y) - 50)]

  movement <- dist.func(stripped_wax_x[-length(stripped_wax_x)],
    stripped_wax_y[-length(stripped_wax_y)], stripped_wax_x[-1], stripped_wax_y[-1])

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