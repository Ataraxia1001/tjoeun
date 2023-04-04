load("./06_geodataframe/06_apt_price.rdata")
getwd()

library(sf)
class(apt_price)

grid <- st_read("R/seoul/seoul.shp")
apt_price <- st_as_sf(apt_price)

# 1. 지역별 평균가격구하기 위해 데이터 결합
apt_price <- st_join(apt_price, grid, join=st_intersects)


#grid <- st_as_crs(grid)

class(grid)


# 2. 그리드 + 평균가격 결합
kde_high <- aggregate(apt_price$py, by=list(apt_price$ID), mean)


head(kde_high,2)
colnames(kde_high) <- c("ID", "avg_price")
head(kde_high,2)

# 3단계 그리드 + 평균가격 결합
kde_high <- merge(grid, kde_high, by= "ID")
head(kde_high, 2)

# 4단계 지도 그리기
library(ggplot2)
library(dplyr)
kde_high %>% ggplot(aes(fill=avg_price)) + geom_sf() 
+ scale_fill_gradient(low="white", high = "red")

# 5단계 지도의 경계
library(sp)
kde_high_sp <- as(st_geometry(kde_high), 'Spatial') 
# sf -> sp 변환: 지도작업을 수월하게 진행하기 위함

x <- coordinates(kde_high_sp)[,1]
y <- coordinates(kde_high_sp)[,2]

#bbox로 l1~l4까지 외곽끝점을 나타내는 좌표4개를 추출하는데 약간의 여유를 주고자
# 0.1%를 추가함
l1 <- bbox(kde_high_sp)[1,1] -(bbox(kde_high_sp)[1,1]*0.0001)
l2 <- bbox(kde_high_sp)[1,2] +(bbox(kde_high_sp)[1,2]*0.0001)
l3 <- bbox(kde_high_sp)[2,1] -(bbox(kde_high_sp)[2,1]*0.0001)
l4 <- bbox(kde_high_sp)[2,2] +(bbox(kde_high_sp)[2,2]*0.0001)


install.packages("spatstat")
library(spatstat)
win <- owin(xrange = c(l1, l2), yrange=c(l3,l4))
plot(win)

#rm(list = c("kde_high_sp", "apt_price", "l1", "l2", "l3", "l4")) #변수정리 


# 6단계 밀도 그래프 표시
p <- ppp(x, y, window = win) # 경계창 위에 좌표값 포인트생성

d <- density.ppp(p, weights = kde_high$avg_price, 
                 sigma = bw.diggle(p), kernel = 'gaussian')


# 7단계 픽셀이미지를 레스터 이미지로 변환
d[d < quantile(d)[4] + (quantile(d)[4]*0.1)] <- NA
#전체 하위 75% NA 처리
install.packages("raster")
library(raster)
raster_high <- raster(d)
plot(raster_high)
getwd()
# 8단계 클리핑
bnd <- st_read("R/sigun_bnd/sigun_bnd/seoul.shp") # 서울시 경계선
raster_high <- crop(raster_high, extent(bnd))
#외곽선 자르기
crs(raster_high) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WG84 + 
                            towgs84=0,0,0")


#좌표계 정의
plot(raster_high)
plot(bnd, col=NA, border='red', add=TRUE)


# 9단계 지도그리기
install.packages("rgdal")
library(rgdal)
library(leaflet)
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = bnd, weight = 3, color = "red", fill = NA) %>% 
  addRasterImage(raster_high, 
                 colors = colorNumeric(c("blue","green", "yellow", "red"),
                 values(raster_high), na.color = "transparent"), opacity = 0.4)


dir.create('07_map')
save(raster_high, file= "./07_map/07_kde_high.rdata")
rm(list = ls()) # 메모리 정리 = 빗자루 클릭
