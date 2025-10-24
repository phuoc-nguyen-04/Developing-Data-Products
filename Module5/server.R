# Define server logic for data exploration application
shinyServer(function(input, output, session) {
  
  # Reactive dataset selection
  datasetInput <- reactive({
    switch(input$dataset,
           "mtcars" = mtcars,
           "iris" = iris,
           "pressure" = pressure,
           "cars" = cars,
           "faithful" = faithful)
  })
  
  # Update variable choices based on selected dataset
  observe({
    data <- datasetInput()
    numericVars <- names(data)[sapply(data, is.numeric)]
    allVars <- names(data)
    
    # Update X variable choices
    updateSelectInput(session, "xvar",
                      choices = allVars,
                      selected = allVars[1])
    
    # Update Y variable choices
    updateSelectInput(session, "yvar",
                      choices = allVars,
                      selected = allVars[min(2, length(allVars))])
    
    # Update color variable choices (for scatter plots)
    updateSelectInput(session, "colorvar",
                      choices = c("None" = "none", allVars),
                      selected = "none")
  })
  
  # Sample the data based on user input
  sampledData <- reactive({
    data <- datasetInput()
    if (nrow(data) > input$sampleSize) {
      data[sample(nrow(data), input$sampleSize), ]
    } else {
      data
    }
  })
  
  # Create the main plot
  output$plot <- renderPlot({
    data <- sampledData()
    xvar <- input$xvar
    yvar <- input$yvar
    colorvar <- input$colorvar
    
    if (input$plotType == "scatter") {
      if (colorvar != "none" && colorvar %in% names(data)) {
        # Scatter plot with color coding
        ggplot(data, aes_string(x = xvar, y = yvar, color = colorvar)) +
          geom_point(size = 3, alpha = 0.7) +
          labs(title = paste("Scatter Plot:", xvar, "vs", yvar),
               x = xvar, y = yvar) +
          theme_minimal() +
          theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
      } else {
        # Simple scatter plot
        ggplot(data, aes_string(x = xvar, y = yvar)) +
          geom_point(size = 3, alpha = 0.7, color = "steelblue") +
          labs(title = paste("Scatter Plot:", xvar, "vs", yvar),
               x = xvar, y = yvar) +
          theme_minimal() +
          theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
      }
    } else if (input$plotType == "hist") {
      # Histogram
      ggplot(data, aes_string(x = xvar)) +
        geom_histogram(bins = 20, fill = "steelblue", alpha = 0.7, color = "black") +
        labs(title = paste("Histogram of", xvar),
             x = xvar, y = "Frequency") +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
    } else if (input$plotType == "box") {
      if (colorvar != "none" && colorvar %in% names(data)) {
        # Box plot with grouping
        ggplot(data, aes_string(x = colorvar, y = xvar, fill = colorvar)) +
          geom_boxplot(alpha = 0.7) +
          labs(title = paste("Box Plot of", xvar, "by", colorvar),
               x = colorvar, y = xvar) +
          theme_minimal() +
          theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
                legend.position = "none")
      } else {
        # Simple box plot
        ggplot(data, aes_string(y = xvar)) +
          geom_boxplot(fill = "steelblue", alpha = 0.7) +
          labs(title = paste("Box Plot of", xvar),
               y = xvar) +
          theme_minimal() +
          theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
      }
    }
  })
  
  # Display plot information
  output$plotInfo <- renderText({
    data <- sampledData()
    paste("Dataset:", input$dataset, 
          "| Sample size:", nrow(data),
          "| Plot type:", input$plotType)
  })
  
  # Display data table
  output$dataTable <- renderDataTable({
    data <- sampledData()
    data
  }, options = list(pageLength = 10, scrollX = TRUE))
  
  # Display statistical summary
  output$summary <- renderPrint({
    data <- sampledData()
    if (input$showSummary) {
      cat("Dataset Summary for", input$dataset, "\n")
      cat("=====================================\n\n")
      cat("Dataset dimensions:", nrow(data), "rows,", ncol(data), "columns\n\n")
      
      # Basic statistics for numeric variables
      numericVars <- names(data)[sapply(data, is.numeric)]
      if (length(numericVars) > 0) {
        cat("Numeric Variables Summary:\n")
        cat("-------------------------\n")
        print(summary(data[numericVars]))
      }
      
      # Factor variables summary
      factorVars <- names(data)[sapply(data, is.factor)]
      if (length(factorVars) > 0) {
        cat("\nFactor Variables Summary:\n")
        cat("-------------------------\n")
        for (var in factorVars) {
          cat(var, ":\n")
          print(table(data[[var]]))
          cat("\n")
        }
      }
      
      # Correlation matrix for numeric variables
      if (length(numericVars) > 1) {
        cat("Correlation Matrix:\n")
        cat("------------------\n")
        cor_matrix <- cor(data[numericVars], use = "complete.obs")
        print(round(cor_matrix, 3))
      }
    } else {
      cat("Check 'Show statistical summary' to see detailed analysis")
    }
  })
})
