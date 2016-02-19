library(shiny)
library(ggplot2)

ui <- fluidPage(
    plotOutput("plot", brush = "brushed", dblclick = "double"),
    verbatimTextOutput("model")
)

server <- function(input, output) {
  
  # create jittered data (for vanity)
  iris2 <- data.frame(
    Petal.Width = jitter(iris$Petal.Width, 
      amount = 0.4 * resolution(iris$Petal.Width)),
    Sepal.Width = jitter(iris$Sepal.Width, 
      amount = 0.4 * resolution(iris$Sepal.Width))
  )
  
  # compute each once to reuse
  p <- ggplot(iris2, aes(Petal.Width, Sepal.Width)) + 
         geom_point() + 
         coord_cartesian(xlim = c(0, 2.6), ylim = c(1.8, 4.5))
  m <- lm(Sepal.Width ~ Petal.Width, data = iris2)
  
  rv <- reactiveValues(
          data = iris2, 
          plot = p + geom_smooth(method = "lm", se = FALSE),
          model = m)
  
  observeEvent(c(input$brushed, input$double), {
    highlighted <- brushedPoints(iris2, input$brushed, 
      xvar = "Petal.Width", yvar = "Sepal.Width")
    
    if (nrow(highlighted) == 0) {
      rv$data <- iris2
      rv$model <- m
      rv$plot <- p + geom_smooth(method = "lm", se = FALSE)
    } else {
      rv$data <- highlighted
      
      mod <- lm(Sepal.Width ~ Petal.Width, data = highlighted)
      rv$model <- mod
      
      coefs <- coef(mod)
      fy <- function(x) coefs[1] + coefs[2] * x
      rv$plot <- p + geom_segment(color = "blue",
        x = input$brushed$xmin,
        xend = input$brushed$xmax,
        y = fy(input$brushed$xmin),
        yend = fy(input$brushed$xmax))
    }
  })
  
  output$plot <- renderPlot({
    rv$plot
  })
  
  output$model <- renderPrint({
    summary(rv$model)
  })
}

shinyApp(ui = ui, server = server)
