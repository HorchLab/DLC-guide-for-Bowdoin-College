# This script assumes that you have a data frame from the one created by GroupBySourceFile.R according to first vs repeat flight 
# and have new columns cricketName and sex. 


library(patchwork)  # For combining plots
library(dplyr)
library(tidyverse)

data.frame <- read.csv("L_____.csv", header = TRUE)
# data.frame2 <- read.csv("R_____.csv", header = TRUE)


target_chunks <- c(0, 70, 75, 80, 85, 90)

# 1. First identify compliant crickets (from previous step)
check_cricket_conditions <- function(df) {
  df %>%
    mutate(s_chunk_num = as.numeric(as.character(s_chunk))) %>%
    group_by(cricketName) %>%
    summarize(
      has_both_70 = all(c("left", "right") %in% s_side[s_chunk_num == 70]),
      has_both_75 = all(c("left", "right") %in% s_side[s_chunk_num == 75]),
      has_both_80 = all(c("left", "right") %in% s_side[s_chunk_num == 80]),
      has_both_85 = all(c("left", "right") %in% s_side[s_chunk_num == 85]),
      has_both_90 = all(c("left", "right") %in% s_side[s_chunk_num == 90]),
      has_silent_0 = "silent" %in% s_side[s_chunk_num == 0],
      meets_all = has_both_70 & has_both_75 & has_both_80 & has_both_85 & has_both_90 & has_silent_0,
      .groups = "drop"
    ) %>%
    filter(meets_all)
}

 compliant_crickets <- #intersect( # This is essentially the filtering stage. 
   check_cricket_conditions(data.frame)$cricketName
#   check_cricket_conditions(data.frame2)$cricketName
# )

combined_data <- bind_rows(
  data.frame %>% 
    filter(cricketName %in% compliant_crickets,
           as.numeric(as.character(s_chunk)) %in% target_chunks) %>%
    mutate(pass = "first") 
  # data.frame2 %>%
  #   filter(cricketName %in% compliant_crickets,
  #          as.numeric(as.character(s_chunk)) %in% target_chunks) %>%
  #   mutate(pass = "second")
) %>%
  select(cricketName, s_chunk, s_side, mean_norm_angle, pass, Sex) %>%
  arrange(cricketName, s_chunk, s_side, pass)


# This section is to do the t-tests and comparisons according to different filters. Make sure you use the correct column / row that you want
wider_combined_data <- pivot_wider(combined_data, names_from = pass, values_from = mean_norm_angle, names_prefix = "mean_norm_angle")

male <- unlist(wider_combined_data$mean_norm_anglefirst[wider_combined_data$s_chunk == 80 & wider_combined_data$Sex == "M"])
female <- unlist(wider_combined_data$mean_norm_anglefirst[wider_combined_data$s_chunk == 80 & wider_combined_data$Sex == "F"])

result <- t.test(male, female, paired = FALSE)
                 #, female, paired = FALSE)
print(result)
