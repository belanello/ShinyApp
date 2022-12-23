#C:/Users/belan/R/ShinyApp/R/server.R


library(shinyFeedback)
library(shiny)
source('func.R')


server <- function(input, output, session) {
  
# set Default dataset and read csv file according to input$dataset 
  dataset <- reactive({
    if(is.null(input$dataset)){
      sample <- get('airquality','package:datasets')
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
    head(dataset(),3)
  })
  
  # Define dim
  output$dim <- renderText({
    paste(dim(dataset())[1],' observation ','*',dim(dataset())[2],' variables')
  })

  observeEvent(dataset(), {
    freezeReactiveValue(input,'var')
    freezeReactiveValue(input,'histVar')
    choices <- names(dataset())
    grpChoices <- getGrp(dataset())
    updateSelectInput(inputId='var', choices=choices)
    updateSelectInput(inputId='histVar',choices=choices)
    updateSelectInput(inputId='X',choices=choices)
    updateSelectInput(inputId='Y',choices=choices)
    updateSelectInput(inputId='grp',choices=grpChoices)
  })
  
  observeEvent(input$X,{
    choicesY <- getY(dataset(),input$X)
    updateSelectInput(inputId='Y',choices=choicesY)
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
    if(input$grp=='NA'){
      plotXY(dataset(),input$X,input$Y)
    }else{
      feedbackWarning(inputId='grp',!numericX,
                      'Please choose a numeric variable for X-axis')
      req(numericX,cancelOutput=TRUE)
      plotGrp(dataset(),input$X,input$Y,input$grp)
    }
  },res=96)
  
}


  # 
  # # Create a selectInput:choices
  # observeEvent(input$dataset, {
  #   choices <- names(dataset())
  #   numVars <- getNumeric(dataset())
  #   grpVars <- getGroup(dataset())
  #   updateSelectInput(inputId='var', choices=choices)
  #   updateSelectInput(inputId='plotX', choices=choices)
  #   updateSelectInput(inputId='plotY',choices=numVars)
  #   updateSelectInput(inputId='plotGrp',choices=grpVars)
  # })
  # 

  


  
  
