library(zoo)
#Creating Data for the App:
Portfolio <- function(){
  this <- data.frame(read.csv("portfolio.csv", header=TRUE, stringsAsFactors=FALSE))
  this$pos2[1] <- this$pos[1] 
  this$investment[1] <- this$pos[1]*this$price[1]
  this$pricebasis[1] <- this$investment[1]/this$pos[1]
  for (i in 2:nrow(this)){
    this$pos2[i] <- sum(this$pos[1:i])
    this$investment[i] <- this$pos[i]*this$price[i]+this$investment[i-1]
    this$pricebasis[i] <- this$investment[i]/this$pos2[i]
  }
  this$pos <- round(this$pos, digits = 4)
  this$pos2 <- round(this$pos2, digits = 4)
  this$price <- round(this$price, digits = 2)
  this$investment <- round(this$investment, digits=2)
  this$pricebasis <- round(this$pricebasis, digits = 2)
  names(this) <- c("Date", "Event Position", "Event Price", "Total Position", "Investment", "Price Basis")
  return(this) 
}
MO_Portfolio <- function(){
  this <- data.frame(read.csv("portfolio.csv", header=TRUE, stringsAsFactors=FALSE))
  mos <- length(seq(from=as.Date("2013-11-01"), to=Sys.Date(), by='month'))
  mo_vec <- seq(as.Date("2013-12-01"), by = "month", length.out = mos)
  Month <- as.yearmon(seq(as.Date("2013-11-01"), by = "month", length.out = mos))
  Position <- rep(0, length.out = mos)
  Investment <- rep(0, length.out = mos)
  PriceBasis <- rep(0, length.out = mos)
  for (i in 1:mos){
    port_sub <- subset(this, date < mo_vec[i])
    Investment[i] <- sum(as.numeric(port_sub$pos)*as.numeric(port_sub$price))
    Position[i] <- sum(as.numeric(port_sub$pos))
    PriceBasis[i] <- Investment[i]/Position[i]
  }
  this2 <- data.frame(Month, Position, Investment, PriceBasis)
  this2$Position <- round(this2$Position, digits = 2)
  this2$Investment <- round(this2$Investment, digits = 2)
  this2$PriceBasis <- round(this2$PriceBasis, digits = 2)
  names(this2) <- c("Month", "Position", "Investment", "Price Basis")
  return(this2)
}
