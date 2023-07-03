# This function provides simple functions to handle long and complicated .csv
# files names can extract useful informations.

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
    # if there's no time, date is fine. 
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

# Given three vectors of x and y coordinates, this function will return the
# angle next to point 1. The angle is in degrees.
angle_between_points <- function(x1, y1, x2, y2, x3, y3) {
  # Think of it as 2 vectors, v1 1->2 and v2 1->3
  v1 <- c(x2 - x1, y2 - y1)
  v2 <- c(x3 - x1, y3 - y1)

  # Calculate the angle between the two vectors
  angle <- acos(sum(v1 * v2) / (sqrt(sum(v1^2)) * sqrt(sum(v2^2))))

  # Convert the angle to degrees
  angle * 180 / pi
}
