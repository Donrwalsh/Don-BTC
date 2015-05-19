library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
  
  #get apps data:
  source('AppFunctions.R')
  disp_portfolio <- Portfolio()
  disp_moportfolio <- MO_Portfolio()
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "Portfolio" = disp_portfolio,
           "Portfolio (monthly)" = disp_moportfolio)
  })
  output$view <- renderDataTable({
    datasetInput()
  })
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste(input$dataset, '.csv', sep='') 
    },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})