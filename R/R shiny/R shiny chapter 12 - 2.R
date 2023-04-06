load("./06_geodataframe/06_apt_price.rdata")
library(sf)
apt_price <- st_drop_geometry(apt_price)
apt_price$py_area <- round(apt_price$area / 3.3, 0)
head(apt_price$py_area)
library(shiny)
library(ggpmisc)

ui <- fluidPage(
  titlePanel("아파트가격 상관관계분석"),
  fluidRow(
    column(6, selectInput(
      inputId = "region", 
      label = "지역을 선택하세요", 
      unique(apt_price$addr_1),
      multiple = TRUE )),
    column(6, sliderInput(
      inputId = "range_py", 
      label = "평수를 선택하세요",
      min=0, max=max(apt_price$py_area),
      value = c(0,30))),
    column(12, plotOutput(outputId = "gu_plot", height = "600"))
))

server <- function(input, output, session){
  apt_sel = reactive({
    apt_sel = subset(apt_price, addr_1 == unlist(strsplit(paste(input$resion, collapse= ","), ",")) & py_area >= input$range_py[1] & py_area <= input$range_py[2])
        return(apt_sel)
  })
  
  output$gu_plot <- renderPlot({
    if (nrow(apt_sel()) == 0)
      return(NULL)
    ggplot(apt_sel(), aes(x=py_area, y=py, col="red")) +
      geom_point() + geom_smooth(method = "lm", col="blue") + 
      facet_wrap(~addr_1, scales = 'free_y', ncol = 3) +
      theme(legend.position = "none") +
      xlab("크기(평)") + ylab("평당가격(만원)") + 
      stat_poly_eq(aes(label = paste(..eq.label..)),
                   label.x = "right", label.y = "top",
                   formula = y ~ x, parse = TRUE)
  })
}

shinyApp(ui, server)


