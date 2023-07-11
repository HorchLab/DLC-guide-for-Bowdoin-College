# 4_Calculator.R: performs calculations and visualization routine 
# Used with 1_Master.R
# This is a deprecated version of the calculator. It is not used in the current
# version of the code.

# Some positions of interest
thorax_x_mean <- mean(ab_x)
thorax_y_mean <- mean(ab_y)
frame_len <- length(ab_x) # this is how many frames are in the dataset

# Find the angle between the abdomen and the center line:
a <- dist.func(ab_x,ab_y,wax_x,ab_y)
b <- dist.func(wax_x,wax_y,wax_x,ab_y)
c <- dist.func(ab_x,ab_y,wax_x,wax_y)

angles <- acos((b^2+c^2-a^2)/(2*b*c))*180/pi # angle calculation

# Define center line (wax) as zero; make angles positive or negative deviation from that line:
for (i in 1:frame_len){ 
  if (ab_x[i] <= wax_x[i]){
    angles[i] <- -angles[i] 
  }
}

frame_nums = rep(0, frame_len)
for (i in 1:frame_len) {
  frame_nums[i] = i
  #print(frame_num)
}

# 21 spacings of zero and go until you get to the 26th
# 2775 and 3195
total = 0
frames = 0
avg.turn = 0
T=frame_len # frames in dataset
num.frames <- 12 # shots per frame. set to 12 after discussion and experimentation
angle.frame <- rep(0, frame_len/num.frames) # calculating average angle per shot
for(i in seq(0, T, num.frames)){

  mean(angles[i:i+num.frames-1])
  angle.frame[i/num.frames] <- mean(angles[i:i+num.frames-1])
  #print(avg.turn)
}
#print(avg.turn)

frames <- seq(1:frame_len)
shots <- rep(0, frame_len/num.frames)

for (i in seq(0, T, num.frames)){
  shots[i/num.frames] <- i
}


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


#
for(i in seq(1, T-12,num.frames)){
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



avg.db = 0
frame_num = 0
gap = rep(0, frame_len)
for (i in 1:frame_len) {
  if (ss_x_db[i] > 2) {
    gap[i] = ss_x_db[i]
  }
  mean.db = avg.db/15
  frame_num = frame_num + 15

}
#View(gap)

# 21 spacings of zero and go until you get to the 26th
# 2783 and 3175
# 93 frame gap between them
frame.and.db = data.frame(frame_nums, gap)
avg.turn2=0

# finding the start of the 50 db bursts
gap.num = 0
for(i in seq(0, T, 1)){
  #print(gap.v2[i, 1])
  if (i > num.frames/2) {
    if ((frame.and.db[i, 2] > 0)) {
      start.50 = i
      print(start.50)
      break
    }
  }
}




# finding the end of the 50 db bursts
end.50 = 0
for (j in seq(start.50,T,1)) {
  #print(gap.v2[start,1])
  if ((frame.and.db[j, 2] == 0) & (frame.and.db[j+42, 2] == 0)) {
    end.50 = j
    print(end.50)
    break
  }
}



# finding the starting point of the 55 db bursts
for (i in seq(end.50, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.55 = i
    print(start.55)
    break
  }
}

baseline.55 = mean(angle.frame[((start.55 - 50)/12):((start.55 - 10)/12)])
print(baseline.55)
cat("Baseline turn angle at 55 dB is:", baseline.55, "\n")


# Finding the end of the first burst at 55 dB and computing the maximum turn angle within those frames
end.burst1.55 = 0
for (i in seq(start.55, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst1.55 = i
    #print(end.burst1)
    cat("End burst1 at 55 dB is:", end.burst1.55, "\n")
    break
  }
}

# Finding the max turn angle within the first burst of sound
max.burst1.55 = max(angle.frame[(start.55/12):(end.burst1.55/12)])
cat("Max burst1 at 55 dB is:", max.burst1.55, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst1.55, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst2.55 = i
    cat("Start burst2 at 55 dB is:", start.burst2.55, "\n")
    break
  }
}

# Finding the end of the second burst and computing the maximum turn angle within those frames
end.burst2.55 = 0
for (i in seq(start.burst2.55, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst2.55 = i
    #print(end.burst2)
    cat("End burst2 at 55 dB is:", end.burst2.55, "\n")
    break
  }
}

# Finding the max turn angle within the second burst of sound
max.burst2.55 = max(angle.frame[(start.burst2.55/12):(end.burst2.55/12)])
cat("Max burst2 at 55 dB is:", max.burst2.55, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst2.55, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst3.55 = i
    cat("Start burst3 at 55 dB is:", start.burst3.55, "\n")
    break
  }
}

# Finding the end of the second burst and computing the maximum turn angle within those frames
end.burst3.55 = 0
for (i in seq(start.burst3.55, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst3.55 = i
    #print(end.burst2)
    cat("End burst3 at 55 dB is:", end.burst3.55, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst3.55 = max(angle.frame[(start.burst3.55/12):(end.burst3.55/12)])
cat("Max burst3 at 55 dB is:", max.burst3.55, "\n\n")


# Finding the start of burst 4
for (i in seq(end.burst3.55, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst4.55 = i
    cat("Start burst4 at 55 dB is:", start.burst4.55, "\n")
    break
  }
}

# Finding the end of the fourth burst and computing the maximum turn angle within those frames
end.burst4.55 = 0
for (i in seq(start.burst4.55, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst4.55 = i
    #print(end.burst2)
    cat("End burst4 at 55 dB is:", end.burst4.55, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst4.55 = max(angle.frame[(start.burst4.55/12):(end.burst4.55/12)])
cat("Max burst4 at 55 dB is:", max.burst4.55, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst4.55, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst5.55 = i
    cat("Start burst5 at 55 dB is:", start.burst5.55, "\n")
    break
  }
}

# Finding the end of the fifth burst and computing the maximum turn angle within those frames
end.burst5.55 = 0
for (i in seq(start.burst5.55, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst5.55 = i
    #print(end.burst2)
    cat("End burst5 at 55 dB is:", end.burst5.55, "\n")
    break
  }
}

# # finding the end of the 55 db bursts
# end.55 = 0
# for (i in seq(start.55, T, 1)) {
#   if (frame.and.db[i, 2] == 0 & frame.and.db[i+42, 2] == 0) {
#     end.55 = i
#     print(end.55)
#     break
#   }
# }
# Finding the max turn angle within the third burst of sound
max.burst5.55 = max(angle.frame[(start.burst5.55/12):(end.burst5.55/12)])
cat("Max burst5 at 55 dB is:", max.burst5.55, "\n\n")


turn.angles.55 = c(max.burst1.55, max.burst2.55, max.burst3.55, max.burst4.55, max.burst5.55)
avg.max.burst.55 = mean(turn.angles.55)
cat("Average max turn angle at 55 dB is:", avg.max.burst.55, "\n\n")

# finding the start of the 60 db bursts
for (i in seq(end.burst5.55, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.60 = i
    print(start.60)
    break
  }
}

# finding the end of the 60 db bursts
end.60 = 0
for (i in seq(start.60, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+42, 2] == 0) {
    end.60 = i
    print(end.60)
    break
  }
}


# finding the start of the 65 db bursts
for (i in seq(end.60, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.65 = i
    print(start.65)
    break
  }
}

# finding the end of the 65 db bursts
end.65 = 0
for (i in seq(start.65, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+42, 2] == 0) {
    end.65 = i
    print(end.65)
    break
  }
}

# finding the start of the 70 db bursts
for (i in seq(end.65, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.70 = i
    #print(start.70)
    break
  }
}


# Taking the average turn angle in between the end of 65 db and start of 70 db
# to find the baseline that we will compare to
# This is +/- 10 frames on either end, so we are certain that this is a baseline
baseline.70 = mean(angle.frame[((end.65 + 10)/12):((start.70 - 10)/12)])
cat("Baseline turn angle @ 70dB is:", baseline.70, "\n")
cat("Start burst1 @ 70dB is:", start.70, "\n")

# Finding the difference between our baseline turn angle (taken from the frames before the 
# start of the sound) and the average turn angle at each peak of the sound burst
diff.turn.55 = avg.max.burst.55 - baseline.55
cat("Differential turn angle at 55 dB is:", diff.turn.55, "\n\n")


# Finding the end of the 70 db bursts
end.70 = 0
for (i in seq(start.70, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+42, 2] == 0) {
    end.70 = i
    #print(end.70)
    #cat("Start burst1 is:", , "\n")
    break
  }
}


# Finding the end of the first burst and computing the maximum turn angle within those frames
end.burst1 = 0
for (i in seq(start.70, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst1 = i
    #print(end.burst1)
    cat("End burst1 is:", end.burst1, "\n")
    break
  }
}

# Finding the max turn angle within the first burst of sound
max.burst1 = max(angle.frame[(start.70/12):(end.burst1/12)])
cat("Max burst1 is:", max.burst1, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst1, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst2 = i
    cat("Start burst2 is:", start.burst2, "\n")
    break
  }
}

# Finding the end of the second burst and computing the maximum turn angle within those frames
end.burst2 = 0
for (i in seq(start.burst2, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst2 = i
    #print(end.burst2)
    cat("End burst2 is:", end.burst2, "\n")
    break
  }
}

# Finding the max turn angle within the second burst of sound
max.burst2 = max(angle.frame[(start.burst2/12):(end.burst2/12)])
cat("Max burst2 is:", max.burst2, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst2, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst3 = i
    cat("Start burst3 is:", start.burst3, "\n")
    break
  }
}

# Finding the end of the second burst and computing the maximum turn angle within those frames
end.burst3 = 0
for (i in seq(start.burst3, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst3 = i
    #print(end.burst2)
    cat("End burst3 is:", end.burst3, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst3 = max(angle.frame[(start.burst3/12):(end.burst3/12)])
cat("Max burst3 is:", max.burst3, "\n\n")


# Finding the start of burst 4
for (i in seq(end.burst3, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst4 = i
    cat("Start burst4 is:", start.burst4, "\n")
    break
  }
}

# Finding the end of the fourth burst and computing the maximum turn angle within those frames
end.burst4 = 0
for (i in seq(start.burst4, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst4 = i
    #print(end.burst2)
    cat("End burst4 is:", end.burst4, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst4 = max(angle.frame[(start.burst4/12):(end.burst4/12)])
cat("Max burst4 is:", max.burst4, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst4, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst5 = i
    cat("Start burst5 is:", start.burst5, "\n")
    break
  }
}

# Finding the end of the fifth burst and computing the maximum turn angle within those frames
end.burst5 = 0
for (i in seq(start.burst5, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst5 = i
    #print(end.burst2)
    cat("End burst5 is:", end.burst5, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst5 = max(angle.frame[(start.burst5/12):(end.burst5/12)])
cat("Max burst5 is:", max.burst5, "\n\n")



# finding the start of the 75 db bursts
for (i in seq(end.burst5, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.75 = i
    print(start.75)
    break
  }
}

# finding the end of the 75 db bursts
end.75 = 0
for (i in seq(start.75, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+42, 2] == 0) {
    end.75 = i
    print(end.75)
    break
  }
}

# finding the start of the 80 db bursts
for (i in seq(end.75, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.80 = i
    print(start.80)
    break
  }
}



### START OF THE 80DB LOOPS
###
###
###
###



## Finding the baseline turn angle just before the start of the 80dB range
baseline.80 = mean(angle.frame[((end.75 + 10)/12):((start.80 - 10)/12)])
cat("Baseline turn angle @ 80dB is:", baseline.80, "\n")
cat("Start burst1 @ 80dB is:", start.80, "\n")
# Finding the end of the first burst and computing the maximum turn angle within those frames
end.burst1.80 = 0
for (i in seq(start.80, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst1.80 = i
    #print(end.burst1)
    cat("End burst1 @ 80dB is:", end.burst1.80, "\n")
    break
  }
}

# Finding the max turn angle within the first burst of sound at 80dB
max.burst1.80 = max(angle.frame[(start.80/12):(end.burst1.80/12)])
cat("Max burst1 @ 80dB is:", max.burst1.80, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst1.80, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst2.80 = i
    cat("Start burst2 @ 80dB is:", start.burst2.80, "\n")
    break
  }
}

# Finding the end of the second burst and computing the maximum turn angle within those frames
end.burst2.80 = 0
for (i in seq(start.burst2.80, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst2.80 = i
    #print(end.burst2)
    cat("End burst2 @ 80dB is:", end.burst2.80, "\n")
    break
  }
}

# Finding the max turn angle within the second burst of sound
max.burst2.80 = max(angle.frame[(start.burst2.80/12):(end.burst2.80/12)])
cat("Max burst2 @ 80dB is:", max.burst2.80, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst2.80, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst3.80 = i
    cat("Start burst3 @ 80dB is:", start.burst3.80, "\n")
    break
  }
}

# Finding the end of the second burst and computing the maximum turn angle within those frames
end.burst3.80 = 0
for (i in seq(start.burst3.80, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst3.80 = i
    #print(end.burst2)
    cat("End burst3 @ 80dB is:", end.burst3.80, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst3.80 = max(angle.frame[(start.burst3.80/12):(end.burst3.80/12)])
cat("Max burst3 is:", max.burst3.80, "\n\n")


# Finding the start of burst 4 at 80dB
for (i in seq(end.burst3.80, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst4.80 = i
    cat("Start burst4 @ 80dB is:", start.burst4.80, "\n")
    break
  }
}

# Finding the end of the fourth burst and computing the maximum turn angle within those frames
end.burst4.80 = 0
for (i in seq(start.burst4.80, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst4.80 = i
    #print(end.burst2)
    cat("End burst4 @ 80dB is:", end.burst4.80, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst4.80 = max(angle.frame[(start.burst4.80/12):(end.burst4.80/12)])
cat("Max burst4 @ 80dB is:", max.burst4.80, "\n\n")

# Finding the start of burst 2
for (i in seq(end.burst4.80, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.burst5.80 = i
    cat("Start burst5 @ 80dB is:", start.burst5.80, "\n")
    break
  }
}

# Finding the end of the fifth burst and computing the maximum turn angle within those frames
end.burst5.80 = 0
for (i in seq(start.burst5.80, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
    end.burst5.80 = i
    #print(end.burst2)
    cat("End burst5 @ 80dB is:", end.burst5.80, "\n")
    break
  }
}

# Finding the max turn angle within the third burst of sound
max.burst5.80 = max(angle.frame[(start.burst5.80/12):(end.burst5.80/12)])
cat("Max burst5 @ 80dB is:", max.burst5.80, "\n\n")





### 
###
###
###
### END OF THE 80 DB LOOPS




# finding the start of the 85 db bursts
for (i in seq(end.burst5.80, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.85 = i
    #print(start.85)
    break
  }
}

end.85 = 0
for (i in seq(start.85, T, 1)) {
  if (frame.and.db[i, 2] == 0 & frame.and.db[i+42, 2] == 0) {
    end.85 = i
    #print(end.85)
    break
  }
}

# finding the start of the 90 db bursts
for (i in seq(end.85, T, 1)) {
  if (frame.and.db[i, 2] > 0) {
    start.90 = i
    #print(start.90)
    break
  }
}

### START OF THE 90DB LOOPS
###
###
###
###

# 
# ## Finding the baseline turn angle just before the start of the 80dB range
# baseline.90 = mean(angle.frame[((end.85 + 10)/12):((start.90 - 10)/12)])
# cat("Baseline turn angle @ 90dB is:", baseline.90, "\n")
# cat("Start burst1 @ 90dB is:", start.90, "\n")
# 
# 
# # Finding the end of the first burst and computing the maximum turn angle within those frames
# end.burst1.90 = 0
# for (i in seq(start.90, T, 1)) {
#   if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
#     end.burst1.90 = i
#     #print(end.burst1)
#     cat("End burst1 @ 900dB is:", end.burst1.90, "\n")
#     break
#   }
# }
# 
# # Finding the max turn angle within the first burst of sound at 80dB
# max.burst1.90 = max(angle.frame[(start.90/12):(end.burst1.90/12)])
# cat("Max burst1 @ 90dB is:", max.burst1.90, "\n\n")
# 
# # Finding the start of burst 2 at 90dB
# for (i in seq(end.burst1.90, T, 1)) {
#   if (frame.and.db[i, 2] > 0) {
#     start.burst2.90 = i
#     cat("Start burst2 @ 90dB is:", start.burst2.90, "\n")
#     break
#   }
# }
# 
# # Finding the end of the second burst and computing the maximum turn angle within those frames
# end.burst2.90 = 0
# for (i in seq(start.burst2.90, T, 1)) {
#   if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
#     end.burst2.90 = i
#     #print(end.burst2)
#     cat("End burst2 @ 90dB is:", end.burst2.90, "\n")
#     break
#   }
# }
# 
# # Finding the max turn angle within the second burst of sound
# max.burst2.90 = max(angle.frame[(start.burst2.90/12):(end.burst2.90/12)])
# cat("Max burst2 @ 90dB is:", max.burst2.90, "\n\n")
# 
# # Finding the start of burst 2
# for (i in seq(end.burst2.90, T, 1)) {
#   if (frame.and.db[i, 2] > 0) {
#     start.burst3.90 = i
#     cat("Start burst3 @ 90dB is:", start.burst3.90, "\n")
#     break
#   }
# }
# 
# # Finding the end of the second burst and computing the maximum turn angle within those frames
# end.burst3.90 = 0
# for (i in seq(start.burst3.90, T, 1)) {
#   if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
#     end.burst3.90 = i
#     #print(end.burst2)
#     cat("End burst3 @ 90dB is:", end.burst3.90, "\n")
#     break
#   }
# }
# 
# # Finding the max turn angle within the third burst of sound
# max.burst3.90 = max(angle.frame[(start.burst3.90/12):(end.burst3.90/12)])
# cat("Max burst3 @ 90dB is:", max.burst3.90, "\n\n")
# 
# 
# # Finding the start of burst 4 at 80dB
# for (i in seq(end.burst3.90, T, 1)) {
#   if (frame.and.db[i, 2] > 0) {
#     start.burst4.90 = i
#     cat("Start burst4 @ 90dB is:", start.burst4.90, "\n")
#     break
#   }
# }
# 
# # Finding the end of the fourth burst and computing the maximum turn angle within those frames
# end.burst4.90 = 0
# for (i in seq(start.burst4.90, T, 1)) {
#   if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
#     end.burst4.90 = i
#     #print(end.burst2)
#     cat("End burst4 @ 90dB is:", end.burst4.90, "\n")
#     break
#   }
# }
# 
# # Finding the max turn angle within the third burst of sound
# max.burst4.90 = max(angle.frame[(start.burst4.90/12):(end.burst4.90/12)])
# cat("Max burst4 @ 90dB is:", max.burst4.90, "\n\n")
# 
# # Finding the start of burst 2
# for (i in seq(end.burst4.90, T, 1)) {
#   if (frame.and.db[i, 2] > 0) {
#     start.burst5.90 = i
#     cat("Start burst5 @ 90dB is:", start.burst5.90, "\n")
#     break
#   }
# }
# 
# # Finding the end of the fifth burst and computing the maximum turn angle within those frames
# end.burst5.90 = 0
# for (i in seq(start.burst5.90, T, 1)) {
#   if (frame.and.db[i, 2] == 0 & frame.and.db[i+5, 2] == 0) {
#     end.burst5.90 = i
#     #print(end.burst2)
#     cat("End burst5 @ 90dB is:", end.burst5.90, "\n")
#     break
#   }
# }
# 
# # Finding the max turn angle within the third burst of sound
# max.burst5.90 = max(angle.frame[(start.burst5.90/12):(end.burst5.90/12)])
# cat("Max burst5 @ 90dB is:", max.burst5.90, "\n\n")





###
###
###
###
### END OF THE 90DB LOOPS


# Creating a vector containing our max turn angles at each of the 5 sound bursts, and then
# calculating the mean of those turn angles
turn.angles.70 = c(max.burst1, max.burst2, max.burst3, max.burst4, max.burst5)
avg.max.burst.70 = mean(turn.angles.70)
cat("Average max turn angle @ 70dB is:", avg.max.burst.70, "\n\n")

## Same thing, but at the 80dB level
turn.angles.80 = c(max.burst1.80, max.burst2.80, max.burst3.80, max.burst4.80, max.burst5.80)
avg.max.burst.80 = mean(turn.angles.80)
cat("Average max turn angle @ 80dB is:", avg.max.burst.80, "\n\n")

## Same thing, but at the 90dB level
# turn.angles.90 = c(max.burst1.90, max.burst2.90, max.burst3.90, max.burst4.90, max.burst5.90)
# avg.max.burst.90 = mean(turn.angles.90)
# cat("Average max turn angle @ 90dB is:", avg.max.burst.90, "\n\n")
# 
# avg.turn = mean(angle.frame[(start.70/12):(end.70/12)])
# sd.turn = sd(angle.frame[(start.70/12):(end.70/12)])
# 
# print(avg.turn)
# print(sd.turn)

# Finding the difference between our baseline turn angle (taken from the frames before the 
# start of the sound) and the average turn angle at each peak of the sound burst
diff.turn.70 = avg.max.burst.70 - baseline.70
cat("Differential turn angle @ 70 dB is:", diff.turn.70, "\n\n")

## Calculating Diff.turn at the 80dB level
diff.turn.80 = avg.max.burst.80 - baseline.80
cat("Differential turn angle @ 80 dB is:", diff.turn.80, "\n\n")

## calculating the diff.turn at the 90dB level
# diff.turn.90 = avg.max.burst.90 - baseline.90
# cat("Differential turn angle @ 90 dB is:", diff.turn.90, "\n\n")
#print(file_name_csv)
#results = matrix(nrow = length(stripped_files), ncol = 3)

## Turn ratio of crickets between the 55 dB and 70 dB sound levels
turn.ratio = diff.turn.70 - diff.turn.55
cat("Ratio between 55 dB and 70 dB is:", turn.ratio, "\n")

turn.ratio.80 = diff.turn.80 - diff.turn.70
cat("Ratio between 70 dB and 80 dB is:", turn.ratio.80, "\n")



results[num.files, 1] = file_name_csv
results[num.files, 2] = diff.turn.70
results[num.files, 3] = diff.turn.55
results[num.files, 4] = turn.ratio
results[num.files, 5] = diff.turn.80
results[num.files, 6] = turn.ratio.80
#results[num.files, 6] = diff.turn.90
#results[num.files, 3] = sd.turn
#print(results)



# Export the vector to a CSV file
write.csv(gap, file = "see_gap.csv")

# Export the vector to a tab-separated text file containing the frame numbers
# and when the sounds are played
write.table(frame.and.db, file = "Frame number and dB honors crickets", sep = "\t", row.names = FALSE, col.names = FALSE)
write.table(turn.ratio, file = "Ratio between 50 dB and 70 dB", sep = "\t", row.names = FALSE, col.names = FALSE)




