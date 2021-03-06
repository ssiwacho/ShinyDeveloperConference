# Exercise 1

library(shiny)
library(gapminder)
library(dplyr)

ui <- fluidPage(
  tags$style(type="text/css", "plot.recalculating { opacity: 1.0; }"),
  plotOutput("plot"),
  sliderInput("year", "Select Year", value = 1952, 
              min = 1952, max = 2007, step = 5,  
              animate = animationOptions(interval = 500))
)

server <- shinyServer(function(input, output) {
  
  # collect one year of data
  ydata <- reactive({
    filter(gapminder, year == input$year)
  })
  
  xrange <- range(gapminder$gdpPercap)
  yrange <- range(gapminder$lifeExp)
  
  output$plot <- renderPlot({
    
    # draw background plot with legend
    plot(gapminder$gdpPercap, gapminder$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange), mean(yrange), input$year, 
                col = "grey90", cex = 5)
         })
    
    legend("bottomright", legend = levels(gapminder$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", 
                    "#984EA399", "#FF7F0099"))
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata()$continent]
    
    # add bubbles
    symbols(ydata()$gdpPercap, ydata()$lifeExp, circles = sqrt(ydata()$pop),
            bg = cols, inches = 0.5, fg = "white", add = TRUE)
  })
})

shinyApp(ui = ui, server = server)

