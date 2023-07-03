# 4_Calculator.R: performs calculations and visualization routine given a 
# file name. Used with 1_Master.R

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

# This part of the code is simplified in further iterations of the code. 
frame_nums = rep(0, frame_len)
for (i in 1:frame_len) {
  frame_nums[i] = i
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
shots <- seq(0, T, num.frames)


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

# end the script early because it is flawed. 
return()
