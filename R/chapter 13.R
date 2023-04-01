library(ggplot2)
library(dplyr)

mpg <- as.data.frame(ggplot2::mpg)

# Does class make difference in cty?
# Is it coincidence? (p-value)
mpg_diff <- mpg %>%  
  select(class, cty) %>% 
  filter(class %in% c("compact", "suv"))

head(mpg_diff)
table(mpg_diff$class)

# t-test
t.test(data=mpg_diff, cty ~ class, var.equal = T)
# low p-value --> statistically significant


# fl makes difference in cty?
mpg_diff2 <- mpg %>% 
  select(fl, cty) %>% 
  filter(fl %in% c('r', 'p'))  # regular, premium

table(mpg_diff2$fl)
t.test(data = mpg_diff2, cty ~ fl, var.equal = T)
# p-value 0.2875 > 0.05 --> 28.75% coincidence


# correlation analysis
eco <- as.data.frame(ggplot2::economics)
cor.test(eco$pce, eco$pop)
cor.test(eco$unemploy, eco$pce)


# heat matrix
head(mtcars)
car_cor <- cor(mtcars)
car_cor
install.packages("corrplot")
library(corrplot)
corrplot(car_cor)  # values are shown with color
corrplot(car_cor, method = "number") # values are shown with number

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))

corrplot(car_cor, method = 'color', col=col(200), 
         type = "lower", 
         order = 'hclust', # gather similar variables(high corr)
         addCoef.col = "green",  # color of values
         tl.col = "black", # color of variables
         tl.srt = 45,  # angle of variable name
         diag = F   # remove diagonal elements
         )







