library(shiny)

# Define UI for dataset viewer application
shinyUI(navbarPage("BTC Data Explorer",
  tabPanel("Raw Data",
           sidebarLayout(
             sidebarPanel(
               selectInput("dataset", "Choose a dataset:", 
                           choices = ("Portfolio"),
               
             )),
             mainPanel(
               dataTableOutput("view")
             )
           )
  )))