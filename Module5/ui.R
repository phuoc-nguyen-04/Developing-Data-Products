# Define UI for data exploration application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interactive Data Explorer"),
  
  # Sidebar with input controls
  sidebarLayout(
    sidebarPanel(
      h3("Data Selection"),
      
      # Dataset selection
      selectInput("dataset", 
                  "Choose a dataset:",
                  choices = c("mtcars", "iris", "pressure", "cars", "faithful"),
                  selected = "mtcars"),
      
      # Variable selection for X-axis
      selectInput("xvar", 
                  "X-axis variable:",
                  choices = NULL),
      
      # Variable selection for Y-axis
      selectInput("yvar", 
                  "Y-axis variable:",
                  choices = NULL),
      
      # Plot type selection
      radioButtons("plotType",
                   "Plot Type:",
                   choices = c("Scatter Plot" = "scatter",
                              "Histogram" = "hist",
                              "Box Plot" = "box"),
                   selected = "scatter"),
      
      # Color by variable (for scatter plots)
      conditionalPanel(
        condition = "input.plotType == 'scatter'",
        selectInput("colorvar",
                    "Color by:",
                    choices = NULL)
      ),
      
      # Statistical summary checkbox
      checkboxInput("showSummary",
                    "Show statistical summary",
                    value = FALSE),
      
      # Sample size slider
      sliderInput("sampleSize",
                  "Sample size:",
                  min = 10,
                  max = 100,
                  value = 50,
                  step = 10),
      
      # Documentation
      h4("How to use this app:"),
      p("1. Select a dataset from the dropdown"),
      p("2. Choose variables for X and Y axes"),
      p("3. Pick a plot type"),
      p("4. Adjust sample size if needed"),
      p("5. Check 'Show statistical summary' for data insights")
    ),
    
    # Main panel with outputs
    mainPanel(
      # Tabset for different outputs
      tabsetPanel(type = "tabs",
                  
                  # Plot tab
                  tabPanel("Plot",
                           plotOutput("plot", height = "500px"),
                           br(),
                           h4("Plot Information:"),
                           textOutput("plotInfo")
                  ),
                  
                  # Data tab
                  tabPanel("Data",
                           h4("Dataset Preview:"),
                           dataTableOutput("dataTable")
                  ),
                  
                  # Summary tab
                  tabPanel("Summary",
                           h4("Statistical Summary:"),
                           verbatimTextOutput("summary")
                  ),
                  
                  # Documentation tab
                  tabPanel("Documentation",
                           h3("📊 Interactive Data Explorer - User Guide"),
                           p("Welcome to the Interactive Data Explorer! This application allows you to explore various built-in R datasets interactively, even if you have no prior experience with data analysis."),
                           
                           h4("🚀 Quick Start Guide:"),
                           tags$ol(
                             tags$li("Select a dataset from the dropdown menu (start with 'mtcars' for cars data)"),
                             tags$li("Choose variables for X and Y axes from the dropdown menus"),
                             tags$li("Pick a plot type: Scatter Plot, Histogram, or Box Plot"),
                             tags$li("Adjust the sample size slider if you want to work with a subset of data"),
                             tags$li("Check 'Show statistical summary' to see detailed data insights"),
                             tags$li("Explore different tabs: Plot, Data, Summary, and this Documentation")
                           ),
                           
                           h4("📁 Available Datasets:"),
                           tags$ul(
                             tags$li(strong("mtcars:"), "Motor Trend Car Road Tests - 32 cars with 11 variables (mpg, hp, cyl, etc.)"),
                             tags$li(strong("iris:"), "Edgar Anderson's Iris Data - 150 iris flowers with 4 measurements"),
                             tags$li(strong("pressure:"), "Vapor Pressure of Mercury - temperature vs pressure data"),
                             tags$li(strong("cars:"), "Speed and Stopping Distances - 50 cars with speed and distance data"),
                             tags$li(strong("faithful:"), "Old Faithful Geyser Data - eruption times and waiting periods")
                           ),
                           
                           h4("🎨 Plot Types Explained:"),
                           tags$ul(
                             tags$li(strong("Scatter Plot:"), "Shows relationship between two variables. Use color coding to see patterns by groups."),
                             tags$li(strong("Histogram:"), "Shows distribution of a single variable. Great for understanding data spread."),
                             tags$li(strong("Box Plot:"), "Shows median, quartiles, and outliers. Excellent for comparing groups.")
                           ),
                           
                           h4("✨ Key Features:"),
                           tags$ul(
                             tags$li("🔄 Real-time updates: Plots change instantly when you modify inputs"),
                             tags$li("🎨 Color coding: Automatically color-code points by categorical variables"),
                             tags$li("📊 Statistical summaries: Get mean, median, correlation, and more"),
                             tags$li("📋 Data preview: See the actual data in table format"),
                             tags$li("🎛️ Sample size control: Focus on subsets of large datasets")
                           ),
                           
                           h4("💡 Pro Tips for Beginners:"),
                           tags$ul(
                             tags$li("Start with the 'mtcars' dataset - it's intuitive (car data)"),
                             tags$li("Try scatter plots first - they're easiest to interpret"),
                             tags$li("Use color coding in scatter plots to see if different groups behave differently"),
                             tags$li("Check the Summary tab to understand your data better"),
                             tags$li("Experiment with different sample sizes to see how it affects your analysis"),
                             tags$li("Don't worry about making mistakes - just try different combinations!")
                           ),
                           
                           h4("🔍 Understanding Your Results:"),
                           tags$ul(
                             tags$li("Scatter plots: Points close together suggest strong relationships"),
                             tags$li("Histograms: Tall bars show common values, spread shows variability"),
                             tags$li("Box plots: The box shows the middle 50% of data, lines show extremes"),
                             tags$li("Correlation: Values close to 1 or -1 indicate strong relationships")
                           ),
                           
                           h4("❓ Need Help?"),
                           p("This application is designed to be self-explanatory. If you're unsure about something, just try it! The app will guide you through the process. Remember, there's no 'wrong' way to explore data - every combination teaches you something new about your dataset.")
                  )
      )
    )
  )
))
