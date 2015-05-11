Begin <- function(){
  #import data from csv:
  portfolio <<- data.frame(read.csv("/Users/don/Desktop/BTC/portfolio.csv", header=TRUE, stringsAsFactors=FALSE))
  cat("portfolio.csv imported as portfolio data frame.\n")
  
  #generate basic total calculations.
  op <<- sum(as.numeric(portfolio$pos)) # = overall position
  oi <<- sum(as.numeric(portfolio$pos)*as.numeric(portfolio$price)) # = overall investment
  pb <<- oi/op # = price basis
  cat("Overall variables created: op, oi, pb.\n")
  
  #Generate Time Series
  #common variables for mo_xxx time series:
  mos <- length(seq(from=as.Date("2013-11-01"), to=Sys.Date(), by='month')) - 1
  mo_vec <- seq(as.Date("2013-12-01"), by = "month", length.out = mos)
  #Declare Time Series' using length determined above:
  mo_investment <<- ts(rep(0, times = mos), frequency = 12, start=c(2013,11))
  mo_position <<- ts(rep(0, times = mos), frequency = 12, start=c(2013,11))
  mo_pricebasis <<- ts(rep(0, times = mos), frequency = 12, start=c(2013,11))
  #Now determine their values with a single for loop:
  for (i in 1:mos){
    port_sub <- subset(portfolio, date < mo_vec[i])
    mo_investment[i] <<- sum(as.numeric(port_sub$pos)*as.numeric(port_sub$price))
    mo_position[i] <<- sum(as.numeric(port_sub$pos))
    mo_pricebasis[i] <<- mo_investment[i] / mo_position[i]
  }
  cat("Time Series created: mo_investment, mo_position, mo_pricebasis.\n")
  
  cat("Workspace Prepared. Welcome.")
}
Begin()

#example of adding a row to portfolio:
newvec <- c("12/8/13",0.0433,806.70)
portfolio <- rbind(portfolio,newvec)

#save portfolio:
write.csv(portfolio, file = "/Users/don/Desktop/BTC/portfolio.csv", row.names=FALSE)

#fix data types in portfolio:
p_dates <- as.Date(portfolio[,1], "%m/%d/%y")

#create mo_portfolio:
#structured as Mo - Investment - Position - Price Basis. Save as csv.

