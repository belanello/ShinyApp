#C:/Users/belan/R/ShinyApp/R/ui.R
library(shiny)
library(shinyFeedback)
library(bslib)

shinyUI(fluidPage(
  theme=bs_theme(bootswatch='united'),
  
  titlePanel("Quick Data summary"),
  
  p('Before we start a Data analysis or apply a machine learning algorithm, 
    firstly we check the basic information of our data. This simple shiny app 
    makes our first exploratory analysis quick and easy. Now "airquality"
    dataset is loaded by default, please explore the functionality before 
    uploading your file and check the documentation if necessary.'),
  
  # ======================================================================
  # Data upload section
  # ======================================================================
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
           p(tags$ul(tags$li('File size is less than',strong('5MB.')),
                     tags$li('Data is in',strong('csv file.')),
                     tags$li('If the first row is a header of the table,
                           thick a check box above.'),
                     style="font-size:13px;")
             )
           
    ),
    column(7,
           br(),
           tableOutput("head"),
           strong(textOutput('dim'))
    )
  ),
  # ======================================================================
  # Variable details section
  # ======================================================================
  tags$hr(),
  fluidRow(
    column(5,
           h4('Variable Details'),
           p(tags$ul(tags$li('Choose a variable.'),
                     tags$li('The summary will be displayed below and correlation
                             with all the other variables will be included in 
                             the table (only for numeric variables.)'),
                     tags$li('NAs column of the table is the number of NA values
                             of each variable'),
                     tags$li('If categorical variables coded in numeric, 
                             thick the checkbox, then the summary will be counts 
                             of unique values.'),
                     style="font-size:13px;"),
             ),
           
           selectInput(inputId='var',
                       label='Choose a variable.',
                       choices=NULL),
           
           verbatimTextOutput("summary"),
           
           checkboxInput(inputId='categorical',
                         label='Change this variable to factor?')
    ),
    column(7,
           tableOutput('details')
    )
  ),
  # ======================================================================
  # Distribution section
  # ======================================================================
  tags$hr(),
  fluidRow(
    column(5,
           h4('Distributions'),
           p(tags$ul(tags$li('Choose the numeric variable.'),
                     tags$li('The histogram in density scale is displayed.'),
                     tags$li('The line is density estimate.'),
                     tags$li('The rug-plot(1D scatter plot) is at the bottom of 
                             the plot'),
                     tags$li('Change the bin width by the slider if you need.'),
                     style="font-size:13px;")
           ),
           useShinyFeedback(),
           selectInput(inputId='histVar',
                       label='Choose a variable. (NUMERIC ONLY)',
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
  # ======================================================================
  # Relationships section
  # ======================================================================
  tags$hr(),
  fluidRow(
    column(5,
           h4('Relationships between Variables'),
           p(tags$ul(tags$li('Choose X-axis and Y-axis variables.'),
                     tags$li('The scatter plot and regression line will be 
                             displyed.'),
                     tags$li('The row names(indices) of the most three extreme 
                             points will be displayed.'),
                     tags$li('Each marginal boxplot will be displayed at each 
                             axis.'),
                     tags$li('if the variable of X-axis is a categorical, 
                             a boxplot will be displayed instead of a scatter
                             plot.'),
                     style="font-size:13px;")
           ),
           useShinyFeedback(),
           selectInput(inputId='X',
                       label='Choose a X-axis variable',
                       choices=NULL),
           selectInput(inputId='Y',
                       label='Choose a Y-axis variable.(NUMERIC ONLY)',
                       choices=NULL)
           
    ),
    column(7,
           plotOutput('scatter'),
           br()
    )
  ),
))
