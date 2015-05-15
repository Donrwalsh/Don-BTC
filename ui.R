library(shiny)

# Define UI for dataset viewer application
shinyUI(navbarPage("BTC Data Explorer",
  tabPanel("Raw Data",
           sidebarLayout(
             sidebarPanel(
               selectInput("dataset", "Choose a dataset:", 
                           choices = c("Portfolio","Price","Inv_Val")),
               
               sliderInput("obs", "Number of observations to view:", min=0, max=1000, value = 10)
             ),
             mainPanel(
               verbatimTextOutput("summary"),
               
               dataTableOutput("view")
             )
           )
  )))