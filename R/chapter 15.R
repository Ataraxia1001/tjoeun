exam <- read.csv("csv_exam.csv")
exam[]

exam[1, ]  # get first row
exam[2, ]  # get second row

# rows with class = 1 
exam[exam$class == 1, ]  # , is necessary at the end. column is not specified.
exam[exam$math >= 80, ]


exam[exam$class == 1 & exam$math >= 50, ]
exam[exam$english < 90 | exam$science < 50, ]

# exam row

exam[ , 1] # first column
exam[ , 2] # second column
exam[ , "class"] # column name is class
exam[ , "math"]  # column name is math
exam[ , c("math", "english", "science")]

# row + column
exam[1, 3] # first row and third column
exam[5, 'english']
exam[exam$math >= 50, 'english']
exam[exam$math >= 50, c('english', 'science')]

exam$tot <- (exam$math + exam$science + exam$english)/3
head(exam)
aggregate(data = exam[exam$math>=50 & exam$english>=80, ], tot~class, mean)
# it is same as filter + group_by(class) + summarise(...mean(tot)...)

library(dplyr)
exam %>% 
  filter(math >= 50 & english >= 80) %>% 
  mutate(tot = (math + english + science)/3) %>% 
  group_by(class) %>% 
  summarise(mean = mean(tot))

# 15-2 
var1 <- c(1,2,3,1,2)  # numeric
var2 <- factor(c(1,2,3,1,2)) # categorical

var1 + 2
var2 + 2 # (category + integer) is not possible
class(var1)
class(var2)
levels(var1)
levels(var2)

var3 <- c("a", "b", "b", "c")
var4 <- factor(c("a", "b", "b", "c")) # factor: categorical
class(var3)
class(var4)
mean(var1)
mean(var2) # no mean for category

var2 <- as.numeric(var2)
class(var2)
mean(var2)
levels(var2)

# exercise
mpg <- as.data.frame(ggplot2::mpg)
class(mpg$drv) # character: string
mpg$drv <- factor(mpg$drv)
class(mpg$drv)


# 15-3 data structure
a <- 1 # vector
a
b <- "hello"
b
class(a)
class(b)

# data frame
x1 <- data.frame(var1 = c(1,2,3), var2 = c("a", "b", "c"))
x1  # data frame
class(x1)

x2 <- matrix(c(1:12), ncol=2)
x2   # matrix
class(x2)


x3 <- array(1:20, dim = c(2,5,2))
x3   # 3 dimensional array
class(x3)


x4 <- list(f1=a, f2=x1, f3=x2, f4=x3) # create a list
      #vector, dataframe, matrix, array
x4


x <- boxplot(mpg$cty)
x$stats[,1]  # 5 values = min, 4Qr, median, 3Qr, max,
x$stats[,1][3]  # median
x$stats[,1][2]  # 4Qr











