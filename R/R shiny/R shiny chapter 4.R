load("./03_apt_price.rdata")
head(apt_price, 2)
# 1. check NA -> remove NA
table(is.na(apt_price))
apt_price <- na.omit(apt_price)  # remove NA
table(is.na(apt_price)) # check NA again -> no NA

# 2. preprocess string
library(stringr)
apt_price <- as.data.frame(apply(apt_price, 2, str_trim)) #공백 제거
# apply: 1 is row, 2 is column
head(apt_price$price, 2)

# 3. preprocess data
install.packages('lubridate') # make_date() method
library(lubridate)
library(dplyr)
apt_price <- apt_price %>% 
               mutate(ymd = make_date(year, month, day))  # YYYY-MM-DD


apt_price$ym <- floor_date(apt_price$ymd, "month")
# 월로 바꿔서 컬럼 생성


head(apt_price, 2)

# 3-2 매매가 확인후 숫자로 변경
head(apt_price$price, 4)
apt_price$price <- apt_price$price %>% 
  sub(",", "",.) %>% as.numeric()
head(apt_price, 2)

# 3-3 주소 조합
head(apt_price$apt_nm, 30)
apt_price$apt_nm <- gsub("\\(.*","",apt_price$apt_nm)
head(apt_price$apt_nm, 30)
# 3-3 아파트이름 지역코드, 주소를 조합
loc <- read.csv('R/data/sigun_code.csv', fileEncoding = "UTF-8")
apt_price <- merge(apt_price, loc, by= 'code')
head(apt_price, 3)

# combine all in one address
apt_price$juso_jubun <- paste0(apt_price$addr_2, " ", 
                               apt_price$dong_nm, " ",
                               apt_price$jibun, " ",
                               apt_price$apt_nm)
head(apt_price, 3)

# 4단계 건축연도 숫자로 변환
class(apt_price$con_year)
apt_price$con_year <- as.numeric(apt_price$con_year)
class(apt_price$con_year)

# 5단계 평당매매가. 소수점은 round를 0으로. *3.3 -> 평으로 변환
# class(apt_price$area)
# apt_price$area <- as.numeric(apt_price$area)
# class(apt_price$area)
# apt_price <- apt_price %>% mutate(price_pyeong = round(price/(area*3.3))) 

# solution
apt_price$area <- apt_price$area %>%  as.numeric() %>% round(0)
apt_price$py <- round(((apt_price$price/apt_price$area)*3.3), 0)

                                  
                                  
# 6단계 층수 변환 숫자로 변환후에 절대값반환
apt_price$floor <- as.numeric(apt_price$floor)
apt_price$floor <- abs(apt_price$floor)

apt_price$cnt <- 1  # all numbers are 1 in cnt column
head(apt_price)


# 7. save df in a new directory
apt_price <- apt_price %>% 
  select(ymd, ym, year, code, addr_1, apt_name, juso_jubun, price, con_year, area, 
         floor, py, cnt)
head(apt_price, 2)
dir.create("./04_preprocess")
save(apt_price, file = "./04_preprocess/04_preprocess.rdata")
write.csv(apt_price, "./04_preprocess/04_preprocess.csv")














