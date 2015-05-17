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

