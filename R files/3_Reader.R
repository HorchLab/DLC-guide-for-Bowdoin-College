## 3_Reader.R: reads in data, defines regions of interest (ROIs). Used with Master.R
setwd(input_directory) # enter subdirectory containing data files
data <- read.csv(file_name_csv, # generates dataframe from .csv file
                 skip = 3, header = FALSE) # skip first 3 lines, ignore header names
## Defining ROIs
frame_col <- data[, 1]
ab_x <- data[, 2]
  thorax_x <- ab_x
ab_y <- data[, 3]
  thorax_y <- ab_y

wax_x <- data[, 5]
wax_y <- data[, 6]

left_knee_x <- data[, 8]
left_knee_y <- data[, 9]

left_foot_x <- data[, 11]
left_foot_y <- data[, 12]

right_knee_x <- data[, 14]
right_knee_y <- data[, 15]

right_foot_x <- data[, 17]
right_foot_y <- data[, 18]

ss_x <- data[, 20]
ss_y <- data[, 21]

setwd(primary_directory) # return to main directory