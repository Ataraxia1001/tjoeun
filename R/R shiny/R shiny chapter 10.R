# 10. application development(data analysis)
# 1.loading data
load("R/06_geodataframe/06_apt_price.rdata")
library(sf)
bnd <- st_read("./sigun_bnd/sigun_bnd/seoul.shp")
getwd()
load("R/07_map/07_kde_high.rdata")
load("R/07_map/07_kde_hot.rdata")
bnd <- st_read("R/sigun_bnd/sigun_bnd/seoul.shp")
grid <- st_read("R/seoul/seoul.shp")

load("R/circle_marker/circle_marker/circle_marker.rdata")


# 2. markercluster
pcnt_10 <- as.numeric(quantile(apt_price$py, probs = seq(.1, .9, by=.1))[1])
pcnt_90 <- as.numeric(quantile(apt_price$py, probs = seq(.1, .9, by=1))[9])
circle.colors <- sample(x=c("red", "green", "blue"), size = 1000, replace = T)

# 3. interactive map
library(leaflet)
library(purrr)
install.packages("raster")
library(raster)
library(sf)
leaflet() %>% 
  addTiles(option = providerTileOptions(minZoom = 9, maxZoom=18)) %>% 
  # max price KDE
  addRasterImage(raster_high, colors = colorNumeric(c("blue", "green", "yellow", "red"),
                              values(raster_high), na.color = "transparent"), 
                              opacity = 0.4,
                 group = "2021 최고가") %>% 
  addRasterImage(raster_hot, colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                                    values(raster_high), 
                                                   na.color="transparent"), 
                 opacity = 0.4,
                 group = "2021 급등가") %>%       
  addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"), 
                   options = layersControlOptions(collapsed = FALSE)) %>% 
  addPolygons(data = bnd, weight = 3, stroke = T, color = "red", fillOpacity = 0) %>% 
  addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry, 1)),
                   lat = unlist(map(apt_price$geometry, 2)), radius = 10, stroke = FALSE,
                   fillOpacity = 0.6, fillColor = circle.colors, weight = apt_price$py,
                   clusterOptions = markerClusterOptions(iconCreateFunction=JS(avg.formula))
)     






# 10-2 map application
grid <- as(grid, "Spatial")
grid <- as(grid, "sfc")
grid <- grid[which(sapply(st_contains(st_sf(grid), apt_price), length)>0)]

plot(grid)

m <- leaflet() %>% 
  addTiles(options = providerTileOptions(minZoom = 9, maxZoom=18)) %>% 
  # max price KDE
  addRasterImage(raster_high, colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                                    values(raster_high), na.color = "transparent"), 
                 opacity = 0.4,
                 group = "2021 최고가") %>% 
  addRasterImage(raster_hot, colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                                   values(raster_high), 
                                                   na.color="transparent"), 
                 opacity = 0.4,
                 group = "2021 급등가") %>%       
  addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"), 
                   options = layersControlOptions(collapsed = FALSE)) %>% 
  addPolygons(data = bnd, weight = 3, stroke = T, color = "red", fillOpacity = 0) %>% 
  addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry, 1)),
                   lat = unlist(map(apt_price$geometry, 2)), radius = 10, stroke = FALSE,
                   fillOpacity = 0.6, fillColor = circle.colors, weight = apt_price$py,
                   clusterOptions = markerClusterOptions(iconCreateFunction=JS(avg.formula))
) %>% 
leafem::addFeatures(st_sf(grid), layerId = ~seq_len(length(grid)), color = 'grey')

m

library(shiny)
install.packages("mapedit")
library(mapedit)
library(dplyr)

ui <- fluidPage(
  selectModUI("selectmap"), textOutput("sel") 
)

server <- function(input, output) {
  callModule(selectMod, "selectmap", m)
  output$sel <- renderPrint({df()[1]})
}

shinyApp(ui, server)


# 10-3 make map interactive

install.packages("DT")

library(DT)

ui <- fluidPage(
  fluidRow(
    column(9, selectModUI("selectmap"), div(style = "height:45px")),
    column(3,
           sliderInput("range_area", "전용면적", sep="", min=0, 
                       max=350, value=c(0,200)),
           sliderInput("range_time", "건축연도", sep="", min=1960,
                       max=2020, value = c(1980, 2020)), ),
    column(12, dataTableOutput(outputId = "table"), div(style = "height:200px"))
))


server <- function(input, output, session){
  
  apt_sel = reactive({
    apt_sel = subset(apt_price, con_year >= input$range_time[1] & con_year <= input$range_time[2]
    & area >= input$range_area[1] & area <= input$range_area[2])
    return(apt_sel)})
}








# input, output module

g_sel <- callModule(selectMod, 'selectmap',
                    leaflet() %>% 
                      addTiles(options = providerTileOptions(minZoom =9, maxZoom=18)) %>% 
                      # 최고가지역 KDE
                      addRasterImage(raster_high, 
                                     colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                                           values(raster_high), na.color = "transparent"), opacity = 0.4,
                                     group = "2021 최고가") %>% 
                      addRasterImage(raster_hot, 
                                     colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                                           values(raster_hot), na.color = "transparent"), opacity = 0.4,
                                     group = "2021 급등지") %>% 
                      addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"),
                                       options = layersControlOptions(collapsed =FALSE)) %>% 
                      addPolygons(data=bnd, weight = 3, stroke = T, color = "red", fillOpacity = 0) %>% 
                      addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry, 1)),
                                       lat = unlist(map(apt_price$geometry, 2)), radius = 10, stroke = FALSE, fillOpacity = 0.6, fillColor = circle.colors, weight = apt_price$py,
                                       clusterOptions = markerClusterOptions(iconCreateFunction=JS(avg.formula))) %>% 
                      leafem::addFeatures(st_sf(grid), layerId= ~seq_len(length(grid)), color = 'grey'))


# save result
# set initial value
 
rv <- reactiveValues(intersect=NULL, selectgrid=NULL)

observe({ 
  gs <- g_sel()
  rv$selectgrid <- st_sf(grid[as.nummeric(gs[which(gs$selected==TRUE), "id"])])
  if(length(rv$selectgrid) > 0){
    rv$intersect <- st_intersects(rv$selectgrid, apt_sel())
    rv$sel <- st_drop_geometry(apt_price[apt_price[unlist(rv$intersect[1:10]),],])
  }else{
    rv$intersect <- NULL
  }
})

 output$table <- DT::renderDataTable({
  dplyr::select(rv$sel, ymd, addr_1, apt_nm, price, area, floor, py) %>% 
  arrange(desc(py))}, extensions = "Buttons", options = list(dom= 'Bfrtip', scrollY = 300,
                                                             scrollCollapse = T, paging = TRUE,
                                                             buttons = c('excel')))
  
}

















