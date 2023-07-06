# 5_Grapher_Fixed_Anchor.R Used with 1_Master

source("R files/utils.R")
setwd(output_directory)
if (is.null(output_name)) {
  # generates the output name file according to preference specified in
  # 1_Master.R
  output_name_pdf <- paste(file_name, "_graphs.pdf", sep = "")
} else {
  output_name_pdf <- paste(output_name, ".pdf", sep = "")
}


pdf(output_name_pdf, width = 30, height = 20)
par(mfrow = c(4, 1), mar = c(0.5, 7, 0.5, 0.5), oma = c(10, 2, 4, 10),
    cex.lab = 1.5, cex.axis = 1.5)

## POSITION GRAPH
{
par(mar = c(0.5, 9, 5, 0.5))
plot(viz_a_x[14,],viz_a_y[14,], xlab = '', ylab='', ylim=c(-750,-90), col = "black",pch = 16,axes=FALSE, xaxt = 'n')
points(viz_w_x[14,],viz_w_y[14,], xlim = c(0, frame_len), ylim=c(-800,-100), col = "blue",pch = 16,cex=3)
points(viz_ul_x[14,],viz_ul_y[14,],col = "lime green",pch = 16,cex=3)
points(viz_ll_x[14,],viz_ll_y[14,],col = "gold2",pch = 16,cex=3)
points(viz_ur_x[14,],viz_ur_y[14,],col = "darkorange2",pch = 16,cex=3)
points(viz_lr_x[14,],viz_lr_y[14,],col = "red3",pch = 16,cex=3)
box()
position_lab_coords <- position.label( viz_a_x[14,], c(-700,-100), c(-0.02, 0.1) )
text(x=position_lab_coords[1], y=position_lab_coords[2], label="(A)",cex=5)
mtext(side=3,convert_to_title(file_name), line=4,cex=2.5, font=2)
mtext(side=2,"Mean Position", line=4,cex=2.5, font=12)
for(j in 1:len)
{
  segments(viz_a_x[14,j], viz_a_y[14,j], viz_w_x[14,j],  viz_w_y[14,j], col = "grey", lwd = 4)
  segments(viz_a_x[14,j], viz_a_y[14,j], viz_ul_x[14,j], viz_ul_y[14,j], col = "grey", lwd = 4)
  segments(viz_a_x[14,j], viz_a_y[14,j], viz_ur_x[14,j], viz_ur_y[14,j], col = "grey", lwd = 4)
  segments(viz_ul_x[14,j], viz_ul_y[14,j], viz_ll_x[14,j], viz_ll_y[14,j], col = "grey", lwd = 4)
  segments(viz_ur_x[14,j], viz_ur_y[14,j], viz_lr_x[14,j], viz_lr_y[14,j], col = "grey", lwd = 4)
}
}
## TWITCH GRAPH
{
par(mar=c(0.5,9,0.5,0.5))
old.shots <- shots
if (length(shots) != length(lowerrightshot.twitch)) {
  shots = shots[1:length(lowerrightshot.twitch)]
}

plot(shots,lowerrightshot.twitch, type = "l", xlab = "", ylab = "",  ylim=c(-100,21000), lwd = 4, col = rgb(205/255, 0, 0, 0.6),axes=FALSE)
points(shots,bodyshot.twitch, type = "l", col = rgb(0, 0, 1, 0.6), lwd = 4)
points(shots,lowerleftshot.twitch, type = "l", xlab = "", ylab = "Lower Left Twitch", col = rgb(238/255, 201/255, 0, 0.6), lwd = 4)
points(shots,upperrightshot.twitch, type = "l", xlab = "", ylab = "Upper Right Twitch", col = rgb(238/255, 118/255, 0, 0.6), lwd = 4)
points(shots,upperleftshot.twitch , type = "l", xlab = "", ylab = "Upper Left Twitch", col = rgb(50/255, 205/255, 50/255, 0.6), lwd = 4)
twitch_lab_coords <- position.label(shots, lowerrightshot.twitch, c(-0.02, 0.1) )
text(x=twitch_lab_coords[1],y=twitch_lab_coords[2],label="(B)",cex=5)
box()
mtext(side=2,expression(paste("Variation (",mm^2,")",sep="")), line=4,cex=2.5)
axis(2,at=c(0,5000,10000,15000,20000,25000,30000,60000),labels=c(0,50,100,150,200,250,300,600),cex.axis=2.5)
}
## ANGLE GRAPH
shots <- old.shots
par(mar=c(0.5,9,0.5,0.5))
plot(shots, average_angle_per_shot, type = "l", xlab = "",ylab = "", col = "mediumorchid4", lwd = 2,axes=FALSE)
mtext(side=2,expression(paste("Angle (degrees)",sep="")), line=4,cex=2.5)
angle_lab_coords <- position.label( shots, average_angle_per_shot, c(-0.02, 0.1) )
text(x=angle_lab_coords[1],y=angle_lab_coords[2],label="(C)",cex=5)
box()
angle_range <- round(range(average_angle_per_shot, na.rm=TRUE), 0)
axis(2, at=seq(angle_range[1],angle_range[2], by=2), cex.axis=2.5)

## SOUND GRAPH
## Determines sidedness of sound stimulus


cols <- rep("lightgrey", length(ss_x_db))
light.green <- rgb(0.1,0.9,0.1,0.5)
light.red <- rgb(0.9,0.1,0.1,0.5)
sidedness_cutoff <- mean(range(ss_y))
for(i in 1:frame_len){
  if( ss_x_db[i] > 3){ # if nonzero sound, assign side
    if(ss_y[i] < sidedness_cutoff){ # right on bottom
      cols[i] <- light.green
    } else { # left on top
      cols[i] <- light.red
    }
  }
}

if(file_name_csv == "191009_190708_ALT.test.file_csv"){ ## this was used back when the decibel measurements weren't working properly: ignore it, don't delete it.
  ## BANDAID FIX FOR THE DECIBEL ISSUE
  # 5,5 | 4,5 | 5,5 | 5,5 | 5,5 | 5,5 | 5,5 | 5,5 | 5,4
  ud <- c(5,5,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4)
  out <- rep(0,0)
  
  for(r in 1:length(ud))
  {
    if (r%%2 ==1)
    {
      out <- c(out,rep(1,ud[r])) 
    }else
    {
      out <- c(out,rep(2,ud[r])) 
    }
  }
  
  counter <- 0
  for(j in 2:(length(ss_x)-1))
  {
    if ((ss_x[j]>0)&(ss_x[j-1]==0))
    {
      counter <- counter +1
    }
    if (ss_x[j]>0)
    {
      if(out[counter]==1)
      {
        cols[j] <- light.red
      }else
      {
        cols[j] <- light.green
      }
    }
  }
  
  par(mar=c(5,7,0.5,0.5))
  plot(1:frame_len,ss_x,  type = "h", xlab = "", ylab = "",pch=20, col = cols,axes=FALSE,ylim=c(0,100),cex=3,yaxs='i')
  axis(1,labels=TRUE,cex.axis=3,line=1,tick=FALSE)
  mtext(side=2,"Sound (dB)",line=4,cex=3)
  mtext(side=1,"Frame",line=4,cex=3)
  axis(2,labels=c(30,60,90),at=c(30,60,90),cex.axis=2.5)
  legend(x="topleft",legend=c("L","R"),title="Side",col=c(light.red,light.green),cex=5,pch=20)
  text(x=(-85),y=(10),label="(D)",cex=5)
  box()
} else{
  par(mar=c(5,9,0.5,0.5))
  # plot(1:frame_len, ss_x_db, type='l', lwd=4, col = "seagreen",
  #      xlab = "", ylab = "", axes=FALSE, ylim=c(minimum_sound,maximum_sound*1.1), cex=3, yaxs='i')
  #print(ss_x_db)
  plot(1:frame_len, ss_x_db, type='h', lwd=1, pch=20, col =cols,
       xlab = "", ylab = "", axes=TRUE, ylim=c(minimum_sound,maximum_sound*1.1), cex=3, yaxs='i')
  min_frame = 0
  max_frame = frame_len
  axis(1,labels=TRUE,cex.axis=0.5,
       at = seq(min_frame, max_frame, by=15),
       line=0.5,tick=TRUE)
  mtext(side=2,"Sound (dB)",line=4,cex=2.5)
  mtext(side=1,"Frame",line=8,cex=3)
  axis(2,cex.axis=2.5,
       labels=seq(minimum_sound, maximum_sound,by=tick_mark_interval), 
       at   = seq(minimum_sound, maximum_sound, by=tick_mark_interval))
  #legend(x="topleft", legend=c("L","R"),title="Side",col=c(light.red,light.green),cex=5,pch=20)
  db_lab_coords <- position.label((1:frame_len), ss_x_db, c(-0.02, 0.1) )
  #print(db_lab_coords)
  #print(ss_x_db)
  axis(1, cex.axis=1)
  # if(ss_x_db > 69 && ss_x_db < 75) {
  #   print(ss_x_db)
  #   print(frame_num)
  # }
  text(x=db_lab_coords[1], y=db_lab_coords[2],label="(D)",cex=5)
  box()
}
dev.off()

setwd(primary_directory) # return to main directory