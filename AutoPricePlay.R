
library(jsonlite)
json2 <- jsonlite::fromJSON("https://api.coindesk.com/v1/bpi/historical/close.json")
#FUCKING WORKS ^^^
#json2[1]$bpi$`2015-04-11` provides numeric output

#mo_portfolio <<- data.frame(as.yearmon(mo_vec-1), mo_investment[1:18], mo_position[1:18], mo_pricebasis[1:18])



json3 <- unlist(lapply(json2[1], function (x) x))
a <- names(json3)
b <- seq(0, 0, length = length(json3))
for (i in 1:length(json3)) {
  b[i] <- json3[[i]]
}
new_price <- data.frame(a, b)
names(new_price) <- c("Date","Close")

#noticed that price (and, well, new_price) have incorrect data types, need to correct for both (probably extend this into a data dictionary)
#compare new_price to price. Verify there are no errors.
#Expand price with any new information found in new_price, with a heads up.
#save the updated price df to bpi_price.csv.