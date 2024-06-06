lag <- 1000
par(mfrow=c(1,4))
data.set <- rep(list(),4)
for(j in 1:1)
{
	data.set[[j]] <- read.table("/Users/chan/summer2023/DLC-guide-for-Bowdoin-College/single_cricket_processed_data_it8/210819S11F1 at 2021-09-10 11-53-42 stim 01 .csv",header=TRUE,sep=",")

	colnames(data.set[[j]]) <- c("Frame","Angle","Right","Left")
	attach(data.set[[j]])

	plot(data.set[[j]]$Angle,type='l')
	acf(Angle,lag)
	acf(Right,lag)
	acf(Left,lag)

	
	N.set <- dim(data.set[[1]])[1]-lag
	cors <- array(0,dim=c(N.set,3))
	for(j in 1:N.set)
	{	
		s <- j:(j+lag)
	#	cors[j,1] <- cor(Angle[s],Right[s])
	#	cors[j,2] <- cor(Angle[s],Left[s])
	#	cors[j,3] <- cor(Right[s],Left[s])
	}

	ss <- seq(0,1,length.out=N.set)
	#plot(cors[,1],cors[,2],col=rgb(ss,0.1,1-ss),pch=20,xlim=c(-0.9,0.9),ylim=c(-0.9,0.9))
}
