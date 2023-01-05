
library(shiny)
library(shinyFeedback)
library(bslib)

shinyUI(fluidPage(
  theme=bs_theme(bootswatch='united'),
  
  titlePanel("Quick Data Summary"),
  
  p('Before we start a Data analysis or apply a machine learning algorithm, 
    firstly we check the basic information of our data. This simple shiny app 
    makes our first exploratory analysis quick and easy. Now "airquality"
    dataset is loaded by default, please explore the functionality before 
    uploading your file and check the documentation if necessary.'),
  
  # ======================================================================
  # Tab1:
  # Data upload section
  # ======================================================================
  tabsetPanel(
    tabPanel('Quick Data Summary App',

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
                     tags$li('Data table in the file is in wide form.'),
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
                     tags$li('NAs column of the table is the number of missing values
                             of each variable'),
                     tags$li('If categorical variable is coded in numeric or character, 
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
           
           checkboxInput(inputId='categorical2',
                         label='Change X variable to factor?'),
           
           selectInput(inputId='Y',
                       label='Choose a Y-axis variable.(NUMERIC ONLY)',
                       choices=NULL),
           br(),
           br()
           
    ),
    column(7,
           plotOutput('scatter'),
           br()
    )
  )
),
# ======================================================================
# tab2:documentation
# ======================================================================
  tabPanel('Documentation',
           p(h5('Description'),
             br(),
             p('There are 4 sections to explore your data.'),
             tags$ol(
               tags$li('Data section',br(),'By loading the data, it display the 
                   head of the data and its dimension.'),
               tags$li('Variable Details section',br(),
                       'By Choosing the variable from drop down list, it display 
                        the summary of chosen variable along with the table with
                        all the other variables details including the correlations
                        (for numeric variable), and the number of missing values.'),
               tags$li('Distributions section',br(),'By choosing the numeric variable
                        from drop down list, it displays the histogram (in density 
                        scale)'),
               tags$li('Relationships between Variables section',br(),'By choosing 
                        X-axis variable and Y-axis variables, it displays the scatter 
                        plot (if X is numeric) or box plot (if X is categorical).'))),
         
         
         
           p(h5('Restrictions'),
             br(),
             p('The file you upload must be,'),
             tags$ul(
                tags$li('Less than 5MB'),
                tags$li('csv (comma-separated values) file.')),
             p('The data table in the file must be,  '),
             tags$ul(
               tags$li('In wide form.(each row represents single observation and
                       each column represents single variable in the same data class) '))),
           
           p(h5('Codes'),
             a(href='https://github.com/belanello/ShinyApp/tree/main/R',
               'https://github.com/belanello/ShinyApp/tree/main/R'),
             br(),br(),br())
         
         ))
))
