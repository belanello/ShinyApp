#C:/Users/belan/R/ShinyApp/R/func.R
library(shiny)
library(dplyr)
library(car)

# getDetails function returns the dataframe with 
# class/ number of NA values / [mean / sd / cor](only for quantitative vars)
# for each variable
# 
getDetails <- function(df,target){
  # make empty data.frame of ncols * 1
  ncols <- ncol(df)
  details <- data.frame(varName=rep(0,ncols))
  
  # first column is names of variables
  details$varName <- names(df)
  
  # second column is classes of variables
  details$class <- sapply(df,class)
  
  # third column is the number of NAs
  details$NAs <- as.integer(colSums(is.na(df)))
  
  # calculate mean/sd/cor for numeric variable
  # first, get a logical vector of classes
  numFlag <- (details$class=='numeric')|(details$class=='integer')
  details$mean <- rep(NA,ncols)
  details$sd <- rep(NA,ncols)
  
  # in case there's only one numeric variable
  if(length(numFlag) > 1){
    details$mean[numFlag] <- round(as.numeric(apply(df[,numFlag],2,mean,na.rm=TRUE)),3)
    details$sd[numFlag] <- round(as.numeric(apply(df[,numFlag],2,sd,na.rm=TRUE)),3)
    
  # in case there are more than one numeric variable
  }else if ((length(numFlag)==1)&(numFlag==T)){
    details$mean <- round(as.numeric(mean(df[,1],na.rm=TRUE)),3)
    details$sd <- round(as.numeric(sd(df[,1],na.rm=TRUE)),3)
  }
  # calculate correlation between all the numeric variables and a target variable
  details$cor <- rep(NA,ncols)

  if ((isNumericInteger(df[,target]))&(length(numFlag)>1)){
    cors <- cor(df[,numFlag],df[,numFlag],use='complete.obs')[,target]
    details$cor[numFlag] <- cors
    }
  
  details
}

# newDf() function takes data.frame and a variable name
# returns new data.frame with a target variable changed to factor

newDf <- function(df,target){
  df[,target] <- factor(df[,target])
  df
}

# test a specific column is numeric or integer class
isNumericInteger <- function(x){
  (is.integer(x))|(is.numeric(x))
}

# return histogram
plotHist <- function(df,target,bin){
  df <- na.omit(df)
  hist(df[,target],freq=FALSE,breaks=bin,main=target,xlab='')
  lines(density(df[,target]),lwd=2)
  rug(df[,target])
}

# return y-axis variable names without the x-axis variable 
getY<- function(df,x){
  idx <- which(names(df)==x)
  names(df)[-idx]
}

# return scatter plot
plotXY <- function(df,X, Y){
  if(!isNumericInteger(df[,X])){
    df[, X] <- factor(df[, X])
  }
  df <- na.omit(df)
  title <- paste(X,'vs.',Y)
  scatterplot(df[,X],df[,Y],id=list(n=3),
              main=title,xlab=X,ylab=Y)
}

