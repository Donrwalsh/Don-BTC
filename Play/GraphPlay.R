#TEST

GraphAT <- function(){
  ts.plot(pmo_high, pmo_low,mo_pricebasis, gpars=list(xlab="Time", ylab="Price", col = c("red", "blue", "black")))
}

#^Works. Does proper data and colors. Labeled Axes as well.

GraphYR <- function(){
  year <- as.numeric(format(Sys.Date(), "%Y"))-1
  mon <- as.numeric(format(Sys.Date(), "%m"))
  YR_high <- window(pmo_high, c(year, mon))
  YR_low <- window(pmo_low, c(year, mon))
  YR_pb <- window(mo_pricebasis, c(year, mon))
  ts.plot(YR_high, YR_low, YR_pb, gpars=list(xlab="Time", ylab="Price", col = c("red", "blue", "black")))
}

#^Works. Data is proper (and rolling) and colors are good too. Axes are labeled, but the Time count is messed up.

Graph <- function(months){
  #verify input:
  if (!is.numeric(months)){
    stop("Invalid entry; Not a number")
  }
  if (months > length(pmo_high)){
    stop("Invalid entry; Too many months - Max is ", length(pmo_high), "\n")
  }
  #generate year & mon:
  year <- as.numeric(format(Sys.Date(), "%Y")) - (floor(months/12))
  mon <- as.numeric(format(Sys.Date(), "%m")) - (months %% 12)
  high <- window(pmo_high, c(year, mon))
  low <- window(pmo_low, c(year, mon))
  if (months > length(mo_pricebasis)){
    pbpb <- mo_pricebasis
  } else {
    pbpb <- window(mo_pricebasis, c(year, mon))
  }
  ts.plot(high, low, pbpb, gpars=list(xlab="Time", ylab="Price", col = c("red", "blue", "black"), axes=F))
  time <- seq(as.Date(Sys.Date()), length.out=months, by = "-1 month")
  time <- as.yearmon(time)
  axis(1, labels = rev(time), at=time(high))
  axis(2)
  box()
}
#Incredibly close. Only oddity is the behavior of the tick marks in longer data sets.



ts.plot(pmo_high, pmo_low,mo_pricebasis, gpars=list(xlab="Time", ylab="Price", col = c("red", "blue", "black"), axes=F))
#Make the label for the bottom axis http://www.statmethods.net/advgraphs/axes.html
#side = 1
#at = ?
#labels = ?
#make a vector that lists of all the yearmon pairs for the period of time determined by (months)
axis(1, labels=time, at=seq(from=2010, by=1, length.out=length(time)) )
time <- seq(as.Date("2010/1/1"), length.out=20,by = "3 months")
