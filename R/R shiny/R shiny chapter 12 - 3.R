load("./01_code/earthquake/earthquake_16_21.rdata")
head(quakes, 2)



library(shiny)
library(leaflet)
library(ggplot2)
library(ggpmisc)

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;hight:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10, 
                sliderInput(
                  inputId = "range",
                  label = "진도",
                  min = min(quakes$mag),
                  max = max(quakes$mag),
                  value = range(quakes$mag),
                  step = 0.5
                ),
                sliderInput(
                  inputId = "time",
                  label = "기간",
                  min = min(quakes$year),
                  max = max(quakes$year),
                  value = range(quakes$year),
                  step = 1
                ),
                plotOutput("histCentile", height = 230),
                plotOutput("depth", height = 230),
                p(span("자료출처:기상청", align = "center", style = "color:black;background-color:white"))
  )
)







server <- function(input, output, session) {
  filteredData <- reactive({
    quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2] & quakes$year >= input$time[1] & quakes$year <= input$time[2],]
  })   
  output$map <- renderLeaflet({
    leaflet(quakes) %>% addTiles() %>% 
    fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
    })
    output$histCentile <- renderPlot({  
    if (nrow(filteredData) == 0)
      return(NULL)
    cetileBreaks <- hist(plot = FALSE, filteredData()$mag, breaks = 20)$breaks
    hist(filteredData$mag, 
         breaks = centileBreaks, main = "지진발생정보",
         xlab = "진도", ylab = "빈도", col = 'blue', border = 'grey')
    })
  output$depth <- renderPlot({
    ggplot(filteredData(), aes(x=mag, y=-depth))+
      geom_point(size=3, col="red") +
      geom_smooth(method = "lm", col= "blue") +
      xlab("진도") + ylab("깊이") +
      stat_poly_eq(aes(label=paste(..eq.label..)),
                   label.x = "right", label.y = "top",
                   formula = y ~ x, parse = TRUE, size = 5, col="black"
                   )
  })
  observe({
    leafletProxy("map", data=filteredData()) %>% clearShapes() %>% 
      addCircles(
        radius = ~log((quakes$mag))^20,
        weight = 1, color = "grey70",
        fillColor = "red", fillOpacity = 0.6, popup = ~paste(mag)
      )
  })
}

shinyApp(ui, server)


