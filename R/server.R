#C:/Users/belan/R/ShinyApp/R/server.R

library(shiny)
library(shinyFeedback)
source('func.R')


server <- function(input, output, session) {
  
# set Default dataset and read csv file according to input$dataset 
  dataset <- reactive({
    if(is.null(input$dataset)){
      sample <- get('mtcars','package:datasets')
      sample
    }else{
      ext <- tools::file_ext(input$dataset$datapath)
      validate(need(ext == "csv", "Please upload a csv file"))
      df <- read.csv(input$dataset$datapath, header = input$header)
      df
    }
  })
  
  # Define head
  output$head <- renderTable({
    head(dataset(),5)
  })
  
  # Define dim
  output$dim <- renderText({
    paste(dim(dataset())[1],' observation ','*',dim(dataset())[2],' variables')
  })

  observeEvent(dataset(), {
    freezeReactiveValue(input,'var')
    freezeReactiveValue(input,'histVar')
    choices <- names(dataset())
    updateSelectInput(inputId='var', choices=choices)
    updateSelectInput(inputId='histVar',choices=choices)
    updateSelectInput(inputId='X',choices=choices)
    updateSelectInput(inputId='Y',choices=choices)
  })
  
  observeEvent(input$X,{
    choicesY <- getY(dataset(),input$X)
    updateSelectInput(inputId='Y',choices=choicesY)
  })
  
  observeEvent(input$Y,{
    choicesG <- getG(dataset(),input$X,input$Y)
    updateSelectInput(inputId='G',choices=choicesG)
  })
  
  # Define summary
  output$summary <- renderPrint({
    if(!input$categorical){
      summary(dataset()[,input$var])
    }else{
      newDf <- newDf(dataset(),input$var)
      summary(newDf[,input$var])
    }
  })

  # Define details
  output$details <- renderTable({
    if(!input$categorical){
      getDetails(dataset(),input$var)
    }else{
      newDf <- newDf(dataset(),input$var)
      getDetails(newDf,input$var)
    }

  })
  
  # Define hist
  
  output$hist <- renderPlot({
    numeric <- isNumericInteger(dataset()[,input$histVar])
    feedbackWarning(inputId='histVar',!numeric,
                          'Please choose a numeric variable')
    req(numeric,cancelOutput=TRUE)
    plotHist(dataset(),input$histVar,input$bin)
  },res=96)
  
  # Define scatterplot
  output$scatter <- renderPlot({
    numericX <- isNumericInteger(dataset()[,input$X])
    numericY <- isNumericInteger(dataset()[,input$Y])
    feedbackWarning(inputId='Y',!numericY,
                    'Please choose a numeric variable for Y-axis')
    req(numericY,cancelOutput=TRUE)
    if(input$G=='NA'){
      plotXY(dataset(),input$X,input$Y)
    }else if((!input$G=='NA')&(!input$categoricalG)){
      numericG <- isNumericInteger(dataset()[,input$G])
      feedbackWarning(inputId='G',numericG,
                      'Please choose a categorical variable.')
      
      req(input$categoricalG,cancelOutput=TRUE)
      newDf <- newDf2(dataset(),input$X,input$Y,input$G)
      plotG(newDf,input$X,input$Y,input$G)
    }else{
      plotG(dataset(),input$X,input$Y,input$G)
    }
  },res=96)
  
}



  


  
  
