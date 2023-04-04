getwd()
load("./08_chart/all.rdata")
load("./08_chart/sel.rdata")

#8-2 probability density


max_all <- density(all$py)
max_sel <- density(sel$py)
head(max_all, 2)

max_all <- max(max_all$y)
max_all
max_sel <- max(max_sel$y)
max_sel

plot_high <- max(max_all, max_sel)  # max of y-axis
#rm(list = c("max_all", "max_sel"))

# get mean values
avg_all <- mean(all$py)
avg_sel <- mean(sel$py)
avg_all; avg_sel; plot_high

# probability density plot
plot(stats::density(all$py), ylim=c(0, plot_high), col="blue", lwd=3, main=NA)
abline(v= mean(all$py), lwd=2, col="blue", lty=2) # abline makes vertical line of mean value
text(avg_all+ (avg_all)*0.15, plot_high*0.1, sprintf("%.0f", avg_all), srt=0.2,
      col = "blue")  
lines(stats::density(sel$py), col="red", lwd=3)
abline(v = mean(sel$py), lwd=2, col="red", lty=2)
text(avg_sel+(avg_sel)*0.15, plot_high*0.1, sprintf("%.0f", avg_sel), srt=0.2,
     col="red")  # text writes a mean value on the plot.



# all$month <- as.numeric(all$month)
# all$month <- as.numeric(sel$month)
# class(all$month)
# class(all$ymd)
# 
# all$ymd <- as.POSIXct(all$ymd)
# class(all$geometry)


# 8-3 regression analysis
library(dplyr)
#install.packages("lubridate")
library(lubridate)
all <- all %>% select(-one_of("geometry"))
sel <- sel %>% select(-one_of("geometry"))

all <- all %>% group_by(month = floor_date(ymd, "month")) %>% 
  summarise(all_py = mean(py))

sel <- sel %>% group_by(month = floor_date(ymd, "month")) %>% 
  summarise(sel_py = mean(py))

all


# regression model
fit_all <- lm(all$all_py ~ all$month)  
fit_sel <- lm(sel$sel_py ~ sel$month) 
fit_all
fit_all$coefficients[2]
round(summary(fit_all)$coefficients[2], 1)
coef_all <- round(summary(fit_all)$coefficients[2], 1)*365
coef_sel <- round(summary(fit_sel)$coefficients[2], 1)*365
coef_all
# regression plot
library(grid)
grob_1 <- grobTree(textGrob(paste0("전체지역", coef_all, "만원(평당)"), x=0.12, y=0.88,
                            gp = gpar(col="blue", fontsize=12, fontface="italic")))
grob_2 <- grobTree(textGrob(paste0("관심지역", coef_sel, "만원(평당)"), x=0.12, y=0.95,
                            gp = gpar(col="red", fontsize=12, fontface="italic")))

library(ggplot2)

#install.packages("ggpmisc")
library(ggpmisc)

gg <- ggplot(sel, aes(x=month, y=sel_py)) + geom_line() + xlab("월") + ylab("가격") +
  theme(axis.text.x = element_text(angle=90)) + 
  stat_smooth(method = "lm", colour="dark grey", linetype="dashed") + theme_bw()

gg + geom_line(color="red", size = 1.5) + geom_line(data=all, aes(x=month, y=all_py),
                                                    color="blue",size=1.5) +
  annotation_custom(grob_1) + annotation_custom(grob_2)



