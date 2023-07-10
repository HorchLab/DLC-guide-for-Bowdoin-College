# This function provides simple functions to handle long and complicated .csv
# files names can extract useful informations.

library(stringr)

convert_to_title <- function(filename) {
  if (!is.character(filename)) {
    print("Not a valid filename type!")
    return()
  }
  # Converting filename to title format
  title <- paste(extract_name_from_filename(filename), "at",
        extract_date_from_filename(filename),
        "stim", extract_stim_from_filename(filename))
  note <- extract_note_from_filename(filename)
  if (!is.na(note)) {
    title <- paste(title, note)
  }
  title
}

# This function converts a filename to a vector of useful information
convert_to_datavec <- function(filename) {
  c(extract_date_from_filename(filename),
    extract_name_from_filename(filename),
    extract_stim_from_filename(filename),
    extract_note_from_filename(filename),
    extract_group_from_filename(filename),
    extract_sex_from_filename(filename))
}

extract_name_from_filename <- function(filename) {
  # Extracting individual name (e.g., 201027UM1)
  sub(".*?(\\d{6}[A-Za-z0-9]+).*", "\\1", filename)
}

extract_date_from_filename <- function(filename) {
  # Extracting date and time from filename
  out <- str_extract(filename, "\\d{4}-\\d{2}-\\d{2}\\s\\d{2}-\\d{2}-\\d{2}")

  if (is.na(out)) {
    # if there's no time, only date is fine.
    out <- str_extract(filename, "\\d{4}-\\d{2}-\\d{2}")
  }
  out
}

extract_stim_from_filename <- function(filename) {
  # Extracting stimulus number (e.g., 03)
  str_extract(filename, "(?<=stim)\\d{2}(?=.*DLC)")
}

extract_note_from_filename <- function(filename) {
  str_extract(filename, "(?<=stim\\d{2}).*(?=DLC)")
}

extract_group_from_filename <- function(filename) {
  str_extract(extract_name_from_filename(filename), "(?<=\\d{6}).*(?=[MF])")
}

extract_sex_from_filename <- function(filename) {
  str_extract(extract_name_from_filename(filename), "[MF]")
}

#' Given three vectors of x and y coordinates, this function will return the
#' angle next to point 1. The angle is in degrees.
#'
#' @param x1 x-coordinate of the first point
#' @param y1 y-coordinate of the first point
#' @param x2 x-coordinate of the second point
#' @param y2 y-coordinate of the second point
#' @param x3 x-coordinate of the third point
#' @param y3 y-coordinate of the third point
#' @return angle next to point 1 in degrees
#' @examples
#' angle_between_points(0, 0, 1, 0, 1, 1)
#' angle_between_points(c(0,0), c(0,1), c(1,0), c(1,1), c(2,2), c(2,3))
angle_between_points <- function(x1, y1, x2, y2, x3, y3) {
  # Convert the input time series to a matrix
  mat <- cbind(x1, y1, x2, y2, x3, y3)

  # Calculate the dot product of the two vectors
  v1 <- mat[, 3:4] - mat[, 1:2]
  v2 <- mat[, 5:6] - mat[, 1:2]
  dot_prod <- rowSums(v1 * v2)

  # Calculate the magnitudes of the two vectors
  mag_v1 <- sqrt(rowSums(v1^2))
  mag_v2 <- sqrt(rowSums(v2^2))

  # Calculate the angle between the two vectors
  angle <- acos(dot_prod / (mag_v1 * mag_v2))

  # Convert the angle to degrees
  angle * 180 / pi
}

#' This function calculates the perpendicular distance between a point and a
#' line segment.
#'
#' @param x1 x-coordinate of the first point of the line segment
#' @param y1 y-coordinate of the first point of the line segment
#' @param x2 x-coordinate of the second point of the line segment
#' @param y2 y-coordinate of the second point of the line segment
#' @param x0 x-coordinate of the point
#' @param y0 y-coordinate of the point
#' @return perpendicular distance between the point and the line segment
perpendicular_distance <- function(x1, y1, x2, y2, x0, y0) {
  abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1) / sqrt((y2-y1)^2 + (x2-x1)^2)
}
