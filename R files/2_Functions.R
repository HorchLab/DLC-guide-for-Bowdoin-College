## 2_Functions.R: defines functions needed. Used with Master.R

#' Pick's Theorem: the underlying area calculation formula used in this pipeline
#'
#' @param vector1: a vector
#' @param vector2: a vector
#' @return: the area of the polygon formed by the two vectors
picks_theorem <- function(vector1, vector2) {
  sum1 <- 0
  for (i in 1:(length(vector1) - 1)) {
    sum1 <- sum1 + (vector1[i] * vector2[i + 1])
  }
  sum2 <- 0
  for (i in 1:(length(vector2) - 1)) {
    sum2 <- sum2 + (vector2[i] * vector1[i + 1])
  }
  product <- abs(0.5 * (sum1 - sum2))
  return(product)
}

## Area calculation formulas: the following are a series of formulae used to
## calculate the area of various ROIs on the crickets

# upper left area, based on thorax info
upperleft <- function(thorax_x, thorax_y, thorax_x_mean, thorax_y_mean,
                      lk_x, lk_y, lk_x_mean, lk_y_mean) {
  slope_avg <- (lk_y_mean - thorax_y_mean) / (lk_x_mean - thorax_x_mean)
  slope_0 <- (lk_y - thorax_y) / (lk_x - thorax_x)

  intercept_avg <- lk_y_mean - (slope_avg * lk_x_mean)
  intercept_0 <- lk_y - (slope_0 * lk_x)

  x_intersect <- (intercept_0 - intercept_avg) / (slope_avg - slope_0)
  y_intersect <- (slope_avg * x_intersect) + intercept_avg

  # This decides which state of the cricket (average or present) is higher up
  # on the y-axis. The "bigger" state is the one that is higher up on the
  # y-axis.
  if (lk_y < lk_y_mean) {
    bigger_k_y <- lk_y_mean
    bigger_k_x <- lk_x_mean
    smaller_k_x <- lk_x
    smaller_k_y <- lk_y

    bigger_t_x <- thorax_x_mean
    bigger_t_y <- thorax_y_mean
    smaller_t_x <- thorax_x
    smaller_t_y <- thorax_y
  } else {
    bigger_k_x <- lk_x
    bigger_k_y <- lk_y
    smaller_k_x <- lk_x_mean
    smaller_k_y <- lk_y_mean

    bigger_t_x <- thorax_x
    bigger_t_y <- thorax_y
    smaller_t_x <- thorax_x_mean
    smaller_t_y <- thorax_y_mean
  }

  if ((smaller_k_x < x_intersect) && (x_intersect < smaller_t_x)) {
    if ((smaller_t_y < y_intersect) && (y_intersect < smaller_k_y)) {
      triangle1_vector1 <- c(smaller_t_x, bigger_t_x, x_intersect, smaller_t_x)
      triangle1_vector2 <- c(smaller_t_y, bigger_t_y, y_intersect, smaller_t_y)
      triangle2_vector1 <- c(x_intersect, smaller_k_x, bigger_k_x, x_intersect)
      triangle2_vector2 <- c(y_intersect, smaller_k_y, bigger_k_y, y_intersect)

      area <- picks_theorem(triangle1_vector1, triangle1_vector2) + picks_theorem(triangle2_vector1, triangle2_vector2)
      return(area)
    } else {
      vector1 <- c(smaller_t_x, bigger_t_x, bigger_k_x, smaller_k_x, smaller_t_x)
      vector2 <- c(smaller_t_y, bigger_t_y, bigger_k_y, smaller_k_y, smaller_t_y)
      area <- picks_theorem(vector1, vector2)
      return(area)
    }
  } else {
    vector1 <- c(smaller_t_x, bigger_t_x, bigger_k_x, smaller_k_x, smaller_t_x)
    vector2 <- c(smaller_t_y, bigger_t_y, bigger_k_y, smaller_k_y, smaller_t_y)
    area <- picks_theorem(vector1, vector2)
    return(area)
  }
}

upperright <- function(thorax_x, thorax_y, thorax_x_mean, thorax_y_mean, # same as above, but right
                       lk_x, lk_y, lk_x_mean, lk_y_mean){
  slope_avg <- (lk_y_mean - thorax_y_mean)/(lk_x_mean - thorax_x_mean)
  slope_0 <- (lk_y - thorax_y)/(lk_x - thorax_x)
  
  intercept_avg <- lk_y_mean - (slope_avg * lk_x_mean)
  intercept_0 <- lk_y - (slope_0 * lk_x)
  
  x_intersect <- (intercept_0 - intercept_avg)/(slope_avg - slope_0)
  y_intersect <- (slope_avg * x_intersect) + intercept_avg
  
  
  #This decides which cricket is higher up
  bigger_k_x <- lk_x
  bigger_k_y <- lk_y
  smaller_k_x <- lk_x_mean
  smaller_k_y <- lk_y_mean
  
  bigger_t_x <- thorax_x
  bigger_t_y <- thorax_y
  smaller_t_x <- thorax_x_mean
  smaller_t_y <- thorax_y_mean
  
  if(lk_y < lk_y_mean){
    bigger_k_y <- lk_y_mean
    bigger_k_x <- lk_x_mean
    smaller_k_x <- lk_x
    smaller_k_y <- lk_y
    
    bigger_t_x <- thorax_x_mean
    bigger_t_y <- thorax_y_mean
    smaller_t_x <- thorax_x
    smaller_t_y <- thorax_y
  }
  
  if(    (smaller_k_x > x_intersect) & (x_intersect > smaller_t_x)){
    if( (smaller_t_y < y_intersect) & (y_intersect < smaller_k_y)){
      triangle1_vector1 <- c(smaller_t_x, bigger_t_x, x_intersect, smaller_t_x)
      triangle1_vector2 <- c(smaller_t_y, bigger_t_y, y_intersect, smaller_t_y)
      triangle2_vector1 <- c(x_intersect, smaller_k_x, bigger_k_x, x_intersect)
      triangle2_vector2 <- c(y_intersect, smaller_k_y, bigger_k_y, y_intersect)
      
      area <- picks_theorem(triangle1_vector1, triangle1_vector2) + picks_theorem(triangle2_vector1, triangle2_vector2)
      return(area)
    }  else{
      vector1 <- c(smaller_t_x, bigger_t_x, bigger_k_x, smaller_k_x, smaller_t_x)
      vector2 <- c(smaller_t_y, bigger_t_y, bigger_k_y, smaller_k_y, smaller_t_y)
      area <- picks_theorem(vector1, vector2)
      return(area)}
  }
  else{
    vector1 <- c(smaller_t_x, bigger_t_x, bigger_k_x, smaller_k_x, smaller_t_x)
    vector2 <- c(smaller_t_y, bigger_t_y, bigger_k_y, smaller_k_y, smaller_t_y)
    area <- picks_theorem(vector1, vector2)
    return(area)
  }
  
}

body <- function(thorax_x, thorax_y, thorax_x_mean, thorax_y_mean, # main body area, uses thorax and wax dot info
                 wax_x, wax_y){
  vector1 <- c(thorax_x, thorax_x_mean, wax_x, thorax_x)
  vector2 <- c(thorax_y, thorax_y_mean, wax_y, thorax_y)
  area <- picks_theorem(vector1, vector2)
  return(area)
}

lowerleft <- function(lk_x, lk_y, lk_x_mean, lk_y_mean, # lower left area
                      lf_x, lf_y, lf_x_mean, lf_y_mean){
  slope_avg <- (lf_y_mean - lk_y_mean)/(lf_x_mean - lk_x_mean)
  slope_0 <- (lf_y - lk_y)/(lf_x - lk_x)
  
  intercept_avg <- lf_y_mean - (slope_avg * lf_x_mean)
  intercept_0 <- lf_y - (slope_0 * lf_x)
  
  x_intersect <- (intercept_0 - intercept_avg)/(slope_avg - slope_0)
  y_intersect <- (slope_avg * x_intersect) + intercept_avg
  
  
  #This decides which cricket is higher up
  bigger_f_x <- lf_x
  bigger_f_y <- lf_y
  smaller_f_x <- lf_x_mean
  smaller_f_y <- lf_y_mean
  
  bigger_k_x <- lk_x
  bigger_k_y <- lk_y
  smaller_k_x <- lk_x_mean
  smaller_k_y <- lk_y_mean
  
  if(lk_x < lk_x_mean){
    bigger_k_y <- lk_y_mean
    bigger_k_x <- lk_x_mean
    smaller_k_x <- lk_x
    smaller_k_y <- lk_y
    
    bigger_t_x <- thorax_x_mean
    bigger_t_y <- thorax_y_mean
    smaller_t_x <- thorax_x
    smaller_t_y <- thorax_y
  }
  
  if(    (smaller_k_x < x_intersect) & (x_intersect < smaller_f_x)){
    if( (smaller_f_y < y_intersect) & (y_intersect < smaller_k_y)){
      triangle1_vector1 <- c(smaller_k_x, bigger_k_x, x_intersect, smaller_k_x)
      triangle1_vector2 <- c(smaller_k_y, bigger_k_y, y_intersect, smaller_k_y)
      triangle2_vector1 <- c(x_intersect, smaller_f_x, bigger_f_x, x_intersect)
      triangle2_vector2 <- c(y_intersect, smaller_f_y, bigger_f_y, y_intersect)
      
      area <- picks_theorem(triangle1_vector1, triangle1_vector2) + picks_theorem(triangle2_vector1, triangle2_vector2)
      return(area)
    }  else{
      vector1 <- c(smaller_k_x, bigger_k_x, bigger_f_x, smaller_f_x, smaller_k_x)
      vector2 <- c(smaller_k_y, bigger_k_y, bigger_f_y, smaller_f_y, smaller_k_y)
      area <- picks_theorem(vector1, vector2)
      return(area)}
  }
  else{
    vector1 <- c(smaller_k_x, bigger_k_x, bigger_f_x, smaller_f_x, smaller_k_x)
    vector2 <- c(smaller_k_y, bigger_k_y, bigger_f_y, smaller_f_y, smaller_k_y)
    area <- picks_theorem(vector1, vector2)
    return(area)
  }
}

lowerright <- function(lk_x, lk_y, lk_x_mean, lk_y_mean, # lower right area
                       lf_x, lf_y, lf_x_mean, lf_y_mean){
  slope_avg <- (lf_y_mean - lk_y_mean)/(lf_x_mean - lk_x_mean)
  slope_0 <- (lf_y - lk_y)/(lf_x - lk_x)
  
  intercept_avg <- lf_y_mean - (slope_avg * lf_x_mean)
  intercept_0 <- lf_y - (slope_0 * lf_x)
  
  x_intersect <- (intercept_0 - intercept_avg)/(slope_avg - slope_0)
  y_intersect <- (slope_avg * x_intersect) + intercept_avg
  
  
  #This decides which cricket is higher up
  bigger_f_x <- lf_x
  bigger_f_y <- lf_y
  smaller_f_x <- lf_x_mean
  smaller_f_y <- lf_y_mean
  
  bigger_k_x <- lk_x
  bigger_k_y <- lk_y
  smaller_k_x <- lk_x_mean
  smaller_k_y <- lk_y_mean
  
  if(lk_x < lk_x_mean){
    bigger_k_y <- lk_y_mean
    bigger_k_x <- lk_x_mean
    smaller_k_x <- lk_x
    smaller_k_y <- lk_y
    
    bigger_t_x <- thorax_x_mean
    bigger_t_y <- thorax_y_mean
    smaller_t_x <- thorax_x
    smaller_t_y <- thorax_y
  }
  
  if(    (smaller_k_x < x_intersect) & (x_intersect < smaller_f_x)){
    if( (smaller_f_y < y_intersect) & (y_intersect < smaller_k_y)){
      triangle1_vector1 <- c(smaller_k_x, bigger_k_x, x_intersect, smaller_k_x)
      triangle1_vector2 <- c(smaller_k_y, bigger_k_y, y_intersect, smaller_k_y)
      triangle2_vector1 <- c(x_intersect, smaller_f_x, bigger_f_x, x_intersect)
      triangle2_vector2 <- c(y_intersect, smaller_f_y, bigger_f_y, y_intersect)
      
      area <- picks_theorem(triangle1_vector1, triangle1_vector2) + picks_theorem(triangle2_vector1, triangle2_vector2)
      return(area)
    }  else{
      vector1 <- c(smaller_k_x, bigger_k_x, bigger_f_x, smaller_f_x, smaller_k_x)
      vector2 <- c(smaller_k_y, bigger_k_y, bigger_f_y, smaller_f_y, smaller_k_y)
      area <- picks_theorem(vector1, vector2)
      return(area)}
  }
  else{
    vector1 <- c(smaller_k_x, bigger_k_x, bigger_f_x, smaller_f_x, smaller_k_x)
    vector2 <- c(smaller_k_y, bigger_k_y, bigger_f_y, smaller_f_y, smaller_k_y)
    area <- picks_theorem(vector1, vector2)
    return(area)
  }
}

## Graphical functions

scale.sound <- function(dlc_x, min_db=0, max_db){ # converts sound units from DLC to dB
  # IN: vector of unconverted x-coordinates from DLC representing sound volume; minimum dB value in experiment; maximum dB value in experiment
  # OUT: vector of scaled x-coordinates in dB units
  base_dlc <- min(dlc_x) # DLC coordinate value corresponding to smallest dB value
  apex_dlc <- max(dlc_x) # DLC coordinate value corresponding to greatest dB value
  sf <- (max_db - min_db)/(apex_dlc - base_dlc) # calculate the scale factor
  db_x <- (dlc_x-base_dlc)*sf + min_db # converts into decibels
  #print(db_x)
  return(db_x)
}

position.label <- function(xvals, yvals, pos.vec){ # finds coordinates for letter label in figure
  # IN: various xvals
  xlims <- range(xvals, na.rm=TRUE)
  xcoord <- xlims[1] + (xlims[2] - xlims[1])*pos.vec[1]
  
  ylims <- range(yvals, na.rm=TRUE)
  ycoord <- ylims[1] + (ylims[2] - ylims[1])*pos.vec[2]
  
  return(c(xcoord, ycoord))
}

## Misc functions
dist.func <- function(x1,y1,x2,y2) # calculates Euclidean distance between two vectors
{
  sqrt((x2-x1)^2 + (y2-y1)^2) 
}
