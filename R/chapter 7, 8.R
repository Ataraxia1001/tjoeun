# 7 data cleaning
# 7-1 deal with NaN
library(dplyr)

df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5,4,3,4,NA))

df
is.na(df)
table(is.na(df))
table(is.na(df$sex))
table(is.na(df$score))

df %>% filter(is.na(score))  # get NA of score
df %>% filter(!is.na(score)) # get rows without NA of score
df_nomiss <- df %>% filter(!is.na(score))
df_nomiss
df_nomiss <- df %>% filter(!is.na(score) & !is.na(sex))
df_nomiss

df_nomiss2 <- na.omit(df)
df_nomiss2

mean(df$score, na.rm = T)
sum(df$score)

exam <- read.csv('R/csv_exam.csv')

# make NA in 3, 8, 15 rows of math
exam[c(3, 8, 15), "math"] <- NA

View(exam)

exam %>%  summarise(mean_math = mean(math))

# remove NA in math and calculate mean, sum, median
exam %>%  summarise(mean_math = mean(math, na.rm = T))
exam %>%  summarise(mean_math = mean(math, na.rm = T), sum_math = sum(math, na.rm = T),
                    median_math = median(math, na.rm =T))


# replace mean
mean(exam$math, na.rm = T)
table(is.na(exam$math))
exam$math <- ifelse(is.na(exam$math), 55, exam$math)
table(is.na(exam$math))
mean(exam$math)


# exercise
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA

table(is.na(mpg$drv))
table(is.na(mpg$hwy))
#View(mpg)
mpg %>% filter(!is.na(hwy)) %>% 
        group_by(drv) %>% 
        summarise(mean_hw = mean(hwy)) 

# 7-2 remove outlier

outlier <- data.frame(sex = c(1,2,1,3,2,1), score = c(5,4,3,4,2,6))
outlier

table(outlier$sex)
table(outlier$score)

# sex == 3 --> NA
outlier$sex <- ifelse(outlier$sex == 3, NA, outlier$sex)
table(is.na(outlier$sex))
# score > 5 --> NA
outlier$score <- ifelse(outlier$score > 5, NA, outlier$score)
table(is.na(outlier$score))
outlier %>% filter(!is.na(sex) & !is.na(score)) %>%  # remove NA in both sex and score
  group_by(sex) %>% summarise(mean_score = mean(score))

mpg <- as.data.frame(ggplot2::mpg)
boxplot(mpg$hwy)


# NA for <12 or >37 

mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm = T)) # get sum without NA

# exercise
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10,14,58,93), "drv"] <- "k" # k is outlier
table(mpg$drv)
#mpg$drv <- ifelse(mpg$drv == "k", NA,  mpg$drv)
mpg$drv <- ifelse(mpg$drv %in% c("4", "f", "r"), mpg$drv, NA)



boxplot(mpg$cty)$stats  # get the values of boxplot 
mpg$cty <- ifelse(mpg$cty < 9 | mpg$cty > 26, NA, mpg$cty)
boxplot(mpg$cty)

mpg %>% filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_city = mean(cty))

######################################################

library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
# x: displ, y: hwy
ggplot(data=mpg, aes(x=displ, y=hwy)) +
  geom_point() +
  xlim(3, 6) +
  ylim(10, 30)


# exercise
ggplot(data=mpg, aes(x=cty, y=hwy)) + 
  geom_point()

midwest <- as.data.frame(ggplot2::midwest)
ggplot(data=midwest, aes(x=poptotal, y=popasian)) +
  geom_point() +
  xlim(0, 500000) +
  ylim(0, 10000)



library(dplyr)
df_mpg <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))

df_mpg
ggplot(data = df_mpg, aes(x=reorder(drv, -mean_hwy), y=mean_hwy)) + 
   geom_col()   # bar plot  


ggplot(data=mpg, aes(x=drv)) + geom_bar() # geom_bar: y-axis is count
ggplot(data=mpg, aes(x=hwy)) + geom_bar()

# exercise
mpg5 <- mpg %>% filter(class == 'suv') %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

mpg5

ggplot(data = mpg5, aes(x = reorder(manufacturer, -mean_cty), y = mean_cty)) + 
  geom_col()


ggplot(data = mpg, aes(x=class)) + geom_bar()



eco <- as.data.frame(ggplot2::economics)

ggplot(data=eco, aes(x=date, y=psavert)) + geom_line() # line plot


mpg_box <- mpg %>% filter(class =='compact' | class == 'subcompact' | class == 'suv') 

mpg_box
ggplot(data=mpg_box, aes(x=class, y=cty)) + geom_boxplot()


