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
    extract_note_from_filename(filename))
}

extract_name_from_filename <- function(filename) {
  # Extracting individual name (e.g., 201027UM1)
  sub(".*?(\\d{6}[A-Za-z0-9]+).*", "\\1", filename)
}

extract_date_from_filename <- function(filename) {
  # Converting timestamp to a human-friendly format
  sub("(\\d{4})-(\\d{2})-(\\d{2})\\s(\\d{2})-(\\d{2})-(\\d{2}).*",
  "\\1/\\2/\\3 \\4:\\5:\\6", filename)
}

extract_stim_from_filename <- function(filename) {
  # Extracting stimulus number (e.g., 03)
  str_extract(filename, "(?<=stim)\\d{2}(?=.*DLC)")
}

extract_note_from_filename <- function(filename) {
  str_extract(filename, "(?<=stim\\d{2}).*(?=DLC)")
}