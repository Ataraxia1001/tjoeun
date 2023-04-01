install.packages("mapproj")
install.packages("ggiraphExtra")
library(ggiraphExtra)

str(USArrests)
head(USArrests)

library(tibble) # installed with dplyr 
crime <- rownames_to_column(USArrests, var='state')
crime$state <- tolower(crime$state)
str(crime)
# fetch US map
install.packages("maps")
library(ggplot2)
library(ggiraphExtra)
state_map <- map_data("state")
str(state_map)

ggChoropleth(data = crime, aes(fill = Murder, map_id = state), 
             map=state_map, interactive = T)



# 11-2

install.packages('stringi')
install.packages('devtools')
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)  # many datas with korean map 
str(changeCode(korpop1))
library(dplyr)
korpop1 <- rename(korpop1, 
                  pop = 총인구_명, 
                  name = 행정구역별_읍면동
                  )

korpop1$name <- iconv(korpop1$name, "UTF-8", "CP949")
View(korpop1)
str(changeCode(kormap1))

ggChoropleth(data = korpop1, 
             aes(fill = pop,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)



# 결핵환자수 데이터
str(changeCode(tbc))
tbc$name <- iconv(tbc$name, "UTF-8", "CP949")  

View(tbc)







