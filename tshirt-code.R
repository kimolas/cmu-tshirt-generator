# install.packages("png")
library(png)

scatterfunc <- function(filename="CMU.png", seednum=22, propscreen=0.9,
                        varamt=5, writename=NULL){
  op <- par(no.readonly=TRUE)

  cmu <- readPNG(filename)
  cmuround <- round(cmu, 0)[, , 3]
  set.seed(seednum)
  cmuround <- matrix(1, ncol=length(cmuround[1, ]), 
                     nrow=length(cmuround[, 1])) - cmuround
  
  for(i in 1:length(cmuround[, 1])){
  	for(j in 1:length(cmuround[1, ])){
  		if(cmuround[i, j] == 1){
  			newi <- round(rnorm(1, i, varamt), 0)
  			newj <- round(rnorm(1, j, varamt), 0)
  			if(newi < 0){
  				newi <- 0
  			} else if(newi > length(cmuround[, 1])){
  				newi <- length(cmuround[, 1])
  			}
  			if(newj < 0){
  				newj <- 0
  			} else if(newj > length(cmuround[1, ])){
  				newj <- length(cmuround[1, ])
  			}
  			if(runif(1) > propscreen){
  				cmuround[newi, newj] <- cmuround[i, j]
  			} else{
  				cmuround[newi, newj] <- 0
  			}
  			cmuround[i, j] <- 0
  		}
  	}
  }

  if(!is.null(writename)) {
    writePNG(cmuround, writename)
  }
  
  dat <- data.frame(xx=rep(0,sum(cmuround)), yy=rep(0, sum(cmuround)))
  cc <- rep("firebrick3", sum(cmuround))
  
  pointcount <- 0
  
  for(i in 1:length(cmuround[, 1])){
  	for(j in 1:length(cmuround[1, ])){
  		if(cmuround[i, j]==1){
        pointcount <- pointcount + 1
        dat$xx[pointcount] <- j
        dat$yy[pointcount] <- length(cmuround[, 1]) - i
        # if(j < length(cmuround[1, ])/3){
        #   cc[pointcount] <- "forestgreen"
        # } else if(j < 2*length(cmuround[1, ])/3){
        #   cc[pointcount] <- "dodgerblue4"
        # }
  		}
  	}
  }
  
  par(mar=c(0,0,0,0), bg="transparent")
  plot(dat$xx,dat$yy, cex=1.5, pch=16, axes=FALSE, xlab="", ylab="", type="n",
       bg="transparent")
  #rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = "firebrick")
  points(dat$xx,dat$yy, cex=0.5, pch=19, col="black")
  par(op)
}
