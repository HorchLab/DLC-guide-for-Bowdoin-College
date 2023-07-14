## 3_Reader.R: reads in data, defines regions of interest (ROIs). Used with Master.R
setwd(input_directory) # enter subdirectory containing data files

# generates dataframe from .csv file and skip first 3 lines, ignore header names
data <- read.csv(file_name, skip = 3, header = FALSE)

confidence_threshold <- 0.95

# Check for `skip_low_confidence` variable, if present, skip low confidence points
if (exists("skip_low_confidence") && skip_low_confidence) {
    # skip low confidence points
    print(paste0("Skipping low confidence points (likelihood <",
          confidence_threshold, ")"))
    ab_likelihood <- data[, 4]
    wax_likelihood <- data[, 7]
    left_knee_likelihood <- data[, 10]
    left_foot_likelihood <- data[, 13]
    right_knee_likelihood <- data[, 16]
    right_foot_likelihood <- data[, 19]
    ss_likelihood <- data[, 22]
}

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

# replace low confidence points with NA
if (exists("skip_low_confidence") && skip_low_confidence) {
    ab_x[ab_likelihood < confidence_threshold] <- NA
    ab_y[ab_likelihood < confidence_threshold] <- NA
    wax_x[wax_likelihood < confidence_threshold] <- NA
    wax_y[wax_likelihood < confidence_threshold] <- NA
    left_knee_x[left_knee_likelihood < confidence_threshold] <- NA
    left_knee_y[left_knee_likelihood < confidence_threshold] <- NA
    left_foot_x[left_foot_likelihood < confidence_threshold] <- NA
    left_foot_y[left_foot_likelihood < confidence_threshold] <- NA
    right_knee_x[right_knee_likelihood < confidence_threshold] <- NA
    right_knee_y[right_knee_likelihood < confidence_threshold] <- NA
    right_foot_x[right_foot_likelihood < confidence_threshold] <- NA
    right_foot_y[right_foot_likelihood < confidence_threshold] <- NA
    ss_x[ss_likelihood < confidence_threshold] <- NA
    ss_y[ss_likelihood < confidence_threshold] <- NA

    # print some summary statistics about how many points were replaced
    print(paste0("abdomen: ", sum(is.na(ab_x)), " points replaced. (", sum(is.na(ab_x)) / length(ab_x) * 100, "%)"))
    print(paste0("wax: ", sum(is.na(wax_x)), " points replaced. (", sum(is.na(wax_x)) / length(wax_x) * 100, "%)"))
    print(paste0("left knee: ", sum(is.na(left_knee_x)), " points replaced. (", sum(is.na(left_knee_x)) / length(left_knee_x) * 100, "%)"))
    print(paste0("left foot: ", sum(is.na(left_foot_x)), " points replaced. (", sum(is.na(left_foot_x)) / length(left_foot_x) * 100, "%)"))
    print(paste0("right knee: ", sum(is.na(right_knee_x)), " points replaced. (", sum(is.na(right_knee_x)) / length(right_knee_x) * 100, "%)"))
    print(paste0("right foot: ", sum(is.na(right_foot_x)), " points replaced. (", sum(is.na(right_foot_x)) / length(right_foot_x) * 100, "%)"))
    print(paste0("sound stimuli: ", sum(is.na(ss_x)), " points replaced. (", sum(is.na(ss_x)) / length(ss_x) * 100, "%)")) 
}



setwd(primary_directory) # return to main directory