# 4. dataframe
english <- c(90, 80, 60, 70)
math <- c(50,60,100,20)

# create dataframe
df_midterm <- data.frame(english, math)
df_midterm
class <- c(1,1,2,2)
df_midterm <- data.frame(english, math, class)

# define directly
df_mideterm2 <- data.frame(english = c(90,80,70), math = c(20,30,40), class = c(1,2,3))

install.packages("readxl")
library(readxl)

df_exam <- read_excel("R/excel_exam.xlsx")
df_exam

df_exam$english # choose a column
mean(df_exam$english)
mean(df_exam$science)

df_exam_novar <- read_excel("R/excel_exam_novar.xlsx", 
                col_names = F) # no column name 
df_exam_novar

df_exam_sheet <- read_excel("R/excel_exam_sheet.xlsx",
                sheet=3) # choose third sheet of a excel file
df_exam_sheet  

write.csv(df_midterm, file = 'R/df_midterm.csv')

# save RDS file
saveRDS(df_midterm, file='R/df_midterm2.rds')
# RDS file: only for R, small size and fast
rm(df_midterm)
rm(df_mideterm2)

# read RDS file
df_midterm <- readRDS('R/df_midterm2.rds')
df_midterm


exam <- read.csv("r/csv_exam.csv")
head(exam)  # 6 rows
head(exam, 10) # 10 rows
tail(exam)  # last 6 rows
tail(exam, 10) # last 10 rows

View(exam) # see table in view

dim(exam)  # the number of rows and columns
str(exam)  # print type of elements
summary(exam) # like describe() in pandas


# ggplot read mpg data as dataframe

mpg <- as.data.frame(ggplot2::mpg)
mpg
head(mpg)
tail(mpg, 2)
View(mpg)
dim(mpg)
summary(mpg)


# chapter 5-2
install.packages('dplyr')
library(dplyr)
df_raw <- data.frame(var1 = c(1,2,3), var2 = c(2,3,4))
df_raw

df_new <- df_raw
df_new <- rename(df_new, v2 = var2) # rename column var2->v2
df_new

mpg <- rename(mpg, city = cty, highway = hwy)
mpg

# 5-3
df <- data.frame(var1 = c(4,3,8), var2=c(2,6,1))
df

df$var_sum = df$var1 + df$var2 # create new columns using existing columns
df$var_mean = (df$var1 + df$var2) / 2
df

head(mpg, 2)
# total column
mpg$total <- (mpg$city + mpg$highway) / 2
mpg$total
summary(mpg$total)
hist(mpg$total)

# A, B, C by total
mpg$grade <- ifelse(mpg$total >= 30, 'A', ifelse(mpg$total>=20, 'B', 'C'))
head(mpg)
table(mpg$grade)
qplot(mpg$grade)

mpg$grade2 <- ifelse(mpg$total>=30, 'A', 
              ifelse(mpg$total>=25, 'B',
              ifelse(mpg$total>=20, 'C', 'D')))
#head(mpg$grade2)
table(mpg$grade2)
qplot(mpg$grade2)


mpg$test <- ifelse(mpg$total >= 20, 'pass', 'fail')
table(mpg$test)
qplot(mpg$test)
