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
