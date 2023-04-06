load("./06_geodataframe/06_apt_price.rdata")
library(sf)
apt_price <- st_drop_geometry(apt_price)
apt_price$py_area <- round(apt_price$area / 3.3, 0)
head(apt_price$py_area)
require(showtext)
font_add_google(name = "Nanum Gothic", regular.wt = 400, bold.wt = 700)
showtext_auto()
showtext_opts(dpi=112)

library(shiny)

# shiny UI
ui <- fluidPage(
  titlePanel("아파트가격 상관관계분석"),
  sidebarPanel(
    selectInput(inputId = "sel_gu",
                label = "지역을 선택하세요", 
                choices = unique(apt_price$addr_1), 
                selected = unique(apt_price$addr_1)[1]), # default
    sliderInput(inputId = "range_py", 
                label = "평수",
                min=0, max=max(apt_price$py_area),
                value = c(0,30)),
    selectInput(inputId="var_x",
                label = "x축 변수를 선택하세요", # x-axis variable
                choices = list("매매가(평당)" = "py",
                              "크기(평)" = "py_area", 
                              "건축 연도" = "con_year", 
                              "층수" = "floor"),
                selected = "py_area"),
    selectInput(inputId = "var_y", 
                label = "y축 변수를 선택하세요",
                choices = list("매매가(평당)" = "py",
                              "크기(평)" = "py_area", 
                              "건축 연도" = "con_year", 
                              "층수" = "floor" ),
                selected = "py"),
    checkboxInput(inputId = "corr_checked", label = "상관계수", value = TRUE),
    checkboxInput(inputId = "reg_checked", label = "회귀계수", value = TRUE)
  ),
  mainPanel(h4("플로팅"), plotOutput("scatterPlot"),
            h4("상관계수"), verbatimTextOutput("corr_coef"), 
            h4("회귀계수"), verbatimTextOutput("reg_fit")
  )
  
)

server <- function(input, output, session){
  apt_sel = reactive({
    apt_sel = subset(apt_price, addr_1 == input$sel_gu &
                       py_area >= input$range_py[1] & 
                       py_area <= input$range_py[2])
    return(apt_sel)    
  })
  output$scatterPlot <- renderPlot({
    var_name_x <- as.character(input$var_x)  # x-axis name
    var_name_y <- as.character(input$var_y)  # y-axis name
    plot(
      apt_sel()[, input$var_x],
      apt_sel()[, input$var_y],
      xlab = var_name_x, 
      ylab = var_name_y, 
      main = "플로팅")
     fit <- lm(apt_sel()[, input$var_y] ~ apt_sel()[, input$var_x]) 
     abline(fit, col="red")
    
  })
  # 상관계수
  output$corr_coef <- renderText({
    if(input$corr_checked){
      cor(apt_sel()[, input$var_x],
          apt_sel()[, input$var_y])
      
    }
  })
  output$reg_fit <- renderPrint({
    if (input$reg_checked){
      fit <- lm(apt_sel()[, input$var_y] ~ apt_sel()[,input$var_x])
      names(fit$coefficients) <- c("Intercept", input$var_x)
      summary(fit)$coefficients
    }
  })
}


shinyApp(ui, server)





























