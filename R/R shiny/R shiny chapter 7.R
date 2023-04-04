load("./06_geodataframe/06_apt_price.rdata")
grid <- st_read("R/seoul/seoul.shp") # 서울시 1km 격자

apt_price <- st_join(apt_price, grid, join=st_intersects)

kde_before <- subset(apt_price, ymd < "2021-07-01")
kde_after <- subset(apt_price, ymd >= "2021-07-01")

# 전반기 ID별 가격 평균 집계
kde_before <- aggregate(kde_before$py, by=list(kde_before$ID), mean)     
kde_after <- aggregate(kde_after$py, by=list(kde_after$ID), mean)
head(kde_before)

colnames(kde_before) <- c("ID", "before")
head(kde_before)
colnames(kde_after) <- c("ID", "after")

kde_diff <- merge(kde_before, kde_after, by = "ID")
kde_diff$diff <- round((((kde_diff$after - kde_diff$before)/kde_diff$before)*100),0)
# 증가율
head(kde_diff, 2)
# 가격이 오른 지역 확인하기
library(sf)
kde_diff <- kde_diff[kde_diff$diff > 0, ] # 상승지역만 추출

kde_hot <- merge(grid, kde_diff, by="ID")
library(ggplot2)
library(dplyr)
kde_hot %>% 
  ggplot(aes(fill=diff)) + geom_sf() + scale_fill_gradient(low = "white", high = "red")


# 지도 경계선 그리기
library(sp)


kde_hot_sp <- as(st_geometry(kde_hot), 'Spatial') 
# sf -> sp 변환: 지도작업을 수월하게 진행하기 위함

x <- coordinates(kde_hot_sp)[,1]
y <- coordinates(kde_hot_sp)[,2]

#bbox로 l1~l4까지 외곽끝점을 나타내는 좌표4개를 추출하는데 약간의 여유를 주고자
# 0.1%를 추가함
l1 <- bbox(kde_hot_sp)[1,1] -(bbox(kde_hot_sp)[1,1]*0.0001)
l2 <- bbox(kde_hot_sp)[1,2] +(bbox(kde_hot_sp)[1,2]*0.0001)
l3 <- bbox(kde_hot_sp)[2,1] -(bbox(kde_hot_sp)[2,1]*0.0001)
l4 <- bbox(kde_hot_sp)[2,2] +(bbox(kde_hot_sp)[2,2]*0.0001)

library(spatstat)
win <- owin(xrange = c(l1, l2), yrange=c(13,14))
plot(win)

#rm(list = c("kde_hot_sp", "apt_price", "l1", "l2", "l3", "l4")) #변수정리 

# 6단계 밀도 그래프 표시
p <- ppp(x, y, window = win) # 경계창 위에 좌표값 포인트생성

d <- density.ppp(p, weights = ..........., 
                 sigma = bw.diggle(p), kernel = 'gaussian')


# 7단계 픽셀이미지를 레스터 이미지로 변환
d[d < quantile(d)[4] + (quantile(d)[4]*0.1)] <- NA
#전체 하위 75% NA 처리

library(raster)
raster_high <- raster(d)
plot(raster_high)



bnd <- st_read("R/sigun_bnd/seoul.shp") # 서울시 경계선
raster_high <- crop(raster_high, extent(bnd))
#외곽선 자르기
crs(raster_high) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WG84 + 
                            towgs84=0,0,0")

#좌표계 정의
plot(raster_high)
plot(bnd, col=NA, border='red', add=TRUE)


dir.create('07_map')
save(raster_high, file= "./07_map/07_kde_hot.rdata")
rm(list = ls()) # 메모리 정리 = 빗자루 클릭
