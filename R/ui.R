#C:/Users/belan/R/ShinyApp/R/ui.R
library(shiny)
library(shinyFeedback)
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Quick Data summary"),
  
  # Sidebar Panel
  fluidRow(
    column(5,
           fileInput(inputId="dataset",
                     label = "Choose a CSV file",
                     multiple=FALSE,
                     accept='.csv'),
           checkboxInput("header", "Header", TRUE),
           
    ),
    column(7,
           h3('Data'),
           tableOutput("head"),
           strong(textOutput('dim'))
    )
  ),
  tags$hr(),
  fluidRow(
    column(5,
           selectInput(inputId='var',
                       label='Choose a variable',
                       choices=NULL),
           verbatimTextOutput("summary"),
           checkboxInput(inputId='categorical',
                         label='Change this variable to factor?')
    ),
    column(7,
           h3('Variable Details'),
           tableOutput('details')
    )
  ),
  tags$hr(),
  fluidRow(
    column(5,
           useShinyFeedback(),
           selectInput(inputId='histVar',
                       label='Choose a numeric variable',
                       choices=NULL),
           sliderInput(inputId='bin',
                       label='The number of bins',
                       min=2,max=50,value=10,step=1)

    ),
    column(7,
           h3('Distribution Plot'),
           plotOutput('hist'),
           br()
    )
  ),
  tags$hr(),
  fluidRow(
    column(5,
           useShinyFeedback(),
           selectInput(inputId='X',
                       label='Choose a X-axis variable',
                       choices=NULL),
           selectInput(inputId='Y',
                       label='Choose a Y-axis variable',
                       choices=NULL),
           selectInput(inputId='grp',
                       label='Choose a group variable',
                       choices=NULL)
           
    ),
    column(7,
           h3('XY Plot'),
           plotOutput('scatter'),
           br()
    )
  ),
))
