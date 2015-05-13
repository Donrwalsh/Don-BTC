library(jsonlite)

Initiate <- function(){
  price <<- data.frame(read.csv("/Users/don/Desktop/BTC/bpi_price.csv", header=TRUE, stringsAsFactors=FALSE))
  price$Date <<- as.Date(price[,1], "%Y-%m-%d")
  cat("bpi_price.csv imported as <price.df>; includes data up to",  toString(price[nrow(price),1]))
}

UpdatePrice <- function(){
  json <- jsonlite::fromJSON("https://api.coindesk.com/v1/bpi/historical/close.json")
  json2 <- unlist(lapply(json[1], function (x) x))
  b <- seq(0, 0, length = length(json3))
  for (i in 1:length(json2)) {
    b[i] <- json2[[i]]
  }
  new_price <<- date.frame(names(json2), b)
}

