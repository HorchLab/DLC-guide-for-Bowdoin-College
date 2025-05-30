# NOTES:
# your main R file if you want to create those barplots according to cricket. 
#	- I made new csv files according to first pass vs second pass here. 
# Uses pooled_results.csv as the data file so be sure to note left/1 or right/2 when naming csv files

# ======================
# SETUP
# ======================
library(dplyr)
library(ggplot2)

# Check and load data
required_cols <- c("source_file", "s_chunk", "s_side", 
                   "Anchor_L_x", "Anchor_L_y", "Anchor_R_x", "Anchor_R_y",
                   "Abdomen_Tip_x", "Abdomen_Tip_y", "state_label")
all.df <- read.csv("pooled_results.csv", header = TRUE)

stopifnot("Missing required columns" = all(required_cols %in% colnames(all.df)))
# ======================
# REFERENCE CALCULATION
# ======================
file_anchors <- all.df %>%
  filter(s_chunk == 0 & s_side == "silent") %>%
  group_by(source_file) %>%
  summarize(
    ref_midpoint_x = mean((Anchor_L_x + Anchor_R_x)/2, na.rm = TRUE),
    ref_midpoint_y = mean((Anchor_L_y + Anchor_R_y)/2, na.rm = TRUE),
    ref_abdomen_x = mean(Abdomen_Tip_x, na.rm = TRUE),
    ref_abdomen_y = mean(Abdomen_Tip_y, na.rm = TRUE)
  ) %>%
  mutate(
    across(c(ref_midpoint_x, ref_midpoint_y, ref_abdomen_x, ref_abdomen_y)
    ))

all.df <- all.df %>% 
  left_join(file_anchors, by = "source_file")

# ======================
# ANGLE CALCULATION 
# ======================
all.df <- all.df %>%
  mutate(
    # Safe distance calculation
    b = sqrt((ref_midpoint_x - ref_abdomen_x)^2 + 
                    (ref_midpoint_y - ref_abdomen_y)^2),
    a = sqrt((Abdomen_Tip_x - ref_abdomen_x)^2 + 
               (Abdomen_Tip_y - ref_abdomen_y)^2),
    c = sqrt((ref_midpoint_x - Abdomen_Tip_x)^2 + 
                    (ref_midpoint_y - Abdomen_Tip_y)^2),
    # Numerically stable angle calculation
    angle_raw = acos((b^2 + c^2 - a^2)/(2 * b * c)) * 180/pi
  )

# ======================
# NORMALIZATION
# ======================
file_means <- all.df %>%
  filter(s_chunk == 0 & s_side == "silent") %>%
  group_by(source_file) %>%
  summarize(
    ref_mean_angle = mean(angle_raw, na.rm = TRUE),
  )

all.df <- all.df %>%
  left_join(file_means, by = "source_file") %>%
  mutate(
    angle_norm = angle_raw - ref_mean_angle,
  )

# ======================
# MAKE NEW DATA FRAME FOR MATCHING CHUNKS ONLY
# ======================
new.df <- all.df %>% 
  filter(state_label == "flying",  s_chunk %in% c(0, 2, 50, 55, 60, 65, 70, 75, 80, 85, 90)) %>%  
  group_by(source_file, s_side, s_chunk) %>%
  summarize(
    mean_norm_angle = mean(angle_norm, na.rm=TRUE),
    .groups = 'drop'     
  )%>%
  mutate(
    s_chunk = factor(s_chunk),  # for better plotting
    s_side = factor(s_side)     # for consistent factor levels
  ) %>%
  arrange(source_file, mean_norm_angle, s_chunk, s_side)  # Sort logically

# ========================================================================================
# This is the data frame you would write a new CSV file for. 
# The new.df will give all flying for those chunks. After I make a new df, I add two
# new columns, cricket name and sex. I ran out of time to automate, so I just put names and 
# sex by hand. It would be better if you could make a script or something else. 
# Doing it this way allows you to do comparisons across flights and sex filtering 
# used for later files. 
# ========================================================================================


# =====================================================
# FOR FILTERING THE DATA FRAME BASED ON SOURCE FILE:
# =====================================================
file <- "240924_240830M1_MERGED.csv"

# GRAPH
plot_data <- all.df %>% 
  filter(source_file == file, # This will be your prime filtering criteria. Add commas for more filters. 
         state_label == "flying",
         s_chunk %in% c(0, 50, 55, 60, 65, 70, 75, 80, 85, 90)) %>% 
  mutate(s_chunk = factor(s_chunk))
  
  s <- ggplot(plot_data, aes(x = s_chunk, y = angle_norm, fill = s_side)) +
    geom_boxplot(, 
      alpha = 0.2,
      position = position_dodge(width = 0.8)  # Explicit dodge position
    ) +
    geom_jitter(
      alpha = 0.05, 
      size = 2, 
      aes(color = s_side),
      position = position_jitterdodge(  # Key alignment fix
        jitter.width = 0.2,           # Horizontal spread
        dodge.width = 0.8             # Must match boxplot dodge width
      )
    ) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "blue") +
    coord_cartesian(ylim = c(-5, 20)) + 
    scale_fill_manual(
      values = c("left" = "#FFA500", "right" = "#32CD32", "silent" = "#808080"),
      labels = c("Left/1", "Right/2", "Silent")
    ) +
    scale_color_manual(
      name = "Sound Direction",
      values = c("left" = "#FFA500", "right" = "#32CD32", "silent" = "#808080"),
      labels = c("Left/1", "Right/2", "Silent"),
      guide = "none"
    ) +
    labs(
      x = "Sound Amplitude (SPL)",
      y = "Normalized Abdomen Angle (degrees)",
      subtitle = paste((file), "filtered by flying; First/Second Flight"),
      fill = "Sound Cycle Pass"
    ) +
    theme_minimal(base_size = 13) +
    theme(
      legend.position = "top",
      panel.grid.major.x = element_blank()
    )
  print(s)

  