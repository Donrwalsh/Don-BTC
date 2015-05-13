
library(jsonlite)

#Migrated Code:
json2 <- jsonlite::fromJSON("https://api.coindesk.com/v1/bpi/historical/close.json")
json3 <- unlist(lapply(json2[1], function (x) x))


#FUCKING WORKS ^^^
#json2[1]$bpi$`2015-04-11` provides numeric output

#mo_portfolio <<- data.frame(as.yearmon(mo_vec-1), mo_investment[1:18], mo_position[1:18], mo_pricebasis[1:18])




a <- names(json3)
b <- seq(0, 0, length = length(json3))
for (i in 1:length(json3)) {
  b[i] <- json3[[i]]
}
new_price <- data.frame(a, b)
names(new_price) <- c("Date","Close")
np_dates <- as.Date(new_price[,1], "bpi.%Y-%m-%d")
new_price$Date <- np_dates
from_old_price <- subset(price, Date >= new_price[1,1])
amt <- nrow(new_price) - nrow(from_old_price)
cat(amt, "new price values found")
for (i in 1:(nrow(new_price)-amt)){
  if (!from_old_price[i,2] == new_price[i,2]){
    stop("Catastrophic Failure, prices do not match")
  } else {
    cat(toString(new_price[i,1]), "price matches Source Data.\n")
  }
}
#restructure this to be a while loop that terminates on amt = 0 and catastrophic failure
to_add <- tail(new_price, amt)
c <- rbind(price, to_add)
rownames(c) <- 1:nrow(c)



for (i in 1:nrow(new_price)){
  
}


#compare new_price to price. Verify there are no errors.
#Expand price with any new information found in new_price, with a heads up.
#save the updated price df to bpi_price.csv.

#p_dates <- as.Date(portfolio[,1], "%m/%d/%y")