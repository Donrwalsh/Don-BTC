Begin <- function(){
  portfolio <<- data.frame(read.csv("/Users/don/Desktop/BTC/portfolio.csv", header=TRUE, stringsAsFactors=FALSE))
  op <<- sum(as.numeric(portfolio$pos)) # = overall position
  oi <<- sum(as.numeric(portfolio$pos)*as.numeric(portfolio$price)) # = overall investment
  pb <<- oi/op # = price basis
}
Begin()

#example of adding a row to portfolio:
newvec <- c("12/8/13",0.0433,806.70)
portfolio <- rbind(portfolio,newvec)

#save portfolio:
write.csv(portfolio, file = "/Users/don/Desktop/BTC/portfolio.csv", row.names=FALSE)




  