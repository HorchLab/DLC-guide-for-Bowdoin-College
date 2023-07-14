# This script recreate the trajectory plot similar to deeplabcut
source("R files/utils.R")
fixed_xlim <- c(0, 800)
fixed_ylim <- c(600, 100)


primary_directory <- "~/summer2023/DLC-guide-for-Bowdoin-College"
input_directory <- "DLC_output/DLC_csv_files_it8_stim01"
output_directory <- "filtered_trajectory_plot_it8"
setwd(primary_directory)

if (!file.exists(output_directory)) {
  # Create the output directory
  dir.create(output_directory, recursive = TRUE)  # recursive means if the parent dir doesn't exist, it will proceed to create. 
  cat("Output directory created successfully!\n")
} else {
  cat("Output directory already exists.\n")
}

file_list <- list.files(path = input_directory, pattern = '.csv')
cat("# of .csv files found: ", length(file_list), "\n")

for (file_name in file_list) {
    png(paste0(output_directory, "/", convert_to_title(file_name), ".png"), width = 1280, height = 720)
    source("R files/3_Reader.R")
    print(file_name)
    # Create a new empty plot
    plot(NA, NA, xlim = fixed_xlim, ylim = fixed_ylim, xlab = "x (px)", ylab = "y (px)")

    points(ab_x, ab_y, col = "purple")
    points(wax_x, wax_y, col = "black")
    points(left_knee_x, left_knee_y, col = "blue")
    points(left_foot_x, left_foot_y, col = "#fff700")
    points(right_knee_x, right_knee_y, col = "#909b00")
    points(right_foot_x, right_foot_y, col = "#f22626")
    legend("bottomright",
    legend = c("abdomen", "wax", "left knee", "left foot", "right knee", "right foot"),
    col = c("purple", "black", "blue", "green", "orange", "red"),
            pch = 1, cex = 0.8)
    dev.off()
}