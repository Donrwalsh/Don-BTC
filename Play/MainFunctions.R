###COMMAND + ENTER TO RUN THIS, SHINY FUCKED IT UP###
library(jsonlite)
library(zoo)
library(shiny)
library(shinyapps)

#Turn Initiate into Local Initiate, then create one for apps initiate (but w/ better name)

Initiate <- function(){
  #Set Working Directory
  setwd("/Users/don/Desktop/Bitcoin")
  
  #Import Source Data as data frames
  price <<- data.frame(read.csv("bpi_price.csv", header=TRUE, stringsAsFactors=FALSE))
  price$Date <<- as.Date(price[,1], "%Y-%m-%d")
  cat("bpi_price.csv imported as <price.df>; includes data up to",  toString(price[nrow(price),1]), "\n")
  portfolio <<- data.frame(read.csv("/Users/don/Desktop/Bitcoin/portfolio.csv", header=TRUE, stringsAsFactors=FALSE))
  portfolio$date <<- as.Date(portfolio[,1], "%Y-%m-%d")
  cat("portfolio.csv imported as <portfolio.df>\n")
  
  #Generate inv_val data frame
  iv_date <- seq(from = portfolio[1,1], to = price[nrow(price),1], by = "days")
  iv_price <- subset(price, price$Date >= portfolio[1,1])
  iv_pos <- rep(0, length(iv_date))
  iv_inv <- rep(0, length(iv_date))
  for (i in 1:length(iv_date)){
    port_sub <- subset(portfolio, portfolio$date <= iv_date[i])
    iv_pos[i] <- sum(port_sub$pos)
    iv_inv[i] <- sum(port_sub$pos*port_sub$price)
  }
  inv_val <<- data.frame(iv_date, iv_price$Close*iv_pos, iv_inv, (iv_price$Close*iv_pos)/iv_inv)
  names(inv_val) <<- c("Date", "Value", "Investment", "Percent")
  cat("Source Data used to generate <inv_val.df>\n")
  
  #Generate Price Time Series
  pmos <- length(seq(from=as.Date("2010-07-01"), to=Sys.Date(), by='month')) - 1
  pmo_vec <- seq(as.Date("2010-07-01"), by = "month", length.out = pmos)
  #Declare Time Series using length determined above:
  pmo_high <<- ts(rep(0, times = pmos), frequency = 12, start = c(2010,7))
  pmo_low <<- ts(rep(0, times = pmos), frequency = 12, start = c(2010,7))
  #Now determine their values
  for (i in 1:pmos){
    price_sub <- subset(price, format.Date(Date, "%m")==format(pmo_vec[i], "%m") & format.Date(Date, "%y")==format(pmo_vec[i], "%y"))
    pmo_high[i] <<- max(price_sub$Close)
    pmo_low[i] <<- min(price_sub$Close)
  }
  cat("Price Time Series created: <pmo_high.ts>, <pmo_low.ts>\n")
  
  #Generate Time Series
  #common variables for mo_xxx time series:
  mos <- length(seq(from=as.Date("2013-11-01"), to=Sys.Date(), by='month')) - 1
  mo_vec <- seq(as.Date("2013-12-01"), by = "month", length.out = mos)
  #Declare Time Series using length determined above:
  mo_investment <<- ts(rep(0, times = mos), frequency = 12, start=c(2013,11))
  mo_position <<- ts(rep(0, times = mos), frequency = 12, start=c(2013,11))
  mo_pricebasis <<- ts(rep(0, times = mos), frequency = 12, start=c(2013,11))
  #Now determine their values
  for (i in 1:mos){
    port_sub <- subset(portfolio, date < mo_vec[i])
    mo_investment[i] <<- sum(as.numeric(port_sub$pos)*as.numeric(port_sub$price))
    mo_position[i] <<- sum(as.numeric(port_sub$pos))
    mo_pricebasis[i] <<- mo_investment[i] / mo_position[i]
  }
  cat("Time Series created: <mo_investment.ts>, <mo_position.ts>, <mo_pricebasis.ts>\n")
  mo_portfolio <<- data.frame(as.yearmon(mo_vec-1), mo_investment[1:mos], mo_position[1:mos], mo_pricebasis[1:mos])
  names(mo_portfolio) <<- c("Mon","Inv","Pos","PrB")
  cat("portfolio.csv used to generate <mo_portfolio.df>\n")
  
  #prepare special shiny datasets
  sportfolio <<- portfolio
  sportfolio$date <<- as.character(portfolio$date)
  sprice <<- price
  sprice$Date <<- as.character(price$Date)
  sinv_val <<- inv_val
  sinv_val$Date <<- as.character(inv_val$Date)
  cat("<sportfolio.df>, <sprice.df> and <sinv_val.df> created for Shiny.\n")
  cat("Workspace Prepared. Welcome.")
}
UpdatePrice <- function(){
  suppressWarnings(json <- jsonlite::fromJSON("https://api.coindesk.com/v1/bpi/historical/close.json"))
  json2 <- unlist(lapply(json[1], function (x) x))
  b <- seq(0, 0, length = length(json2))
  for (i in 1:length(json2)) {
    b[i] <- json2[[i]]
  }
  new_price <- data.frame(names(json2), b)
  names(new_price) <- c("Date","Close")
  np_dates <- as.Date(new_price[,1], "bpi.%Y-%m-%d")
  new_price$Date <- np_dates
  from_old_price <- subset(price, Date >= new_price[1,1])
  amt <- nrow(new_price) - nrow(from_old_price)
  while (TRUE){
    if (amt == 0){
      stop("No Updates Available")
    }
    for (i in 1:(nrow(new_price)-amt)){
      if (from_old_price[i,2] != new_price[i,2]){
        stop("Old and New Price data do not match")
      }
    }
    to_add <- tail(new_price, amt)
    price <<- rbind(price, to_add)
    rownames(price) <<- 1:nrow(price)
    cat("<price.df> updated with", amt, "new values.\n")
    write.csv(price, file = "/Users/don/Desktop/Bitcoin/bpi_price.csv", row.names=FALSE)
    cat("bpi_price.csv updated to match new <price.df> values.")
    break
  }
} #uses bpi price
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
} #Working, needs some help on the X-axis
ShinyGo <- function(){
  library(shiny)
  setwd("/Users/don/Desktop/Bitcoin")
  source('AppFunctions.R')
  runApp("/Users/don/Desktop/Bitcoin")
}
ShinyDeploy <- function(){
  library(shinyapps)
  setwd("/Users/don/Desktop/Bitcoin")
  deployApp()
} #Unlikely to work without messing with folders

BitstampUpdate <- function(){
  
}