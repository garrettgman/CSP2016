library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("plot"),
  selectInput("xVar", "Select X", 
    choices = names(mtcars), selected = "wt")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    qplot(mtcars[[input$xVar]], mtcars$mpg, xlab = input$xVar, ylab = "mpg")
  })
}

shinyApp(ui, server)