# 4_Calculator.R: performs calculations and visualization routine given a file
# Used with 1_Master.R | This is a fix of the current existing script.

# PLEASE READ: Despite the fact that this script is a fix of the current
# existing script, many variables are removed/renamed for better readability.
# Please don't try to copy and paste this script into original script.

# Some positions of interest
thorax_x_mean <- mean(ab_x)
thorax_y_mean <- mean(ab_y)
frame_len <- length(ab_x) # this is how many frames are in the dataset

center_point <- function(x, y) {
  # Estimate the density of the points using kernel density estimation
  # NOTE: when n is too small kde gets weird, N = 200 glitched. 
  dens <- kde2d(x, y, n = 300)
  # plot(raster(dens), main = convert_to_title(file_name))
  
  # Find the index of the point with the highest density
  max_idx <- which(dens$z == max(dens$z), arr.ind = TRUE)
  
  # Extract the x and y coordinates of the center point
  center_x <- dens$x[max_idx[1]]
  center_y <- dens$y[max_idx[2]]
  
  # Return the center point as a vector
  return(c(center_x, center_y))
}

anchor <- center_point(wax_x, wax_y)
anchor_x <- anchor[1]
anchor_y <- anchor[2]

# Find the angle between the abdomen and the center line:
# Note: This part would've been much easier computationally, but since this is
# not really a time consuming part I'm just going to use it as it is.

a <- dist.func(ab_x, ab_y, anchor_x, ab_y)
b <- dist.func(anchor_x, anchor_y, anchor_x, ab_y)
c <- dist.func(ab_x, ab_y, anchor_x, anchor_y)

angles <- acos((b^2 + c^2 - a^2) / (2 * b * c)) * 180 / pi # angle calculation

# Define center line (wax) as zero; make angles positive or negative deviation
# from that line:
for (i in 1:frame_len) {
  if (ab_x[i] <= anchor_x) {
    angles[i] <- -angles[i]
  }
}

T <- frame_len  # Totally unnecessary, here because legacy code below. 
frames <- 1:frame_len
frames_per_shot <- 12 # Changeable
average_angle_per_shot <- rep(0, ceiling(frame_len / frames_per_shot))

for (i in seq(0, frame_len, frames_per_shot)) {
  average_angle_per_shot[i / frames_per_shot] <-
  mean(angles[i:i + frames_per_shot - 1])
}

shots <- seq(0, frame_len, frames_per_shot)

# Below is the part of code I can't understand. I'll just leave it as it is.


body.twitch <- rep(0, frame_len)
upperleft.twitch <- rep(0, frame_len)
upperright.twitch <- rep(0, frame_len)
lowerleft.twitch <- rep(0, frame_len)
lowerright.twitch <- rep(0, frame_len)
grand.twitch <- rep(0, frame_len)

average.twitch <- rep(0,0)
bodyshot.twitch <- rep(0,0)
upperleftshot.twitch <- rep(0,0)
upperrightshot.twitch <- rep(0,0)
lowerleftshot.twitch <- rep(0,0)
lowerrightshot.twitch <- rep(0,0)

# TODO: This is a terrible implementation. Please fix this.
for(i in seq(1, T-12,frames_per_shot)){
  ab_x_mean <- mean(ab_x[(i):(i+11)])
  ab_y_mean <- mean(ab_y[(i):(i+11)])
  wax_x_mean <- mean(wax_x[(i):(i+11)])
  wax_y_mean <- mean(wax_y[i:(i+11)])
  left_knee_x_mean <- mean(left_knee_x[i:(i+11)])
  left_knee_y_mean <- mean(left_knee_y[i:(i+11)])
  left_foot_x_mean <- mean(left_foot_x[i:(i+11)])
  left_foot_y_mean <- mean(left_foot_y[i:(i+11)])
  right_knee_x_mean <- mean(right_knee_x[i:(i+11)])
  right_knee_y_mean <- mean(right_knee_y[i:(i+11)])
  right_foot_x_mean <- mean(right_foot_x[i:(i+11)])
  right_foot_y_mean <- mean(right_foot_y[i:(i+11)])
  upperleft.sum <- 0
  upperright.sum <- 0
  lowerleft.sum <- 0
  lowerright.sum <- 0
  body.sum <- 0
  
  # This code block calculates the mean of the x and y coordinates for each body part over a 12-frame window.
  # It then calculates the twitch for each body part using the mean coordinates and the coordinates for each frame in the window.
  # The twitch is the Euclidean distance between the body part's coordinates in a frame and the mean coordinates for that body part.
  # The code then sums the twitch for each body part over the 12-frame window and stores the result in a vector.
  # The code repeats this process for each 12-frame window in the dataset.
  # Finally, the code binds the twitch vectors for each body part into a matrix and stores it in twitch.frame.
  
  for(j in i:(i+11)){
    upperleft.twitch[j] <- upperleft(ab_x[j], ab_y[j], ab_x_mean, ab_y_mean, left_knee_x[j], left_knee_y[j], left_knee_x_mean, left_knee_y_mean)
    upperleft.sum <- upperleft.sum + upperleft.twitch[j]
    
    upperright.twitch[j]<- upperright(ab_x[j], ab_y[j], ab_x_mean, ab_y_mean, right_knee_x[j], right_knee_y[j],
                                      right_knee_x_mean, right_knee_y_mean) 
    upperright.sum <- upperright.sum + upperright.twitch[j]
    
    lowerleft.twitch[j] <- lowerleft(left_knee_x[j], left_knee_y[j], left_knee_x_mean, left_knee_y_mean,
                                     left_foot_x[j], left_foot_y[j], left_foot_x_mean, left_foot_y_mean)
    lowerleft.sum <- lowerleft.sum + lowerleft.twitch[j]
    
    lowerright.twitch[j] <-lowerright(right_knee_x[j], right_knee_y[j], right_knee_x_mean, right_knee_y_mean,
                                      right_foot_x[j], right_foot_y[j], right_foot_x_mean, right_foot_y_mean)
    lowerright.sum <- lowerright.sum + lowerright.twitch[j]
    
    body.twitch[j] <- body(ab_x[j], ab_y[j], ab_x_mean, ab_y_mean, wax_x[j], wax_y[j])
    body.sum <- body.sum + body.twitch[j]
    
    grand.twitch[j] <- upperleft.twitch[j] + upperright.twitch[j] + lowerleft.twitch[j] + lowerright.twitch[j] + body.twitch[j]
  }
  
  
  upperleftshot.twitch <- c(upperleftshot.twitch, upperleft.sum)
  upperrightshot.twitch <- c(upperrightshot.twitch, upperright.sum)
  lowerleftshot.twitch <- c(lowerleftshot.twitch, lowerleft.sum)
  lowerrightshot.twitch <- c(lowerrightshot.twitch, lowerright.sum)
  bodyshot.twitch <- c(bodyshot.twitch, body.sum)
  
  avg.sum <- upperleft.sum + upperright.sum + lowerleft.sum + lowerright.sum + body.sum
  average.twitch <- c(average.twitch, avg.sum)
}
twitch.frame <- cbind(body.twitch, upperleft.twitch, lowerleft.twitch, upperright.twitch, lowerright.twitch)



k <- round(T/27,0) # number of crickets per sequence
len <- length(seq(0, T, k))
index <- seq(0, T, k)
viz_a_x <- matrix(0, nrow=14, ncol=len)
viz_a_y <- matrix(0, nrow=14,ncol=len)

viz_w_x <- matrix(0, nrow=14, ncol=len)
viz_w_y <- matrix(0, nrow=14, ncol=len)

viz_ul_x <- matrix(0, nrow=14, ncol=len)
viz_ul_y <- matrix(0, nrow=14, ncol=len)

viz_ll_x <- matrix(0, nrow=14, ncol=len)
viz_ll_y <- matrix(0, nrow=14, ncol=len)

viz_ur_x <- matrix(0, nrow=14, ncol=len)
viz_ur_y <- matrix(0, nrow=14, ncol=len)

viz_lr_x <- matrix(0, nrow=14, ncol =len)
viz_lr_y <- matrix(0, nrow=14, ncol=len)

for (s in 1:len) {
  i <- index[s] 
  
  if (i > 0){ 
    for(j in 1:13){
      viz_w_x[j,s] <- wax_x[i + (j-7)] - wax_x[i +(j-7)] + i
      viz_w_y[j,s] <- -wax_y[i+(j-7)]
      
      viz_a_x[j,s] <-  ab_x[i+(j-7)] - wax_x[i+(j-7)] + i
      viz_a_y[j,s] <- -ab_y[i+(j-7)]
      
      viz_ul_x[j,s] <-  left_knee_x[i+(j-7)] - wax_x[i+(j-7)] + i
      viz_ul_y[j,s] <- -left_knee_y[i+(j-7)]
      
      viz_ur_x[j,s] <-  right_knee_x[i+(j-7)] - wax_x[i+(j-7)] + i
      viz_ur_y[j,s] <- -right_knee_y[i+(j-7)]
      
      viz_lr_x[j,s] <-  right_foot_x[i+(j-7)] - wax_x[i+(j-7)] + i
      viz_lr_y[j,s] <- -right_foot_y[i+(j-7)]
      
      viz_ll_x[j,s] <-  left_foot_x[i+(j-7)] - wax_x[i+(j-7)] + i
      viz_ll_y[j,s] <- -left_foot_y[i +(j-7)]
    }
  } else{
    viz_w_x[,s] <- wax_x[1] - wax_x[1] + i
    viz_w_y[,s] <- -wax_y[1]
    
    viz_a_x[,s] <-  ab_x[1] - wax_x[1] + i
    viz_a_y[,s] <- -ab_y[1]
    
    viz_ul_x[,s] <-  left_knee_x[1] - wax_x[1] + i
    viz_ul_y[,s] <- -left_knee_y[1]
    
    viz_ur_x[,s] <-  right_knee_x[1] - wax_x[1] + i
    viz_ur_y[,s] <- -right_knee_y[1]
    
    viz_lr_x[,s] <-  right_foot_x[1] - wax_x[1] + i
    viz_lr_y[,s] <- -right_foot_y[1]
    
    viz_ll_x[,s] <-  left_foot_x[1] - wax_x[1] + i
    viz_ll_y[,s] <- -left_foot_y[1]
  }
  
  for(l in 1:len){
    viz_w_x[14,l] <- mean(viz_w_x[(1:13),l])
    viz_w_y[14,l] <- mean(viz_w_y[(1:13),l])
    
    viz_a_x[14,l] <-  mean(viz_a_x[(1:13),l])
    viz_a_y[14,l] <- mean(viz_a_y[(1:13),l])
    
    viz_ul_x[14,l] <-  mean(viz_ul_x[(1:13),l])
    viz_ul_y[14,l] <- mean(viz_ul_y[(1:13),l])
    
    viz_ur_x[14,l] <- mean(viz_ur_x[(1:13),l])
    viz_ur_y[14,l] <- mean(viz_ur_y[(1:13),l])
    
    viz_lr_x[14,l] <-  mean(viz_lr_x[(1:13),l])
    viz_lr_y[14,l] <- mean(viz_lr_y[(1:13),l])
    
    viz_ll_x[14,l] <-  mean(viz_ll_x[(1:13),l])
    viz_ll_y[14,l] <- mean(viz_ll_y[(1:13),l])
  }
}

## Convert sound from DLC coordinates into dB
ss_x_db <- scale.sound(ss_x, minimum_sound, maximum_sound)
#print(ss_x_db)
frame.db = rep(0, T)
#print(frame.db)

# end the script early because it is flawed. 
return()
