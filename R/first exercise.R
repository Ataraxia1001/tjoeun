# exercise 1
25+99
456-123
2*(3+4)
(3+5*6)/7
(7-4)*3
2^10 + 3^5
1256%%7
184%%5
1976/24
16*25+186*5-67*22

# exercise 2
pi <- 3.141592
r1 <- 10 
r2 <- 15 
r3 <- 20
r1^2
area1 <- pi*r1^2
area2 <- pi*r2^2
area3 <- pi*r3^2
area1

x <- c(6,8,10)
y <- 2*x^2 + 5*x + 10
y

# exercise 3
d <- c(101:200) # or d <- 101:200
d
d[10]
d[90:100]
d_cut <- tail(d, 10) # last 10 elements
d_cut
d[seq(2,100,2)] # or d[d%%2 == 0]
d.20 <- d[1:20]
d.20
d.20[-5]
d.20[-seq(5,9,2)]

# exercise 4
d1 <- c(1:50)
d1
d2 <- c(51:100)
d2
d1+d2
d2-d1
d1*d2
d2/d1
sum(d1)
sum(d2)
sum(d1+d2)
max(d2)
min(d2)
mean(d1)
mean(d2)
mean(d2) - mean(d1)
sort(d1, decreasing = TRUE)
d3.1 <- sort(d1, decreasing = TRUE)[1:10]
d3.1
d3.2 <- sort(d2, decreasing = TRUE)[1:10]
d3.2
d3 <- c(d3.1, d3.2)
d3

# exercise 5
v1 <- c(51:90)
v1
v1[v1<60]
sum(v1>60) # the number of v1>60 elements
sum(v1[v1>60]) # sum of v1>60 elements
v1[60<v1 & v1<73]
con <- 60<v1 & v1<73
v1[con]
con2 <- v1<65 | v1>80
v1[con2]
con3 <- v1%%7 == 3
v1[con3]
sum(v1[seq(2,40,2)])
con4 <- v1%%2 == 1 | v1>80
v1[con4]
con5 <- v1%%3==0 | v1%%5==0
v1[con5]
