a <- 1
b <- 2
c <- 3
d <- 3.5
a+b+c


4/b
5*b
var1 <- c(1,2,5,7,8)
var2 <- c(1:5)
var2
var3 <- seq(1,5)
var3
var4 <- seq(1,10,2)
var4
var5 <- seq(1,10,3)
var5
var1 + 2
str4 <- "hello"
x <- c(1,2,3)
# �Լ�����
mean(x)
max(x)
min(x)
# �ϳ��� ��ġ�� (���� collapse)
paste(str4, collapse = ',')
paste(str4, collapse = ' ')
x_mean <- mean(x)
install.packages("ggplot2")
library(ggplot2)
x <- c("a", "a", "b", "c")
# �󵵱׷��� 
qplot(x)
# �����Ϳ� mpg, x�� hwy ���������ؼ� �׷��� ����
qplot(data = mpg, x = hwy)
qplot(data = mpg, x = cty)
# x = drv, y = hwy
qplot(data = mpg, x = drv, y = hwy)
qplot(data = mpg, x = drv, y = hwy, geom = "line")
qplot(data = mpg, x = drv, y = hwy, geom = "boxplot")
qplot(data = mpg, x = drv, y = hwy, geom = "boxplot", colour = drv)
?qplot




