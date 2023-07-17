library(shiny)

ui <- fluidPage(
  titlePanel("Sliding Window"),
  
  sidebarLayout(
    sidebarPanel("Change Window Parameters", 
                 fileInput("file", "DLC Output Here", accept = ".csv"), 
                 "Region of Interest", 
                 sliderInput("roi", "",
                             min = 0, max = 9000, value = c(0, 1000))),
    mainPanel(h3("Trajectory Plot"), textOutput("out"),
              plotOutput("plot_output")
              )
  )
)

server <- function(input, output, session) {
  
  output$plot_output <- renderPlot({
    input_directory = ""
    fixed_xlim <- c(0, 800)
    fixed_ylim <- c(600, 100)   
    
    {
      data <- read.csv(input$file$datapath[1], skip = 3, header = FALSE)
      
      ab_x <- data[, 2]
      ab_y <- data[, 3]
      
      wax_x <- data[, 5]
      wax_y <- data[, 6]
      
      left_knee_x <- data[, 8]
      left_knee_y <- data[, 9]
      
      left_foot_x <- data[, 11]
      left_foot_y <- data[, 12]
      
      right_knee_x <- data[, 14]
      right_knee_y <- data[, 15]
      
      right_foot_x <- data[, 17]
      right_foot_y <- data[, 18]
      
      data_length <- length(ab_x)
    }
    
    plot(NA, NA, xlim = fixed_xlim, ylim = fixed_ylim, xlab = "x (px)", ylab = "y (px)")

    color <- rainbow(6)
    start <- input$roi[1]
    end <- input$roi[2]
    points(ab_x[start:end], ab_y[start:end], col = color[1])
    points(wax_x[start:end], wax_y[start:end], col = color[2])
    points(left_knee_x[start:end], left_knee_y[start:end], col = color[3])
    points(left_foot_x[start:end], left_foot_y[start:end], col = color[4])
    points(right_knee_x[start:end], right_knee_y[start:end], col = color[5])
    points(right_foot_x[start:end], right_foot_y[start:end], col = color[6])
    legend("bottomright",
           legend = c("abdomen", "wax", "left knee", "left foot", "right knee", "right foot"),
           col = color,
           pch = 1, cex = 0.8)
    
  })
  
  output$out <- renderText({
    paste0("You selected ", input$file$name[1], "\n", 
           "Length of this data: ", data_length)
  })
  
  data_length <- reactive({
    ifelse(exists(ab_x), length(ab_x), 8888)
  })
  
  observeEvent(data_length, {
    updateSliderInput(
      session, 
      "roi", 
      min = 1, 
      max = data_length(), 
      value = c(0, 1000)
    )
  })
}

shinyApp(ui, server)