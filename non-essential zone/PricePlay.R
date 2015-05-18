URL <- "http://api.bitcoincharts.com/v1/csv/bitstampUSD.csv.gz"
download.file(URL, destfile = "data.csv.gz", method="curl")
myData <- read.csv('data.csv.gz', header=FALSE)

#Above downloads, now we have myData ready to be manipulated.
#Initial build of bistampUSD table. Ready for iterative loop to complete:
snippet <- subset(myData, as.POSIXct(myData$V1, origin = "1970-01-01") < "2011-09-14")
VWAP <- sum(snippet$V2*snippet$V3)/sum(snippet$V3)
Vol <- sum(snippet$V3)
Date <- as.Date(as.POSIXct("2011-09-13"))
bitstampUSD <- data.frame(Date, VWAP, Vol, stringsAsFactors = FALSE)
myData <- myData[-c(1:nrow(snippet)),]

#Function that updates bitstampUSD one time:

bitstampUpdate <- function(){
  Date <- as.Date(as.POSIXct("2011-09-13")) + nrow(bitstampUSD)
  snippet <- subset(myData, as.Date(as.POSIXct(myData$V1, origin = "1970-01-01")) < Date+1)
  VWAP <- sum(snippet$V2*snippet$V3)/sum(snippet$V3)
  Vol <- sum(snippet$V3)
  bitstampUSD[nrow(bitstampUSD)+1,1] <<- Date
  bitstampUSD[nrow(bitstampUSD),2] <<- VWAP
  bitstampUSD[nrow(bitstampUSD),3] <<- Vol
  #added if statement to avoid dropping data on 0-volume days
  if (nrow(snippet)>0){myData <<- myData[-c(1:nrow(snippet)),]}
}


for (i in 1:98){
  bitstampUpdate()
}









#old code
TS <- as.POSIXct(myData[1,1], origin = "1970-01-01")
for (i in 1:5000){
  repl <- as.POSIXct(myData[i+1,1], origin = "1970-01-01")
  if (repl > "2011-09-14") {break}
  TS <<- c(TS, repl)
}
PR <- myData[1:length(TS),2]
VO <- myData[1:length(TS),3]
snippet <- data.frame(TS,PR,VO)
WATP <- sum(snippet$PR*snippet$VO)/sum(snippet$VO)
Vol <- sum(snippet$VO)
Date <- as.Date(strftime( snippet[1,1], "%Y-%m-%d", origin = "1970-01-01"))
bitstampUSD <- data.frame(Date, WATP, Vol, stringsAsFactors = FALSE)
myData <- myData[length(TS):length(myData),1:3]


test <- subset(myData, as.POSIXct(myData$V1, origin = "1970-01-01") < "2011-09-15")




read.csv(url("http://api.bitcoincharts.com/v1/trades.csv?symbol=bitstampUSD&start=1315922016"))