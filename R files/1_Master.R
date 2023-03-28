library(tidyverse)
library(openxlsx)

#### 1_Master.R      (updated June 29, 2021 by Max Hukill for the tutorial video)
### This script controls the process of going from a DLC .csv file to a graphical .pdf file.
### We do this in 5 steps, each with its oscript. See the tutorial video and handout for more guidance.

### STEP 0: Define your directories
primary_directory <- "~/Desktop/DLC"
output_directory <- "graphs_verified"
input_directory <- "individuals4"
## I recommend using the structure from the extant GitHub link, but you can use whatever file structure you deem fit. 
## (These three lines above are all you should have to change if changing the file structure.)
setwd(primary_directory)


### STEP 1: Decide on your filename(s)
file_list <- list.files(input_directory, pattern='.csv') # make sure to identify which directory 
stripped_files <- str_remove(file_list, pattern='.csv')
print(length(stripped_files))
results = matrix(NA, nrow = length(stripped_files), ncol = 2)
colnames(results) = c("File name", "Average turn (degrees)")
num.files = 1
#results <- aperm(results, c(2, 1))
## This loop allows us to read every csv file in a directory
for (i in stripped_files) {
  
  
  file_name = i # this is one file in a directory
  file_name_csv <- paste(file_name, ".csv", sep='') 
  output_name <- NULL
  print(file_name_csv)
  
  ### STEP 2: Load in the functions
  source("2_Functions.R") # this will read in the script containing the necessary functions
  #cat("Step 2 Complete. Functions successfully read.", "\n")
  
  ### STEP 3: Load in the data
  source("3_Reader.R")
  #cat("Step 3 Complete. Data successfully read.", "\n")
  
  ### STEP 4: Perform the relevant calculations
  minimum_sound <- 0 # in dB, typically zero 
  maximum_sound <- 90 # in dB, depends on experiment
  tick_mark_interval <- 10 # in dB, space between tick marks
  # results[1, 1] = file_name_csv
  # print(file_name_csv)
  # results[1, 2] = avg.turn
  # print(avg.turn)
  # results[1, 3] = sd.turn
  #cat("diff.turn is:", diff.turn)
  # results[num.files, 1] = file_name_csv
  # results[2, 2] = diff.turn
  
  #results[num.files, 3] = sd.turn
  source("4_Calculator.R")
  #cat("Step 4 Complete. Calculations performed.", "\n")

  ### STEP 5: Generate and save the cricket's graph
  source("5_Grapher.R")
  #qcat("Step 5 Complete. Graph saved as:", output_name_pdf ,"\n")
   
  num.files = num.files + 1
  print(num.files)
}
#results <- aperm(results, c(2, 1))

#print(results[2,2])
# create a data frame with some values


# create a new Excel workbook
my_wb <- createWorkbook()

# add a new worksheet to the workbook
addWorksheet(my_wb, "Sheet2")

# write the data frame to the worksheet
writeData(my_wb, "Sheet2", results)

# save the workbook to a file
saveWorkbook(my_wb, "Full_pass_throughv2.xlsx")

#write.xlsx(results, file = "test7.xlsx", sheetName = "Sheet1")

#write.xlsx(results, "Turn angle stats", row.names=FALSE, col.names=FALSE)

