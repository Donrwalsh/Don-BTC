library(jsonlite)

Initiate <- function(){
  price <<- data.frame(read.csv("/Users/don/Desktop/BTC/bpi_price.csv", header=TRUE, stringsAsFactors=FALSE))
  price$Date <<- as.Date(price[,1], "%Y-%m-%d")
  cat("bpi_price.csv imported as <price.df>; includes data up to",  toString(price[nrow(price),1]))
}

UpdatePrice <- function(){
  suppressWarnings(json <- jsonlite::fromJSON("https://api.coindesk.com/v1/bpi/historical/close.json"))
  json2 <- unlist(lapply(json[1], function (x) x))
  b <- seq(0, 0, length = length(json2))
  for (i in 1:length(json2)) {
    b[i] <- json2[[i]]
  }
  new_price <<- data.frame(names(json2), b)
  names(new_price) <<- c("Date","Close")
  np_dates <<- as.Date(new_price[,1], "bpi.%Y-%m-%d")
  new_price$Date <<- np_dates
  from_old_price <<- subset(price, Date >= new_price[1,1])
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
    write.csv(price, file = "/Users/don/Desktop/BTC/bpi_price.csv", row.names=FALSE)
    cat("bpi_price.csv updated to match new <price.df> values.")
    break
  }
}

