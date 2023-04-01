install.packages("plotly")
library(plotly)  
library(ggplot2)
p <- ggplot(data = mpg, aes(x=displ, y=hwy, col=drv)) + geom_point()

ggplotly(p) # one can see the values on the plot using mouse interactively


d <- ggplot(data = diamonds, aes(x=cut, fill=clarity)) +geom_bar(position = "dodge")

ggplotly(d)


# interactive time series graph
install.packages("dygraphs")
library(dygraphs)
eco <- ggplot2::economics
head(eco)
library(xts)
eco1 <- xts(eco$unemploy, order.by = eco$date)
dygraph(eco1)

dygraph(eco1) %>% dyRangeSelector()  # select range below plot


# percentage of saving
eco_a <- xts(eco$psavert, order.by = eco$date)
# unemplyment
eco_b <- xts(eco$unemploy/1000, order.by = eco$date)
eco2 <- cbind(eco_a, eco_b)
# change column name

# rename cannot be used in xts type -> colnames with c(,)
colnames(eco2) <- c("psavert", "unemploy")
head(eco2)
dygraph(eco2) %>% dyRangeSelector()

