library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("plot", brush = "brush"),
  selectInput("xVar", "Select X", 
    choices = names(mtcars), selected = "wt"),
  verbatimTextOutput("clickVals")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    qplot(mtcars[[input$xVar]], mtcars$mpg, xlab = input$xVar, ylab = "mpg")
  })
  
  output$clickVals <- renderPrint({
    brushedPoints(mtcars, input$brush, xvar = input$xVar, yvar = "mpg")
  })
  
}

shinyApp(ui, server)