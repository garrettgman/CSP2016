library(shiny)

ui <- fluidPage(
    plotOutput("brush", brush = brushOpts("brushed", direction="x")),
    plotOutput("show")
)

server <- function(input, output) {
  output$brush <- renderPlot({
    hist(faithful$waiting, col = "grey50", border = "white", breaks = 30)
  })
  
  output$show <- renderPlot({
    shown <- brushedPoints(faithful, input$brushed, xvar = "waiting")
    
    hist(faithful$eruptions, breaks = seq(1.5, 5.5, by = 0.15), 
         xlim = c(1.5, 5.5), col = "grey50", border = "white")
    
    if (nrow(shown) > 0) {
      hist(shown$eruptions, breaks = seq(1.5, 5.5, by = 0.15), 
         xlim = c(1.5, 5.5), col = "royalblue", border = "white", 
         add = TRUE)
    }
  })
}

shinyApp(ui = ui, server = server)