===portfolio.csv===
Purchase Date - Pos (Amt of BTC) - Price (Cost Paid)
Date - numeric - numeric


!!!!! Good Data (numbers match), but cvs data type should be updated.


===DataPlay.R====:
Basic code utilizing portfolio.csv

Begin():
 portfolio = data frame of portfolio.cv (!!fix data types!!)
 op = overall position
 oi = overall investment
 pb = price basis

 mo_investment = Time Series of Monthly Investment
 mo_position = Time Series of Monthly Position
 mo_pricebasis = Time Series of Monthly Price Basis

 mo_portfolio = data.frame: #pulled from mo_3x above
Mon - Inv - Pos - PrB
yearn - investment - position - price basis


 #price, gotta do a bunch with price#
 
Make better graph than https://docs.google.com/spreadsheets/d/1UCWkA3TnT3SGNOi8efVu7MfkNTx9ZzKQ01X3NIWeB2U/edit#gid=790779993