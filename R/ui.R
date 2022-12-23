#C:/Users/belan/R/ShinyApp/R/ui.R
library(shiny)
library(shinyFeedback)
library(bslib)

shinyUI(fluidPage(
  theme=bs_theme(bootswatch='united'),
  # Application title
  titlePanel("Quick Data summary"),
  p('Before we start a Data analysis or apply a machine learning algorithm, 
  firstly we check the basic information of our data, such as dimension, 
  classes of variables, missing values, outliers, distribution, 
  interactions of variables and so on. This simple shiny app makes our first 
  exploratory analysis quick and easy. Now mtcars dataset is loaded by default, 
  please explore the functionalities before upload the file and check 
  the documentation if necessary.' ),
  
  # Sidebar Panel
  tags$hr(),
  fluidRow(
    column(5,
           h4('Data'),
           fileInput(inputId="dataset",
                     label = "Choose a CSV file",
                     multiple=FALSE,
                     accept='.csv'),
           checkboxInput("header", "Header", TRUE),
           p('Before upload your file, check'),
           p(tags$ul(tags$li('File size is less than 5MB.'),
                     tags$li('Data is in csv file.'),
                     tags$li('If the first row is a header of the table,
                           thick a check box above.')
                     )
             )
           
    ),
    column(7,
           tableOutput("head"),
           strong(textOutput('dim'))
    )
  ),
  tags$hr(),
  fluidRow(
    column(5,
           h4('Variable Details'),
           selectInput(inputId='var',
                       label='Choose a variable',
                       choices=NULL),
           verbatimTextOutput("summary"),
           checkboxInput(inputId='categorical',
                         label='Change this variable to factor?')
    ),
    column(7,
           tableOutput('details')
    )
  ),
  tags$hr(),
  fluidRow(
    column(5,
           h4('Distributions'),
           useShinyFeedback(),
           selectInput(inputId='histVar',
                       label='Choose a numeric variable',
                       choices=NULL),
           sliderInput(inputId='bin',
                       label='The number of bins',
                       min=2,max=50,value=10,step=1)

    ),
    column(7,
           plotOutput('hist'),
           br()
    )
  ),
  tags$hr(),
  fluidRow(
    column(5,
           h4('Relationships'),
           useShinyFeedback(),
           selectInput(inputId='X',
                       label='Choose a X-axis variable',
                       choices=NULL),
           selectInput(inputId='Y',
                       label='Choose a Y-axis variable',
                       choices=NULL),
           selectInput(inputId='G',
                       label='Choose a categorical variable',
                       choices='NA'),
           checkboxInput(inputId='categoricalG',
                         label='Change this variable to factor?')
           
    ),
    column(7,
           plotOutput('scatter'),
           br()
    )
  ),
))
